import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/utils/string_utils.dart';
import 'package:djsona_mobile/view/shared_components/appbar_widget.dart';
import 'package:djsona_mobile/view/shared_components/loading_widget.dart';
import 'package:djsona_mobile/view/shared_components/txt_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchAppbar extends StatelessWidget {
  SearchAppbar({
    super.key,
    required this.onChanged,
    required this.isLoading,
  });

  final Function(String?) onChanged;
  final bool isLoading;

  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();
  static const double _textFieldIconsSize = 20;
  static final TextEditingController textController = TextEditingController();


  @override
  Widget build(context) {
    return BlocBuilder<AppStateCubit, AppState>(
      bloc: _appStateCubit,
      builder: (context, state) {
        return TxtFormField(
          controller: textController,
          labeltext: "Search for a song",
          prefixIcon: const Icon(IconConstants.search, size: _textFieldIconsSize),
          suffixIcon: _getSuffixIcon(context, state),
          borderRadius: StyleConstants.radius100,
          borderColor: Colors.transparent,
          textFieldHeight: AppBarWidget.leadingSize,
          onChanged: onChanged,
          readOnly: state.connectivityResult == ConnectivityResult.none,
        );
      },
    );
  }

  Widget? _getSuffixIcon(context, AppState state) {
    if (state.connectivityResult == ConnectivityResult.none) {
      return Icon(
        IconConstants.noNetwork,
        color: Theme.of(context).colorScheme.primary,
        size: _textFieldIconsSize,
      );
    } else if (isLoading) {
      return const SizedBox(
        width: _textFieldIconsSize,
        height: _textFieldIconsSize,
        child: LoadingWidget(),
      );
    } else if (StringUtils.isNotEmpty(textController.text)) {
      return Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _textFieldIconsSize,
          height: _textFieldIconsSize,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              textController.clear();
              onChanged(null);
            },
            icon: const Icon(IconConstants.close, size: _textFieldIconsSize),
            splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
          ),
        ),
      );
    } else {
      return null;
    }
  }
}
