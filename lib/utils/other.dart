import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/utils/utils.dart';

class UtilOther {
  static fieldFocusChange(
    BuildContext context,
    FocusNode current,
    FocusNode next,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static hiddenKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<DeviceModel?> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final android = await deviceInfoPlugin.androidInfo;
        return DeviceModel(
          uuid: android.androidId,
          model: "Android",
          version: android.version.sdkInt.toString(),
          type: android.model,
        );
      } else if (Platform.isIOS) {
        final IosDeviceInfo ios = await deviceInfoPlugin.iosInfo;
        return DeviceModel(
          uuid: ios.identifierForVendor,
          name: ios.name,
          model: ios.systemName,
          version: ios.systemVersion,
          type: ios.utsname.machine,
        );
      }
    } catch (e) {
      UtilLogger.log("ERROR", e);
    }
    return null;
  }

  static Future<String?> getDeviceToken() async {
    var d = await FirebaseMessaging.instance.getToken();
    await FirebaseMessaging.instance.requestPermission();
    return await FirebaseMessaging.instance.getToken();
  }

  static Map<String, dynamic> buildFilterParams(FilterModel filter) {
    Map<String, dynamic> params = {
      "category": filter.category?.id,
      // "feature": filter.feature.map((item) {
      //   return item.id;
      // }).toList(),
    };
    params['section'] = filter.section.index;
    if (filter.country != null) {
      params['country'] = filter.country!.id;
    }
    if (filter.state != null) {
      params['state'] = filter.state!.id;
    }
    if (filter.city != null) {
      params['city'] = filter.city!.id;
    }
    if (filter.distance != null) {
      params['distance'] = filter.distance;
    }
    if (filter.currency != null) {
      params['currencyId'] = filter.currency!.id;
    }
    if (filter.minPriceFilter != null) {
      params['priceMin'] = filter.minPriceFilter!.toInt();
    }
    if (filter.maxPriceFilter != null) {
      params['priceMax'] = filter.maxPriceFilter!.toInt();
    }
    if (filter.unit != null) {
      params['unitId'] = filter.unit!.id;
    }
    if (filter.minAreaFilter != null) {
      params['areaMin'] = filter.minAreaFilter!.toInt();
    }
    if (filter.maxAreaFilter != null) {
      params['areaMax'] = filter.maxAreaFilter!.toInt();
    }
    if (filter.features.isNotEmpty) {
      params['features'] = filter.features.map((item) {
        return item;
      }).toList();
    }
    if (filter.sortOptions != null) {
      params['orderby'] = filter.sortOptions!.field;
      params['order'] = filter.sortOptions!.value;
    }
    if (filter.extendedAttributes != null) {
      params['extendedAttributes'] = filter.extendedAttributes;
    }
    return params;
  }

  ///Singleton factory
  static final UtilOther _instance = UtilOther._internal();

  factory UtilOther() {
    return _instance;
  }

  UtilOther._internal();
}
