import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:akarak/app.dart';
import 'package:akarak/utils/utils.dart';

import 'notificationservice.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    UtilLogger.log('BLOC ONCHANGE', change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    UtilLogger.log('BLOC EVENT', event);
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    UtilLogger.log('BLOC ERROR', error);
    super.onError(bloc, error, stackTrace);
  }

  @override   
  void onTransition(Bloc bloc, Transition transition) {
    UtilLogger.log('BLOC TRANSITION', transition);
    super.onTransition(bloc, transition);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  BlocOverrides.runZoned(
    () => runApp(const App()),
    blocObserver: AppBlocObserver(),
  );
}
