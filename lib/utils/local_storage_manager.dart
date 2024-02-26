import 'dart:convert';
import 'dart:io';

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

  static void addToHistory(SongItem item) async {
    final Directory historyDir = Directory("${(await getExternalStorageDirectory())!.path}/history");
    if (!historyDir.existsSync()) historyDir.createSync();

    final List<FileSystemEntity> historyFiles = historyDir.listSync();
    historyFiles.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    if (historyFiles.length >= _maxItemsInHistory) historyFiles.last.delete();

    _writeFile("${historyDir.path}/${item.id}.json", item.toJson());
  }

  static Future<List<SongItem>> listHistory() async {
    final Directory historyDir = Directory("${(await getExternalStorageDirectory())!.path}/history");
    if (!historyDir.existsSync()) return [];

    final List<FileSystemEntity> historyFiles = historyDir.listSync();
    historyFiles.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    return historyFiles.map((file) {
      return SongItem.fromJson(
        _readFile(file.absolute.path),
      );
    }).toList();
  }

  static void addToLiked(SongItem item) async {
    final Directory likedSongsDir = Directory("${(await getExternalStorageDirectory())!.path}/liked");
    if (!likedSongsDir.existsSync()) likedSongsDir.createSync();

    final List<FileSystemEntity> likedFiles = likedSongsDir.listSync();
    likedFiles.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    _writeFile("${likedSongsDir.path}/${item.id}.json", item.toJson());
  }

  static void removeFromLiked(SongItem item) async {
    final Directory likedSongsDir = Directory("${(await getExternalStorageDirectory())!.path}/liked");
    File("${likedSongsDir.path}/${item.id}.json").delete();
  }

  static Future<List<SongItem>> listLiked() async {
    final Directory likedSongsDir = Directory("${(await getExternalStorageDirectory())!.path}/liked");
    if (!likedSongsDir.existsSync()) return [];

    final List<FileSystemEntity> likedFiles = likedSongsDir.listSync();
    likedFiles.sort((a, b) => b.statSync().changed.compareTo(a.statSync().changed));

    return likedFiles.map((file) {
      return SongItem.fromJson(
        _readFile(file.absolute.path),
      );
    }).toList();
  }
}
