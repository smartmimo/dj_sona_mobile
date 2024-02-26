import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/router/error_widget.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_bloc/flutter_bloc.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BlocBuilder<AppStateCubit, AppState>(
        bloc: serviceLocator.get<AppStateCubit>(),
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
    );
  }
}
