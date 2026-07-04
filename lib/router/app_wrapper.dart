import 'package:auto_route/auto_route.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/router/error_widget.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/view/shared_components/snack_bar_widget.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_bloc/flutter_bloc.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator.get<AppStateCubit>(),
      child: SafeArea(
        top: false,
        child: BlocPresentationListener<AppStateCubit, AppStateEvent>(
          listener: (context, event) {
            switch (event) {
              case AppStatePlaybackErrorEvent():
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBarWidget.error(
                      context: context,
                      text: event.errorMessage,
                    ),
                  );
            }
          },
          child: BlocBuilder<AppStateCubit, AppState>(
            builder: (context, state) {
              if (state.error != null) {
                return ErrorWidget(error: state.error!);
              }
              return AnimatedTheme(
                data: ThemeData(
                  colorScheme: ColorScheme.light(
                    primary: state.primaryColor,
                    secondary: state.secondaryColor,
                  ),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: const Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: AutoRouter(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
