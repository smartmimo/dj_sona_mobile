import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/view/shared_components/loading_widget.dart';
import 'package:flutter/material.dart';

class NetworkImg extends StatelessWidget {
  const NetworkImg(
    this._imageUrl, {
    Key? key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.defaultImageIconSize = 30,
    this.defaultImageIconColor = ColorConstants.blackish,
  }) : super(key: key);
  final String? _imageUrl;
  final BoxFit fit;
  final double? height;
  final double? width;
  final double defaultImageIconSize;
  final Color defaultImageIconColor;

  static const double _loadingWidgetSize = 20;

  @override
  Widget build(BuildContext context) {
    return _imageUrl != null ? _getDecorationImage(_imageUrl!) : _getDefaultImage(context);
  }

  Widget _getDecorationImage(String imageUrl) {
    if (imageUrl.startsWith("file://")) {
      return Image.file(
        File(imageUrl.replaceAll("file://", "")),
        fit: fit,
        width: width,
        height: height,
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      errorWidget: (context, url, error) => _getDefaultImage(context),
      errorListener: (value) => {}, //prevent throw
      progressIndicatorBuilder: (context, _, __) => SizedBox(
        width: width,
        height: height,
        child: Container(
          alignment: Alignment.center,
          width: _loadingWidgetSize,
          height: _loadingWidgetSize,
          child: const LoadingWidget(),
        ),
      ),
    );
  }

  Widget _getDefaultImage(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.secondary,
      child: ClipRRect(
        borderRadius: StyleConstants.radius100,
        child: Icon(
          IconConstants.images,
          size: defaultImageIconSize,
          color: defaultImageIconColor,
        ),
      ),
    );
  }
}
