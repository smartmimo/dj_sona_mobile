import 'package:audio_service/audio_service.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/main/app.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PackageInfo packageinfo = await PackageInfo.fromPlatform();
  serviceLocator.registerSingleton<PackageInfo>(packageinfo);

  await setupDependencies();

  final AudioPlayerService audioPlayerService = await AudioService.init(
    builder: () => AudioPlayerService(),
    config: AudioServiceConfig(
      androidNotificationChannelId: "${packageinfo.packageName}.channel.audio",
      androidNotificationChannelName: 'DJ Sona playback',
      androidNotificationOngoing: true,
      notificationColor: ColorConstants.primary,
    ),
  );
  serviceLocator.registerSingleton<AudioPlayerService>(audioPlayerService);

  runApp(DJSonaMobileApp());
}
