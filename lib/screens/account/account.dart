import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/configs/config.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/utils/utils.dart';
import 'package:akarak/widgets/widget.dart';

import '../../widgets/widget.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() {
    return _AccountState();
  }
}

class _AccountState extends State<Account> {
  // BannerAd? _bannerAd;
  // InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    if (Application.setting.useViewAdmob) {
      _createBannerAd();
      _createInterstitialAd();
    }
  }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    // _interstitialAd?.dispose();
    super.dispose();
  }

  ///Create BannerAd
  void _createBannerAd() {
    // final banner = BannerAd(
    //   size: AdSize.fullBanner,
    //   request: const AdRequest(),
    //   adUnitId: Ads.bannerAdUnitId,
    //   listener: BannerAdListener(
    //     onAdLoaded: (ad) {
    //       setState(() {
    //         _bannerAd = ad as BannerAd?;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, error) {
    //       ad.dispose();
    //     },
    //     onAdOpened: (ad) {},
    //     onAdClosed: (ad) {},
    //   ),
    // );
    // banner.load();
  }

  ///Create InterstitialAd
  void _createInterstitialAd() async {
    // await InterstitialAd.load(
    //   adUnitId: Ads.interstitialAdUnitId,
    //   request: const AdRequest(),
    //   adLoadCallback: InterstitialAdLoadCallback(
    //     onAdLoaded: (ad) {
    //       _interstitialAd = ad;
    //     },
    //     onAdFailedToLoad: (error) {},
    //   ),
    // );
  }

  ///Show InterstitialAd
  void _showInterstitialAd() async {
    // if (_interstitialAd != null) {
    //   _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    //     onAdShowedFullScreenContent: (ad) {},
    //     onAdDismissedFullScreenContent: (ad) {
    //       ad.dispose();
    //       _createInterstitialAd();
    //     },
    //     onAdFailedToShowFullScreenContent: (ad, error) {
    //       ad.dispose();
    //       _createInterstitialAd();
    //     },
    //   );
    //   await _interstitialAd!.show();
    //   _interstitialAd = null;
    // }
  }

  ///On logout
  void _onLogout() async {
    _showInterstitialAd();
    AppBloc.loginCubit.onLogout();
  }

  ///On deactivate
  void _onDeactivate() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translate.of(context).translate('deactivate')),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Text(
                Translate.of(context).translate('would_you_like_deactivate'),
                style: Theme.of(context).textTheme.bodyText2,
              );
            },
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context).translate('close'),
              onPressed: () {
                Navigator.pop(context, false);
              },
              type: ButtonType.text,
            ),
            AppButton(
              Translate.of(context).translate('yes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
    if (result == true) {
      _confirmDeactivation();
      // AppBloc.loginCubit.onDeactivate("");
    }
  }

  ///On show message deactivate reason
  Future<String?> _confirmDeactivation() async {
    return await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String? reason;
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('deactive_account'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  Translate.of(context)
                      .translate('help_us_improve_service_quality'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 8,
                ),
                AppTextInput(
                  maxLines: 6,
                  hintText: Translate.of(context)
                      .translate('reason_for_account_deactivation'),
                  controller: TextEditingController(),
                  textInputAction: TextInputAction.done,
                  onChanged: (text) {
                    setState(() {
                      reason = text;
                      // _errorContent = UtilValidator.validate(
                      //   text,
                      //   allowEmpty: true
                      // );
                    });
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      // _textContentController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context).translate('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              type: ButtonType.text,
            ),
            AppButton(
              Translate.of(context).translate('confirm'),
              onPressed: () {
                Navigator.pop(context, reason);
                AppBloc.loginCubit.onDeactivate(reason);
              },
            ),
          ],
        );
      },
    );
  }

  ///On navigation
  void _onNavigate(String route) {
    Navigator.pushNamed(context, route);
  }

  ///On Preview Profile
  void _onProfile(UserModel user) {
    Navigator.pushNamed(context, Routes.profile, arguments: user);
  }

  ///Build Banner Ads
  Widget buildBanner() {
    // if (_bannerAd != null) {
    //   return SizedBox(
    //     width: _bannerAd!.size.width.toDouble(),
    //     height: _bannerAd!.size.height.toDouble(),
    //     child: AdWidget(ad: _bannerAd!),
    //   );
    // }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Application.scaffoldKey.currentState?.openDrawer(),
        ),
        centerTitle: false,
        title: Text(
          Translate.of(context).translate('account'),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  _onNavigate(Routes.chatList);
                },
                padding: EdgeInsets.zero,
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.asset(Images.message),
                    ),
                    // Icon(
                    //   Icons.message_outlined,
                    //   textDirection: TextDirection.ltr,
                    //   size: 20,
                    //   // color: Theme.of(context).colorScheme.secondary,
                    // ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.asset(Images.alarm),
                    ),
                    // Icon(
                    //   Icons.notifications_outlined,
                    //   textDirection: TextDirection.ltr,
                    //   size: 20,
                    //   // color: Theme.of(context).colorScheme.secondary,
                    // )
                  ],
                ),
              ),
            ],
          ),
          AppButton(
            Translate.of(context).translate('sign_out'),
            mainAxisSize: MainAxisSize.max,
            onPressed: _onLogout,
            type: ButtonType.text,
          )
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserModel?>(
          builder: (context, user) {
            if (user == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).dividerColor.withOpacity(
                                .05,
                              ),
                          spreadRadius: 4,
                          blurRadius: 4,
                          offset: const Offset(
                            0,
                            2,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: AppUserInfo(
                      user: user,
                      type: UserViewType.information,
                      onPressed: () {
                        _onProfile(user);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: <Widget>[
                      if (!AppBloc.userCubit.state!.phoneNumberConfirmed)
                        AppListTitle(
                          title: Translate.of(context).translate(
                            'confirm_phone_number',
                          ),
                          trailing: RotatedBox(
                            quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              AppLanguage.isRTL()
                                  ? Icons.keyboard_arrow_right
                                  : Icons.keyboard_arrow_left,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.otp,
                              arguments: {
                                "userId": AppBloc.userCubit.state!.id,
                                "routeName": null
                              },
                            );
                          },
                        ),
                      AppListTitle(
                        title: Translate.of(context).translate(
                          'edit_profile',
                        ),
                        trailing: RotatedBox(
                          quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                        onPressed: () {
                          _onNavigate(Routes.editProfile);
                        },
                      ),
                      AppListTitle(
                        title: Translate.of(context).translate(
                          'change_password',
                        ),
                        trailing: RotatedBox(
                          quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                        onPressed: () {
                          _onNavigate(Routes.changePassword);
                        },
                      ),
                      // AppListTitle(
                      //   title: Translate.of(context).translate(
                      //     'my_booking',
                      //   ),
                      //   trailing: RotatedBox(
                      //     quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                      //     child: const Icon(
                      //       Icons.keyboard_arrow_right,
                      //       textDirection: TextDirection.ltr,
                      //     ),
                      //   ),
                      //   onPressed: () {
                      //     _onNavigate(Routes.bookingList);
                      //   },
                      // ),
                      AppListTitle(
                        title: Translate.of(context).translate('setting'),
                        onPressed: () {
                          _onNavigate(Routes.setting);
                        },
                        trailing: RotatedBox(
                          quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                      AppListTitle(
                        title: Translate.of(context).translate(
                          'contact_us',
                        ),
                        trailing: RotatedBox(
                          quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                        onPressed: () {
                          _onNavigate(Routes.contactUs);
                        },
                      ),
                      AppListTitle(
                        title: Translate.of(context).translate(
                          'about_us',
                        ),
                        trailing: RotatedBox(
                          quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                        onPressed: () {
                          _onNavigate(Routes.aboutUs);
                        },
                      ),
                      AppListTitle(
                        title: Translate.of(context).translate('deactivate'),
                        onPressed: _onDeactivate,
                        trailing: RotatedBox(
                          quarterTurns: AppLanguage.isRTL() ? 2 : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                        border: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  buildBanner(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
