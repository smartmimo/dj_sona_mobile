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
  }) : super(key: key);
  final String? _imageUrl;
  final BoxFit fit;
  final double? height;
  final double? width;

  static const double _loadingWidgetSize = 20;

  @override
  Widget build(BuildContext context) {
    return _imageUrl != null ? _getDecorationImage(_imageUrl!) : _getDefaultImage(context);
  }

  Widget _getDecorationImage(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) => _getDefaultImage(context),
      loadingBuilder: (context, child, chunkEvent) =>
          chunkEvent?.cumulativeBytesLoaded == chunkEvent?.expectedTotalBytes
              ? child
              : SizedBox(
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
        child: const Icon(IconConstants.images, size: 30),
      ),
    );
  }
}
