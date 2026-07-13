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
    final StreamManifest manifest = await yt.videos.streamsClient.getManifest(
      videoId,
      ytClients: [
        YoutubeApiClient.androidVr,
      ],
    );
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

      final List suggestedVideos = data['contents']?['twoColumnWatchNextResults']?['secondaryResults']
              ?['secondaryResults']?['results']?[0]?['itemSectionRenderer']?['contents'] ??
          [];

      final Map<String, int> videoDurationMap = {};

      for (final item in suggestedVideos) {
        final String? videoId = item['lockupViewModel']?['contentId'];
        if (videoId == null) continue;

        final String? durationText = item['lockupViewModel']?['contentImage']?['thumbnailViewModel']?['overlays']?[0]
            ?['thumbnailBottomOverlayViewModel']?['badges']?[0]?['thumbnailBadgeViewModel']?['text'] as String?;

        videoDurationMap[videoId] = _parseDurationToSeconds(durationText);
      }

      if (videoDurationMap.isEmpty) return [];

      // keep videos <= 10 minutes (600s)
      final List<MapEntry<String, int>> filtered =
          videoDurationMap.entries.where((e) => e.value > 0 && e.value <= 600).toList();

      if (filtered.isNotEmpty) {
        return filtered.map((e) => e.key).toList();
      }

      // fallback: return the single video with minimum duration
      final List<MapEntry<String, int>> nonZeroDurationEntries =
          videoDurationMap.entries.where((e) => e.value > 0).toList();
      if (nonZeroDurationEntries.isNotEmpty) {
        final minEntry = nonZeroDurationEntries.reduce(
          (a, b) => a.value < b.value ? a : b,
        );
        return [minEntry.key];
      }
      return [videoDurationMap.entries.first.key];
    }
    throw "Error while parsing..";
  }

  static int _parseDurationToSeconds(String? durationText) {
    if (durationText == null || durationText.isEmpty) {
      return 0;
    }

    final parts = durationText.split(':').map(int.parse).toList();

    if (parts.length == 2) {
      // mm:ss
      return parts[0] * 60 + parts[1];
    } else if (parts.length == 3) {
      // hh:mm:ss
      return parts[0] * 3600 + parts[1] * 60 + parts[2];
    }

    return 0;
  }
}
