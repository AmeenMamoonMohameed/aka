import 'package:akarak/widgets/drawer/main_drawer.dart';
// import 'package:assets_audio_player/assets_audio_player.dart' as player;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/configs/config.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/screens/screen.dart';
import 'package:akarak/utils/utils.dart';
import 'package:vibration/vibration.dart';

import 'notificationservice.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  _AppContainerState createState() {
    return _AppContainerState();
  }
}

class _AppContainerState extends State<AppContainer> {
  String _selected = Routes.home;
  bool _reconnectingProgress = false;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((message) {
      _notificationHandle(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _notificationHandle(message);
    });
  }

  ///check route need auth
  bool _requireAuth(String route) {
    switch (route) {
      case Routes.home:
      case Routes.discovery:
        return false;
      default:
        return true;
    }
  }

  ///Export index stack
  int _exportIndexed(String route) {
    switch (route) {
      case Routes.home:
        return 0;
      case Routes.discovery:
        return 1;
      case Routes.wishList:
        return 2;
      case Routes.account:
        return 3;
      default:
        return 0;
    }
  }

  ///Handle When Press Notification
  void _notificationHandle(RemoteMessage message) {
    final notification = NotificationModel.fromRemoteMessage(message);
    switch (notification.action) {
      case NotificationAction.created:
        Navigator.pushNamed(
          context,
          Routes.productDetail,
          arguments: notification.id,
        );
        return;

      default:
        return;
    }
  }

