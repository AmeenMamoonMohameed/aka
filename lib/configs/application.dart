import 'package:akarak/models/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Application {
  static bool debug = true;
  static String googleAPI = 'AIzaSyDAtS8sIe9asGlJx5daag_ctKKErHVvqns';
  static String googleAPIIos = 'AIzaSyD_T8QC8UCZIH0pNE947U2B3fb1eLOH6nU';
  // static String googleAPI = 'AIzaSyB5k4khJT_04dUA7lfk2RF98p65j6hMKnA';
  // static String host = '10.0.2.2';
  // static String domain = 'http://10.0.2.2:5000/';
  // static String host = 'akarak-001-site4.gtempurl.com';
  // static String domain = 'http://akarak-001-site4.gtempurl.com/';
  static String host = 'akarak-001-site1.gtempurl.com';
  static String domain = 'http://akarak-001-site1.gtempurl.com/';
  static DeviceModel? device;
  static PackageInfo? packageInfo;
  static SettingModel setting = SettingModel.fromDefault();
  static SubmitSettingModel submitSetting = SubmitSettingModel.fromDefault();
  static List<LocationModel> countries = [];
  static LocationModel? currentCountry;
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
