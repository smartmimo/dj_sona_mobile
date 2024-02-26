import 'package:djsona_mobile/services/api/api_service.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/youtube_utils.dart';

class SearchApiProvider {
  final ApiService _apiService;
  const SearchApiProvider(this._apiService);

  Future<List<SongItem>> searchByText(String query) async {
    final result = await _apiService.get("results", queryParameters: {
      "search_query": query,
    });

    return YoutubeUtils.parseSearchResponse(result.data);
  }

  Future<List<String>> getRelatedVideosFromId(String videoId) async {
    final result = await _apiService.get("https://madmaden-ytscraper.fly.dev/getNext", queryParameters: {
      "id": videoId,
    });
    return (result.data as List).map((e) => e.toString()).toList();
  }
}
