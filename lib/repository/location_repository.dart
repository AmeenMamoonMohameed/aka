import 'dart:convert';

import 'package:akarak/api/api.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/models/model.dart';

import '../configs/preferences.dart';
import '../models/model_location.dart';

class LocationRepository {
  ///Load Location
  static Future<List<LocationModel>?> loadLocation(LocationType? type) async {
    final result = await Api.requestLocation(type);
    if (result.succeeded) {
      return List.from(result.data ?? []).map((item) {
        return LocationModel.fromJson(item);
      }).toList();
    }
    AppBloc.messageCubit.onShow(result.message);
    return List<LocationModel>.empty();
  }

  ///Load Location
  static Future<List<LocationModel>?> loadLocationById(int id) async {
    final result = await Api.requestLocationById({"parentId": id});
    if (result.succeeded) {
      return List.from(result.data ?? []).map((item) {
        return LocationModel.fromJson(item);
      }).toList();
    }
    AppBloc.messageCubit.onShow(result.message);
    return null;
  }

  ///Change Current Country
  static Future<void> onChangeCountry({required LocationModel country}) async {
    ///Current Country
    await Preferences.setString(
      Preferences.currentCountry,
      jsonEncode(country.toJson()),
    );
  }

  ///Get Current Country
  static LocationModel? loadCountry() {
    ///Current Country
    var country = Preferences.get(Preferences.currentCountry);
    if (country != null) return LocationModel.fromJson(jsonDecode(country));
    return null;
  }
}