  ///Force switch home when authentication state change
  void _listenAuthenticateChange(AuthenticationState authentication) async {
    if (authentication == AuthenticationState.fail && _requireAuth(_selected)) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: _selected,
      );
      if (result != null) {
        setState(() {
          _selected = result as String;
        });
      } else {
        setState(() {
          _selected = Routes.home;
        });
      }
    }
  }

  ///On change tab bottom menu and handle when not yet authenticate
  void _onItemTapped(String route) async {
    AppBloc.discoveryCubit.onResetPagination();
    final signed = AppBloc.authenticateCubit.state != AuthenticationState.fail;
    if (!signed && _requireAuth(route)) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: route,
      );
      if (result == null) return;
    }
    setState(() {
      _selected = route;
    });
    if (route == Routes.discovery) {
      AppBloc.discoveryCubit.onLoad(FilterModel.fromDefault());
    }
  }

  ///On handle submit post
  void _onSubmit() async {
    final signed = AppBloc.authenticateCubit.state != AuthenticationState.fail;
    if (!signed) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.submit,
      );
      if (result == null) return;
    }
    if (!mounted) return;
    Navigator.pushNamed(context, Routes.submit);
  }

  ///Build Item Menu
  Widget _buildMenuItem(String route) {
    Color? color;
    String title = 'home';
    IconData iconData = Icons.help_outline;
    switch (route) {
      case Routes.home:
        iconData = Icons.home_outlined;
        title = 'home';
        break;
      case Routes.discovery:
        iconData = Icons.location_on_outlined;
        title = 'browse';
        break;
      case Routes.wishList:
        iconData = Icons.bookmark_outline;
        title = 'wish_list';
        break;
      case Routes.account:
        iconData = Icons.account_circle_outlined;
        title = 'account';
        break;
      default:
        iconData = Icons.home_outlined;
        title = 'home';
        break;
    }
    if (route == _selected) {
      color = Theme.of(context).primaryColor;
    }
    return IconButton(
      onPressed: () {
        _onItemTapped(route);
      },
      padding: EdgeInsets.zero,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: color,
          ),
          const SizedBox(height: 2),
          Text(
            Translate.of(context).translate(title),
            style: Theme.of(context).textTheme.button!.copyWith(
                  fontSize: 10,
                  color: color,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  ///Build submit button
  Widget? _buildSubmit() {
    if (Application.setting.enableSubmit) {
      return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _onSubmit,
        child: const Icon(
          Icons.add,
          color: Color(0xff2D5198),
        ),
      );
    }
    return null;
  }

  ///Build bottom menu
  Widget _buildBottomMenu() {
    if (Application.setting.enableSubmit) {
      return BottomAppBar(
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMenuItem(Routes.home),
              _buildMenuItem(Routes.discovery),
              const SizedBox(width: 56),
              _buildMenuItem(Routes.wishList),
              _buildMenuItem(Routes.account),
            ],
          ),
        ),
      );
    }
    return BottomAppBar(
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMenuItem(Routes.home),
            _buildMenuItem(Routes.discovery),
            _buildMenuItem(Routes.wishList),
            _buildMenuItem(Routes.account),
          ],
        ),
      ),
    );
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    const submitPosition = FloatingActionButtonLocation.centerDocked;

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, authentication) async {
        _listenAuthenticateChange(authentication);
        if (authentication == AuthenticationState.success) {
          await AppBloc.initCubit.onLoad().whenComplete(() => setState(() {}));
        }
      },
      child: BlocListener<ChatSignalRCubit, ChatSignalRState>(
        listener: (context, chatSignalRState) {
          if (chatSignalRState == ChatSignalRState.close) {
            _reconnectingProgress = true;
            setState(() {});
          }
          if (chatSignalRState == ChatSignalRState.reconnecting) {
            _reconnectingProgress = true;
            setState(() {});
          }
          if (chatSignalRState == ChatSignalRState.reconnected) {
            _reconnectingProgress = false;
            setState(() {});
          }
          debugPrint('sa');
          // ScaffoldMessenger.of(context).showSnackBar('snackBar');
        },
        child: BlocListener<InitCubit, InitState>(
          listener: (context, initState) async {
            // AppBloc.initCubit.stream.listen((state) async {
            if (initState is InitSuccess) {
              if (initState.list.any((element) =>
                  element.lastMessage?.fromUserId !=
                      AppBloc.userCubit.state?.id &&
                  element.lastMessage?.status != Status.seen)) {
                if (initState.isAlerm) {
                  // player.AssetsAudioPlayer.newPlayer().stop();
                  // player.AssetsAudioPlayer.newPlayer().open(
                  //   player.Audio("assets/sounds/notification.mp3"),
                  //   autoStart: true,
                  //   showNotification: false,
                  // );
                  NotificationService()
                      .showNotification(1, "title", "body", 10);
                }
                if (initState.isVibrate) {
                  Vibration.cancel();
                  Vibration.vibrate(duration: 128);
                }

//
                if (initState.isOpenDrawer) {
                  if (!(Application.scaffoldKey.currentState?.isDrawerOpen ??
                      false)) {
                    // msgCount += 1;
                    Application.scaffoldKey.currentState?.openDrawer();
                  }
                }
              }
            }
            // });
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title:
                  AppBloc.chatSignalRCubit.state == ChatSignalRState.reconnected
                      ? const Text("sssss")
                      : AppBloc.chatSignalRCubit.state ==
                              ChatSignalRState.reconnecting
                          ? const LinearProgressIndicator(
                              backgroundColor: Colors.grey,
                            )
                          : LinearProgressIndicator(
                              backgroundColor: Colors.grey,
                              color: Theme.of(context).errorColor,
                            ),
              toolbarHeight:
                  AppBloc.chatSignalRCubit.state == ChatSignalRState.reconnected
                      ? 0
                      : 5,
            ),
            key: Application.scaffoldKey,
            drawer: const MainDrawer(
              msgCount: 4,
            ),
            body: IndexedStack(
              index: _exportIndexed(_selected),
              children: const <Widget>[
                Home2(),
                Discovery(),
                WishList(),
                Account()
              ],
            ),
            bottomNavigationBar: _buildBottomMenu(),
            floatingActionButton: _buildSubmit(),
            floatingActionButtonLocation: submitPosition,
          ),
        ),
      ),
    );
    // });
  }
}
