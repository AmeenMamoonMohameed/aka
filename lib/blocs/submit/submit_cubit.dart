import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/repository/repository.dart';
import 'package:akarak/utils/utils.dart';

import '../../models/model_feature.dart';
import '../../models/model_location.dart';
import 'cubit.dart';

class SubmitCubit extends Cubit<SubmitState> {
  SubmitCubit() : super(SubmitInitial());

  Future<bool> onSubmit({
    int? id,
    required String title,
    required SectionType section,
    required String content,
    LocationModel? country,
    LocationModel? state,
    LocationModel? city,
    String? status,
    String? date,
    String? image,
    PaymentMethodType? paymentMethod,
    required CurrencyModel currency,
    String? price,
    required UnitModel unit,
    String? area,
    CoordinateModel? gps,
    // required List<String> tags,
    required CategoryModel category,
    required List<FeatureModel> features,
    List<ExtendedAttributeModel>? extendedAttributes,
        // Map<String, dynamic>? socials,

    // List<OpenTimeModel>? time,
  }) async {
    Map<String, dynamic> params = {
      "id": id ?? 0,
      "title": title,
      "section": section.index,
      "content": content,
      "country": country?.id,
      "state": state?.id,
      "city": city?.id,
      "categoryId": category.id,
      "paymentMethod": paymentMethod!.index,
      "statusText": status,
      // "date": date,
      "image": image,
      "features": features.map((e) => e.id).toList(),
      "currencyId": currency.id,
      "price": double.tryParse(price!),
      "unitId": unit.id,
      "area": double.tryParse(area!),
      "longitude": gps?.longitude,
      "latitude": gps?.latitude,
      "extendedAttributes": extendedAttributes!.map((e) => e.toJson()).toList(),
      // "tags_input": tags.join(",")
    };
    // if (time != null && time.isNotEmpty) {
    //   for (var i = 0; i < time.length; i++) {
    //     final item = time[i];
    //     if (item.schedule.isNotEmpty) {
    //       for (var x = 0; x < item.schedule.length; x++) {
    //         final element = item.schedule[x];
    //         final d = item.dayOfWeek;
    //         params['opening_hour[$d][start][$x]'] = element.start.viewTime;
    //         params['opening_hour[$d][end][$x]'] = element.end.viewTime;
    //       }
    //     }
    //   }
    // }
    // if (socials != null && socials.isNotEmpty) {
    //   socials.forEach((k, v) {
    //     params['socials[$k]'] = v;
    //   });
    // }

    ///Fetch API
    final result = await ListRepository.saveProduct(params);

    ///Notify
    emit(Submitted());
    return result;
  }
}
