import 'widgets/widget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:akarak/app_container.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/configs/config.dart';
import 'package:akarak/screens/screen.dart';
import 'package:akarak/utils/utils.dart';

import 'first_time.dart';
import 'repository/location_repository.dart';
import 'package:timezone/data/latest.dart' as tz;

final Widget mainScaffold = Scaffold(
  appBar: AppBar(),
  drawer: Drawer(child: Container()),
  body: BlocListener<MessageCubit, String?>(
    listener: (context, message) {
      if (message != null) {
        final snackBar = SnackBar(
          content: Text(
            Translate.of(context).translate(message),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    },
    child: BlocBuilder<ApplicationCubit, ApplicationState>(
      builder: (context, application) {
        if (application == ApplicationState.completed) {
          return const AppContainer();
        }
        // return const AppContainer();
        if (application == ApplicationState.intro) {
          return const Intro();
        }
        if (application == ApplicationState.firstTime) {
          return const FirstTime();
        }
        return const SplashScreen();
      },
    ),
  ),
);

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  void dispose() {
    AppBloc.dispose();
    super.dispose();
  }

  void onSetup(BuildContext context) async {
    await Preferences.setPreferences();
    if (LocationRepository.loadCountry() == null) {
      AppBloc.applicationCubit.onBeforeSetup();
    } else {
      AppBloc.applicationCubit.onSetup();
    }
  }

  @override
  Widget build(BuildContext context) {
    onSetup(context);
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, lang) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, theme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: theme.lightTheme,
                darkTheme: theme.darkTheme,
                onGenerateRoute: Routes.generateRoute,
                locale: lang,
                localizationsDelegates: const [
                  Translate.delegate,
                  CountryLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLanguage.supportLanguage,
                home: Scaffold(
                  // key: Application.scaffoldKey,
                  body: BlocListener<MessageCubit, String?>(
                    listener: (context, message) {
                      if (message != null) {
                        final snackBar = SnackBar(
                          content: Text(
                            Translate.of(context).translate(message),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: BlocBuilder<ApplicationCubit, ApplicationState>(
                      builder: (context, application) {
                        if (application == ApplicationState.completed) {
                          return const AppContainer();
                        }
                        // return const AppContainer();
                        if (application == ApplicationState.intro) {
                          return const Intro();
                        }
                        if (application == ApplicationState.firstTime) {
                          return const FirstTime();
                        }
                        return const SplashScreen();
                      },
                    ),
                  ),
                ),
                builder: (context, child) {
                  final data = MediaQuery.of(context).copyWith(
                    textScaleFactor: theme.textScaleFactor,
                  );
                  return MediaQuery(
                    data: data,
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
