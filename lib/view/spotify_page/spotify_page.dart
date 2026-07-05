import 'package:djsona_mobile/utils/image_utils.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/shared_components/appbar_widget.dart';
import 'package:flutter/material.dart';

class SpotifyPage extends StatelessWidget {
  const SpotifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ImageUtils.lightenColor(Theme.of(context).colorScheme.secondary, 0.6),
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        content: Row(
          children: [
            Text(
              "Spotify",
              style: Theme.of(context).textTheme.bodyXLBold.copyWith(color: Colors.white),
            ),
          ],
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
          child: _getContent(context),
        ),
      ),
    );
  }

  Widget _getContent(BuildContext context) {
    return Text(
      "Spotify page",
      style: Theme.of(context).textTheme.bodyXLBold.copyWith(color: Colors.white),
    );
  }
}
