import 'package:audio_service/audio_service.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/music_search_cubit/music_search_cubit.dart';
import 'package:djsona_mobile/cubits/music_search_cubit/music_search_state.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/search_api_provider.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/utils/image_utils.dart';
import 'package:djsona_mobile/view/home_page/search_appbar.dart';
import 'package:djsona_mobile/view/shared_components/appbar_widget.dart';
import 'package:djsona_mobile/view/shared_components/song_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final AudioPlayerService audioService = serviceLocator.get<AudioPlayerService>();

  @override
  Widget build(context) {
    return BlocProvider(
      create: (_) => MusicSearchCubit(
        serviceLocator.get<SearchApiProvider>(),
        audioService,
      )..init(),
      child: BlocBuilder<MusicSearchCubit, MusicSearchState>(
        builder: _mapStateToWidget,
      ),
    );
  }

  Widget _mapStateToWidget(BuildContext context, MusicSearchState state) {
    final cubit = BlocProvider.of<MusicSearchCubit>(context);
    return Scaffold(
      backgroundColor: ImageUtils.lightenColor(Theme.of(context).colorScheme.secondary, 0.6),
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        content: SearchAppbar(
        onChanged: cubit.onSearchChanged,
        isLoading: state.isLoading,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/dj_sona_icon.png"),
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: _getSongList(context, state),
        ),
      ),
    );
  }

  Widget _getSongList(BuildContext context, MusicSearchState state) {
    final cubit = BlocProvider.of<MusicSearchCubit>(context);
    return StreamBuilder<MediaItem?>(
      stream: audioService.mediaItem,
      builder: (context, snapshot) {
        final MediaItem? currentlyPlaying = snapshot.data;
        return ListView.builder(
          padding: StyleConstants.edgeInsetsT16,
          itemBuilder: ((context, index) {
            return Padding(
              padding: StyleConstants.edgeInsetsB16,
              child: SongCard(
                songItem: state.songList[index],
                isCurrentlyPlaying: currentlyPlaying?.id == state.songList[index].id,
                isLoading: state.songLoadingId == state.songList[index].id,
                onPressed: state.songLoadingId == null ? () => cubit.onSongPressed(state.songList[index]) : null,
              ),
            );
          }),
          itemCount: state.songList.length,
          physics: const AlwaysScrollableScrollPhysics(),
        );
      },
    );
  }
}
