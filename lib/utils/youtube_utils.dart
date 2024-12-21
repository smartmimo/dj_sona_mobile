import 'dart:convert';
import 'package:djsona_mobile/types/media_item_extras.dart';
import 'package:djsona_mobile/types/media_item_wrapper.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

abstract class YoutubeUtils {
  static List<SongItem> parseSearchResponse(String html) {
    Document document = parse(html);

    for (final Element element in document.getElementsByTagName('script')) {
      if (!element.innerHtml.contains("var ytInitialData")) continue;

      final jsonRegex = RegExp(r'var\s+ytInitialData\s*=\s*({.*?});', dotAll: true);
      final match = jsonRegex.firstMatch(element.innerHtml);
      if (match == null) throw ('JSON variable not found in the script content.');
      final jsonStr = match.group(1)!;

      final List<dynamic> items = (jsonDecode(jsonStr)['contents']['twoColumnSearchResultsRenderer']['primaryContents']
              ['sectionListRenderer']['contents'][0]['itemSectionRenderer']['contents'] as List)
          .where((e) => e.containsKey('videoRenderer'))
          .map((item) => item["videoRenderer"])
          .toList();

      final List<SongItem> songs = [];
      for (final item in items) {
        songs.add(
          SongItem(
            id: item["videoId"],
            title: item["title"]["runs"][0]["text"],
            durationString: item["lengthText"] != null ? item["lengthText"]["simpleText"] : null,
            publishedTimeString: item["publishedTimeText"] != null ? item["publishedTimeText"]["simpleText"] : null,
            viewsString: item["shortViewCountText"] != null ? item["shortViewCountText"]["simpleText"] : null,
            thumbnailUrl: ((item["thumbnail"]["thumbnails"] as List)
                  ..sort(
                    (a, b) => b["width"] - a["width"],
                  ))
                .first["url"],
          ),
        );
      }
      return songs;
    }
    throw "Error while parsing..";
  }

  static Future<AudioOnlyStreamInfo> getAudioStreamFromVideoId(String videoId) async {
    final YoutubeExplode yt = YoutubeExplode();
    final StreamManifest manifest = await yt.videos.streamsClient.getManifest(videoId);
    final AudioOnlyStreamInfo audioStreamInfo = manifest.audioOnly.withHighestBitrate();
    yt.close();
    return audioStreamInfo;
  }

  static Future<MediaItemWrapper> getMediaItemFromSongItem(
    SongItem songItem, {
    int? originalIndex,
    int? shuffledIndex,
  }) async {
    final AudioOnlyStreamInfo audioStreamInfo = await getAudioStreamFromVideoId(songItem.id);
    return songItem.toMediaItemWrapper(
      extras: MediaItemExtras(
        streamUrl: audioStreamInfo.url.toString(),
        originalIndex: originalIndex,
        shuffledIndex: shuffledIndex,
        fileSize: audioStreamInfo.size.totalBytes,
      ),
    );
  }

  static Future<Video> getVideoDatafromId(String videoId) async {
    final YoutubeExplode yt = YoutubeExplode();
    final Video manifest = await yt.videos.get(videoId);
    yt.close();
    return manifest;
  }

  static List<String> parseAutoplayResponse(String html) {
    final Document document = parse(html);

    for (final Element element in document.getElementsByTagName('script')) {
      if (!element.innerHtml.contains("var ytInitialData")) continue;

      final jsonRegex = RegExp(r'var\s+ytInitialData\s*=\s*({.*?});', dotAll: true);
      final match = jsonRegex.firstMatch(element.innerHtml);
      if (match == null) throw ('JSON variable not found in the script content.');

      final jsonStr = match.group(1)!;

      final Map<String, dynamic> data = jsonDecode(jsonStr);

      final List suggestedVideos =
          data['contents']?['twoColumnWatchNextResults']?['secondaryResults']?['secondaryResults']?['results'] ?? [];

      final List<String> videoIds = suggestedVideos
          .where((item) => item['compactVideoRenderer']?['videoId'] != null)
          .take(10)
          .map<String>((item) => item['compactVideoRenderer']['videoId'] as String)
          .toList();

      return videoIds;
    }
    throw "Error while parsing..";
  }
}
