import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/color_constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: ColorConstants.primary,
      ),
    );
  }
}
