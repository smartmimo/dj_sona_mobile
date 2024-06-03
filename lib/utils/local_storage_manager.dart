import 'dart:convert';
import 'dart:io';

import 'package:djsona_mobile/constants/app_constants.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageManager {
  static const int _maxItemsInHistory = 10;

  static _writeFile(String path, Map<String, dynamic> content) {
    List<int> compressedData = GZipCodec().encode(
      utf8.encode(
        jsonEncode(content),
      ),
    );

    File(path).writeAsBytes(compressedData);
  }

  static Map<String, dynamic> _readFile(String path) {
    return jsonDecode(
      utf8.decode(
        GZipCodec().decode(File(path).readAsBytesSync()),
      ),
    );
  }

  static void _addSongToFolder({
    required SongItem item,
    required String path,
    int? maxItems,
  }) async {
    final Directory dir = Directory("${(await getApplicationDocumentsDirectory()).path}/$path");
    if (!dir.existsSync()) dir.createSync();

    final List<FileSystemEntity> files = dir.listSync();
    files.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    if (maxItems != null && files.length >= maxItems) files.last.delete();

    _writeFile("${dir.path}/${item.id}.json", item.toJson());
  }

  static void _removeSongFromFolder({
    required SongItem item,
    required String path,
  }) async {
    final Directory dir = Directory("${(await getApplicationDocumentsDirectory()).path}/$path");
    File("${dir.path}/${item.id}.json").delete();
  }

  static Future<List<SongItem>> _listSongsFromFolder({
    required String path,
    bool isFullPath = false,
  }) async {
    final Directory dir = Directory(
      isFullPath ? path : "${(await getApplicationDocumentsDirectory()).path}/$path",
    );
    if (!dir.existsSync()) return [];

    final List<FileSystemEntity> files = dir.listSync();
    files.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    return files.map((file) {
      return SongItem.fromJson(
        _readFile(file.absolute.path),
      );
    }).toList();
  }

  static void addToHistory(SongItem item) async {
    return _addSongToFolder(
      item: item,
      path: AppConstants.historyFolderName,
      maxItems: _maxItemsInHistory,
    );
  }

  static Future<List<SongItem>> listHistory() async {
    return _listSongsFromFolder(path: AppConstants.historyFolderName);
  }

  static Future<void> clearHistory() async {
    final Directory dir =
        Directory("${(await getApplicationDocumentsDirectory()).path}/${AppConstants.historyFolderName}");
    if (dir.existsSync()) dir.delete(recursive: true);
  }

  static void addToPlaylist({required String playlistName, required SongItem item}) async {
    return _addSongToFolder(
      item: item,
      path: "playlists/$playlistName",
      maxItems: _maxItemsInHistory,
    );
  }

  static void removeFromPlaylist({required String playlistName, required SongItem item}) async {
    return _removeSongFromFolder(item: item, path: "playlists/$playlistName");
  }

  static Future<List<SongItem>> getPlaylistSongs({required String playlistName}) async {
    return _listSongsFromFolder(path: "playlists/$playlistName");
  }

  static Future<List<Playlist>> listPlaylists() async {
    final String rootPath = (await getApplicationDocumentsDirectory()).path;
    final Directory playlistsDir = Directory("$rootPath/playlists");
    if (!playlistsDir.existsSync()) playlistsDir.createSync();

    final List<FileSystemEntity> playlistFolders = playlistsDir.listSync();
    playlistFolders.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    return Future.wait<Playlist>(
      playlistFolders.map(
        (folder) async => Playlist(
          name: folder.path.split("/").last,
          creationDate: folder.statSync().changed,
          songList: await _listSongsFromFolder(
            path: folder.path,
            isFullPath: true,
          ),
        ),
      ),
    );
  }

  static Future<void> newPlaylist(String playlistName) async {
    final String rootPath = (await getApplicationDocumentsDirectory()).path;
    final Directory playlistsDir = Directory("$rootPath/playlists");
    if (!playlistsDir.existsSync()) playlistsDir.createSync();

    final List<FileSystemEntity> playlistFolders = playlistsDir.listSync();
    playlistFolders.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    return Directory("${playlistsDir.path}/$playlistName").createSync();
  }

  static Future<void> deletePlaylist(String playlistName) async {
    final String rootPath = (await getApplicationDocumentsDirectory()).path;
    final Directory dir = Directory("$rootPath/playlists/$playlistName");
    if (dir.existsSync()) return dir.deleteSync(recursive: true);
  }
}
