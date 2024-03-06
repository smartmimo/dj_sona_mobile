import 'package:djsona_mobile/constants/app_constants.dart';
import 'package:djsona_mobile/view/shared_components/playlist_screen_page.dart';
import 'package:flutter/material.dart';

class LikedSongsPage extends StatelessWidget {
  const LikedSongsPage({super.key});

  @override
  Widget build(context) {
    return PlaylistScreenPage(playlistName: AppConstants.likedSongsPlaylistName);
  }
}
