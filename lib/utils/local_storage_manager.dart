import 'dart:convert';
import 'dart:io';

import 'package:djsona_mobile/constants/app_constants.dart';
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
    required String folderName,
    int? maxItems,
  }) async {
    final Directory dir = Directory("${(await getExternalStorageDirectory())!.path}/$folderName");
    if (!dir.existsSync()) dir.createSync();

    final List<FileSystemEntity> files = dir.listSync();
    files.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    if (maxItems != null && files.length >= maxItems) files.last.delete();

    _writeFile("${dir.path}/${item.id}.json", item.toJson());
  }

  static void _removeSongFromFolder({
    required SongItem item,
    required String folderName,
  }) async {
    final Directory dir = Directory("${(await getExternalStorageDirectory())!.path}/$folderName");
    File("${dir.path}/${item.id}.json").delete();
  }

  static Future<List<SongItem>> _listSongsFromFolder({required String folderName}) async {
    final Directory dir = Directory("${(await getExternalStorageDirectory())!.path}/$folderName");
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
      folderName: AppConstants.historyFolderName,
      maxItems: _maxItemsInHistory,
    );
  }

  static Future<List<SongItem>> listHistory() async {
    return _listSongsFromFolder(folderName: AppConstants.historyFolderName);
  }

  static Future<void> clearHistory() async {
    final Directory dir = Directory("${(await getExternalStorageDirectory())!.path}/${AppConstants.historyFolderName}");
    if (dir.existsSync()) dir.delete(recursive: true);
  }

  static void addToLiked(SongItem item) async {
    return _addSongToFolder(
      item: item,
      folderName: AppConstants.likedFolderName,
      maxItems: _maxItemsInHistory,
    );
  }

  static void removeFromLiked(SongItem item) async {
    return _removeSongFromFolder(item: item, folderName: AppConstants.likedFolderName);
  }

  static Future<List<SongItem>> listLiked() async {
    return _listSongsFromFolder(folderName: AppConstants.likedFolderName);
  }
}
