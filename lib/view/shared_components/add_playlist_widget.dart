import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/utils/form_validators.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/view/shared_components/button_master.dart';
import 'package:djsona_mobile/view/shared_components/txt_field.dart';
import 'package:flutter/material.dart';

class AddPlaylistWidget extends StatelessWidget {
  AddPlaylistWidget({
    super.key,
    required this.onCreatePressed,
  }) {
    textController = TextEditingController();
  }

  late final TextEditingController textController;
  final GlobalKey<FormState> formKey = GlobalKey();
  final Function(String) onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TxtFormField(
            controller: textController,
            prefixIcon: const Icon(IconConstants.document),
            labeltext: "Playlist name",
            validator: FormValidators.isValidFilename,
            keyboardType: TextInputType.number,
          ),
          ButtonMaster(
            text: "Create",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onCreatePressed(textController.text);
                AutoRouter.of(context).pop();
              }
            },
          )
        ].withVerticalElementsSpacing(16),
      ),
    );
  }
}
