import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/utils/string_utils.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:flutter/material.dart' hide SearchBar;

class SeekerWidget extends StatefulWidget {
  const SeekerWidget({
    super.key,
    required this.seek,
    required this.totalDuration,
    required this.currentDuration,
    required this.bufferedDuration,
    this.seekerHeight = 4,
  });

  @override
  State<SeekerWidget> createState() => _SeekerWidgetState();

  final Function(Duration duration) seek;
  final Duration totalDuration;
  final Duration currentDuration;
  final Duration bufferedDuration;
  final double seekerHeight;
}

class _SeekerWidgetState extends State<SeekerWidget> {
  bool isDragging = false;
  Duration? preloadedDuration;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _getDurationWidget(context, isDragging ? preloadedDuration! : widget.currentDuration),
        Expanded(child: _getProgressBar(context)),
        _getDurationWidget(context, widget.totalDuration),
      ].withHorizontalElementsSpacing(8),
    );
  }

  Widget _getProgressBar(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double widthOfSibling = constraints.maxWidth;
        final double currentDurationWidth =
            (isDragging ? preloadedDuration!.inSeconds : widget.currentDuration.inSeconds) *
                widthOfSibling /
                widget.totalDuration.inSeconds;
        return GestureDetector(
          onTapUp: (TapUpDetails details) {
            double tappedPosition = details.localPosition.dx;

            double positionInSeconds = (tappedPosition / widthOfSibling) * widget.totalDuration.inSeconds;

            widget.seek(Duration(seconds: positionInSeconds.toInt()));
          },
          onLongPressStart: (LongPressStartDetails details) {
            double tappedPosition = details.localPosition.dx;
            double positionInSeconds = (tappedPosition / widthOfSibling) * widget.totalDuration.inSeconds;
            setState(() {
              isDragging = true;
              preloadedDuration = Duration(seconds: positionInSeconds.toInt());
            });
            widget.seek(preloadedDuration!);
          },
          onHorizontalDragStart: (DragStartDetails details) {
            double tappedPosition = details.localPosition.dx;
            double positionInSeconds = (tappedPosition / widthOfSibling) * widget.totalDuration.inSeconds;
            setState(() {
              isDragging = true;
              preloadedDuration = Duration(seconds: positionInSeconds.toInt());
            });
            widget.seek(preloadedDuration!);
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            double tappedPosition = details.localPosition.dx;
            if (tappedPosition < 0) return;
            double positionInSeconds = (tappedPosition / widthOfSibling) * widget.totalDuration.inSeconds;
            if (positionInSeconds > widget.totalDuration.inSeconds) return;
            setState(() {
              preloadedDuration = Duration(seconds: positionInSeconds.toInt());
            });
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            widget.seek(preloadedDuration!);
            setState(() {
              isDragging = false;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              _getProgressLine(widthOfSibling, currentDurationWidth),
              if (isDragging) ...{
                _getIndicator(currentDurationWidth),
              },
            ],
          ),
        );
      },
    );
  }

  Positioned _getIndicator(double currentDurationWidth) {
    return Positioned(
      left: currentDurationWidth,
      child: Container(
        width: widget.seekerHeight * 4,
        height: widget.seekerHeight * 4,
        decoration: BoxDecoration(
          boxShadow: StyleConstants.standardShadow,
          color: ColorConstants.white,
          border: Border.all(color: Theme.of(context).colorScheme.secondary, width: widget.seekerHeight),
          borderRadius: StyleConstants.radius100,
        ),
      ),
    );
  }

  Container _getProgressLine(double widthOfSibling, double currentDurationWidth) {
    return Container(
      color: Colors.transparent,
      padding: StyleConstants.edgeInsetsV8,
      child: ClipRRect(
        borderRadius: StyleConstants.radius100,
        child: Stack(
          children: [
            Container(
              height: widget.seekerHeight,
              color: ColorConstants.white,
            ),
            Container(
              height: widget.seekerHeight,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              width: widget.bufferedDuration.inSeconds * widthOfSibling / widget.totalDuration.inSeconds,
            ),
            Container(
              height: widget.seekerHeight,
              color: Theme.of(context).colorScheme.secondary,
              width: currentDurationWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDurationWidget(BuildContext context, Duration duration) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: StyleConstants.radius4,
        boxShadow: StyleConstants.standardShadow,
      ),
      padding: StyleConstants.edgeInsetsH4V2,
      child: Text(
        StringUtils.prettyDuration(duration),
        style: textTheme.bodyMBold.copyWith(color: ColorConstants.lightGrey),
      ),
    );
  }
}
