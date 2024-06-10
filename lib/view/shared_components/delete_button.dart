import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/view/shared_components/button_master.dart';
import 'package:djsona_mobile/view/shared_components/popup_dialog_layout.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.isDisabled,
    required this.onPressed,
    this.onlyIcon = false,
    this.text = "Delete",
    this.iconSpacing = 12,
  });

  final bool isDisabled;
  final VoidCallback onPressed;
  final bool onlyIcon;
  final String text;
  final double iconSpacing;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (onlyIcon) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: StyleConstants.radius100,
          color: ColorConstants.roofTerracotta,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (context) => _getConfirmationPopup(context),
            ),
            icon: const Icon(
              IconConstants.delete,
              color: Colors.white,
              size: 16,
            ),
            padding: EdgeInsets.zero,
            splashRadius: 15,
          ),
        ),
      );
    }

    return ButtonMaster(
      text: text,
      onPressed: () => showDialog<String>(
        context: context,
        builder: (context) => _getConfirmationPopup(context),
      ),
      filledColor: ColorConstants.roofTerracotta,
      prefixIcon: const Icon(
        IconConstants.delete,
        color: Colors.white,
      ),
      iconSpacing: iconSpacing,
      isDisabled: isDisabled,
    );
  }

  Widget _getConfirmationPopup(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PopupDialogLayout(
      title: Text(
        "Confirmation",
        style: textTheme.heading4.copyWith(color: ColorConstants.blackish),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Are you sure you want to go through with this action?",
            style: textTheme.bodyXL.copyWith(
              color: ColorConstants.blackish,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ButtonMaster.outlined(
                  text: "Cancel",
                  onPressed: AutoRouter.of(context).pop,
                ),
              ),
              Expanded(
                child: ButtonMaster(
                  text: "Confirm",
                  onPressed: () => {
                    onPressed(),
                    AutoRouter.of(context).pop(),
                  },
                  filledColor: ColorConstants.roofTerracotta,
                ),
              ),
            ].withHorizontalElementsSpacing(8),
          )
        ].withVerticalElementsSpacing(24),
      ),
    );
  }
}
