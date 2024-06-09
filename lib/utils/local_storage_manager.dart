import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:djsona_mobile/constants/app_constants.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageManager {
  static const int _maxItemsInHistory = 10;

  late final Directory _basePath;

  LocalStorageManager._(this._basePath);

  static Future<LocalStorageManager> create() async {
    Directory basePath = Platform.isIOS ? await getLibraryDirectory() : await getApplicationDocumentsDirectory();

    final Directory playlistsDir = Directory("${basePath.path}/playlists");
    final Directory downloadsDir = Directory("${basePath.path}/downloads");
    if (!playlistsDir.existsSync()) playlistsDir.createSync();
    if (!downloadsDir.existsSync()) downloadsDir.createSync();

    return LocalStorageManager._(basePath);
  }

  _writeFile(String path, Map<String, dynamic> content) {
    List<int> compressedData = GZipCodec().encode(
      utf8.encode(
        jsonEncode(content),
      ),
    );

    File(path).writeAsBytes(compressedData);
  }

  Map<String, dynamic> _readFile(String path) {
    return jsonDecode(
      utf8.decode(
        GZipCodec().decode(File(path).readAsBytesSync()),
      ),
    );
  }

  void _addSongToFolder({
    required SongItem item,
    required String path,
    int? maxItems,
  }) {
    final Directory dir = Directory("${_basePath.path}/$path");
    if (!dir.existsSync()) dir.createSync();

    final List<FileSystemEntity> files = dir.listSync();
    files.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    if (maxItems != null && files.length >= maxItems) files.last.delete();

    _writeFile("${dir.path}/${item.id}.json", item.toJson());
  }

  void _removeSongFromFolder({
    required SongItem item,
    required String path,
  }) {
    final Directory dir = Directory("${_basePath.path}/$path");
    File("${dir.path}/${item.id}.json").delete();
  }

  List<SongItem> _listSongsFromFolder({
    required String path,
    bool isFullPath = false,
  }) {
    final Directory dir = Directory(
      isFullPath ? path : "${_basePath.path}/$path",
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

  void addToHistory(SongItem item) {
    return _addSongToFolder(
      item: item,
      path: AppConstants.historyFolderName,
      maxItems: _maxItemsInHistory,
    );
  }

  List<SongItem> listHistory() {
    return _listSongsFromFolder(path: AppConstants.historyFolderName);
  }

  void clearHistory() {
    final Directory dir = Directory("${_basePath.path}/${AppConstants.historyFolderName}");
    if (dir.existsSync()) dir.delete(recursive: true);
  }

  void addToPlaylist({required String playlistName, required SongItem item}) {
    return _addSongToFolder(
      item: item,
      path: "playlists/$playlistName",
      maxItems: _maxItemsInHistory,
    );
  }

  void removeFromPlaylist({required String playlistName, required SongItem item}) {
    return _removeSongFromFolder(item: item, path: "playlists/$playlistName");
  }

  String _getDownloadDirectory() {
    return "${_basePath.path}/downloads";
  }

  List<SongItem> getPlaylistSongs({required String playlistName}) {
    return _listSongsFromFolder(path: "playlists/$playlistName");
  }

  List<Playlist> listPlaylists() {
    final String rootPath = _basePath.path;
    final Directory playlistsDir = Directory("$rootPath/playlists");

    final List<FileSystemEntity> playlistFolders = playlistsDir.listSync();
    playlistFolders.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    return List<Playlist>.from(
      playlistFolders.map(
        (folder) => Playlist(
          name: folder.path.split("/").last,
          creationDate: folder.statSync().changed,
          songList: _listSongsFromFolder(
            path: folder.path,
            isFullPath: true,
          ),
        ),
      ),
    );
  }

  void newPlaylist(String playlistName) {
    final String rootPath = _basePath.path;
    final Directory playlistsDir = Directory("$rootPath/playlists");

    final List<FileSystemEntity> playlistFolders = playlistsDir.listSync();
    playlistFolders.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    return Directory("${playlistsDir.path}/$playlistName").createSync();
  }

  void deletePlaylist(String playlistName) {
    final String rootPath = _basePath.path;
    final Directory dir = Directory("$rootPath/playlists/$playlistName");
    if (dir.existsSync()) return dir.deleteSync(recursive: true);
  }

  void saveSongToDownloads(String songId, Uint8List bytes) {
    File(getSongDownloadPath(songId)).writeAsBytes(bytes);
  }

  bool isSongDownloaded(String songId) {
    return File(getSongDownloadPath(songId)).existsSync();
  }

  String getSongDownloadPath(String songId) {
    final String downloadsPath = _getDownloadDirectory();
    return '$downloadsPath/$songId.mp3';
  }
}
