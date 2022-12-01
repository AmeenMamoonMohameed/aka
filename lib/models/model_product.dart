import 'package:flutter/material.dart';
import 'package:akarak/models/model.dart';

import '../configs/application.dart';
import '../utils/translate.dart';
import 'model_feature.dart';
import 'model_location.dart';

enum SectionType { sale, rent }

enum PaymentMethodType { cash, installment, cashAndInstallment }

enum RecordingType { none }

enum FinishingType { full, almostComplete, half, without }

enum OverlookingType {
  mainStreet,
  byStreet,
  twoStreets,
  threeStreets,
  garden,
  sea
}

enum ActiveReviewType { closed, open }

class ProductModel {
  final int id;
  final String title;
  final String content;
  final SectionType section;
  final PaymentMethodType? paymentMethod;
  final RecordingType? recording;
  final String image;
  final String videoURL;
  final CategoryModel? category;
  final String createDate;
  final String date;
  final String timeElapsed;
  final double rate;
  final num numRate;
  final String rateText;
  final String status;
  bool favorite;
  final String excerpt;
  final String color;
  final String icon;
  final List<String> tags;
  final String price;
  final String area;
  final LocationModel? country;
  final LocationModel? city;
  final LocationModel? state;
  final CurrencyModel? currency;
  final UnitModel? unit;
  final UserModel? createdBy;
  final List<String> gallery;
  final List<FeatureModel> features;
  final List<ProductModel> related;
  final List<ProductModel> latest;
  final List<OpenTimeModel> openHours;
  final List<FileModel> attachments;
  final CoordinateModel? coordinate;
  final String link;
  final bool bookingUse;
  final bool activeRating;
  final ActiveReviewType activeReviews;
  final List<ExtendedAttributeModel> extendedAttributes;
  final int views;

  ProductModel({
    required this.id,
    required this.title,
    required this.section,
    required this.paymentMethod,
    this.recording,
    required this.image,
    required this.videoURL,
    this.category,
    required this.createDate,
    required this.date,
    required this.timeElapsed,
    required this.rate,
    required this.numRate,
    required this.rateText,
    required this.status,
    required this.favorite,
    required this.content,
    required this.excerpt,
    required this.color,
    required this.icon,
    required this.tags,
    required this.price,
    required this.area,
    this.country,
    this.city,
    this.state,
    this.currency,
    this.unit,
    this.createdBy,
    required this.gallery,
    required this.features,
    required this.related,
    required this.latest,
    required this.openHours,
    this.coordinate,
    required this.attachments,
    required this.link,
    required this.bookingUse,
    required this.activeRating,
    required this.activeReviews,
    required this.extendedAttributes,
    required this.views,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json, {
    SettingModel? setting,
  }) {
    SectionType section = SectionType.sale;
    PaymentMethodType? paymentMethod;
    RecordingType? recording;
    List<String> gallery = [];
    List<FeatureModel> features = [];
    List<OpenTimeModel> openHours = [];
    List<FileModel> attachments = [];
    List<String> tags = [];
    UserModel? createdBy;
    CategoryModel? category;
    CoordinateModel? coordinate;
    LocationModel? country;
    LocationModel? state;
    CurrencyModel? currency;
    UnitModel? unit;
    LocationModel? city;
    String status = '';
    String videoURL = '';
    String date = '';
    String timeElapsed = '';
    String price = '';
    String area = '';
    bool activeRating = false;
    ActiveReviewType activeReviews = ActiveReviewType.closed;
    List<ExtendedAttributeModel>? extendedAttributes = [];

    if (json['extendedAttributes'] != null) {
      extendedAttributes =
          List.from(json['extendedAttributes'] ?? []).map((item) {
        return ExtendedAttributeModel.fromJson(item);
      }).toList();
    }

    if (json['createdBy'] != null) {
      createdBy = UserModel.fromJson(json['createdBy']);
    }

    if (json['categoryId'] != null) {
      category = Application.submitSetting.categories
          .singleWhere((c) => c.id == json['categoryId']);
    }

    if (json['country'] != null && json['country'] != null) {
      country = LocationModel.fromJson(json['country']);
    }

    if (json['state'] != null) {
      state = LocationModel.fromJson(json['state']);
    }

    if (json['city'] != null) {
      city = LocationModel.fromJson(json['city']);
    }

    if (json['currencyId'] != null) {
      currency = Application.submitSetting.currencies.singleWhere(
          (item) => item.id == (int.tryParse('${json['currencyId']}') ?? 0));
    }

    if (json['unitId'] != null) {
      unit = Application.submitSetting.units.singleWhere(
          (item) => item.id == (int.tryParse('${json['unitId']}') ?? 0));
    }

    if (json['latitude'] != null && setting?.useViewMap == true) {
      coordinate = CoordinateModel.fromJson({
        "name": json['title'] ?? "",
        "latitude": json['latitude'] ?? "",
        "longitude": json['longitude'] ?? ""
      });
    }

    // if (json['area'] != null) {
    //   area = int.parse(json['area'].toString());
    // }

    // if (json['floors'] != null) {
    //   floors = int.parse(json['floors'].toString());
    // }

    // if (json['rooms'] != null) {
    //   rooms = int.parse(json['rooms'].toString());
    // }

    // if (json['baths'] != null) {
    //   baths = int.parse(json['baths'].toString());
    // }

    // if (json['yearOfCompletion'] != null) {
    //   yearOfCompletion = int.parse(json['baths'].toString());
    // }

    if (json['section'] != null) {
      section = json['section'] == null
          ? SectionType.sale
          : SectionType.values[json['section']];
    }

    if (json['paymentMethod'] != null) {
      paymentMethod = json['paymentMethod'] == null
          ? PaymentMethodType.cash
          : PaymentMethodType.values[json['paymentMethod']];
    }

    // if (json['recording'] != null) {
    //   recording = json['recording'] == null
    //       ? RecordingType.none
    //       : RecordingType.values[json['recording']];
    // }

    // if (json['finishingType'] != null) {
    //   finishingType = json['finishingType'] == null
    //       ? null
    //       : FinishingType.values[json['finishingType']];
    // }

    // if (json['overlooking'] != null) {
    //   overlooking = json['overlooking'] == null
    //       ? null
    //       : OverlookingType.values[json['overlooking']];
    // }

    if (json['ratingStatus'] != null) {
      activeRating = json['ratingStatus'] == 1;
    }

    if (json['activeReviews'] != null) {
      activeReviews = ActiveReviewType.values[json['activeReviews']];
    }

    if (setting?.useViewGalleries == true) {
      gallery = extendedAttributes.where((e) => e.key == "gallery").map((item) {
        return item.text!;
      }).toList();
    }

    if (setting?.useViewStatus == true) {
      status = json['statusText'] ?? '';
    }

    if (setting?.useViewVideo == true) {
      videoURL = json['video_url'] ?? '';
    }

    // if (setting?.useViewAddress == true) {
    //   address = json['address'] ?? '';
    // }

    // if (setting?.useViewPhone == true) {
    //   phone = json['phone'] ?? '';
    // }

    // if (setting?.useViewEmail == true) {
    //   email = json['email'] ?? '';
    // }

    // if (setting?.useViewWebsite == true) {
    //   website = json['website'] ?? '';
    // }

    // if (setting?.useViewFacebook == true) {
    //   facebook = json['facebook'] ?? '';
    // }
    // if (setting?.useViewWhatsapp == true) {
    //   whatsapp = json['whatsapp'] ?? '';
    // }
    if (setting?.useViewDateEstablish == true) {
      date = json['date'] ?? '';
    }
    if (setting?.useViewTimeElapsed == true) {
      timeElapsed = json['timeElapsed'] ?? '';
    }

    if (setting?.useViewPrice == true) {
      price = json['price']?.toString() ?? '';
    }

    if (setting?.useViewArea == true) {
      area = json['area']?.toString() ?? '';
    }

    if (setting?.useViewFeature == true) {
      features = List.from(json['features'] ?? []).map((item) {
        return FeatureModel.fromJson(item);
      }).toList();
    }

    final listRelated = List.from(json['related'] ?? []).map((item) {
      return ProductModel.fromJson(item, setting: setting);
    }).toList();

    final listLatest = List.from(json['lastest'] ?? []).map((item) {
      return ProductModel.fromJson(item, setting: setting);
    }).toList();

    if (setting?.useViewOpenHours == true) {
      openHours = List.from(json['opening_hour'] ?? []).map((item) {
        return OpenTimeModel.fromJson(item);
      }).toList();
    }

    if (setting?.useViewTags == true) {
      tags = List.from(json['tags'] ?? []).map((item) {
        return item.toString();
      }).toList();
    }

    if (setting?.useViewAttachment == true) {
      attachments = List.from(json['attachments'] ?? []).map((item) {
        return FileModel.fromJson(item);
      }).toList();
    }

    return ProductModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      section: section,
      paymentMethod: paymentMethod,
      recording: recording,
      image: json['image'] ?? '',
      videoURL: "https://www.youtube.com/watch?v=jA2ko58woS0", //videoURL,
      category: category,
      createDate: json['post_date'] ?? '',
      date: date,
      timeElapsed: timeElapsed,
      rate: double.tryParse('${json['rate']}') ?? 0.0,
      numRate: json['numRate'] ?? 0,
      rateText: json['post_status'] ?? '',
      status: status,
      favorite: json['favorite'] == true,
      // area: area,
      // floors: floors,
      // rooms: rooms,
      // baths: baths,
      // yearOfCompletion: yearOfCompletion,
      // finishingType: finishingType,
      // overlooking: overlooking,
      // address: address,
      // whatsapp: whatsapp,
      // phone: phone,
      // fax: json['fax'] ?? '',
      // email: email,
      // website: website,
      // facebook: facebook,
      content: json['content'] ?? '',
      excerpt: json['excerpt'] ?? '',
      color: json['color'] ?? '',
      icon: json['icon'] ?? '',
      tags: tags,
      price: price,
      area: area,
      country: country,
      state: state,
      city: city,
      currency: currency,
      unit: unit,
      features: features,
      createdBy: createdBy,
      gallery: gallery,
      related: listRelated,
      latest: listLatest,
      openHours: openHours,
      coordinate: coordinate,
      attachments: attachments,
      link: json['guid'] ?? '',
      bookingUse: json['bookingUse'] ?? false,
      activeRating: activeRating,
      activeReviews: activeReviews,
      extendedAttributes: extendedAttributes,
      views: int.tryParse(json['views']?.toString() ?? "0") ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "title": title, "image": image};
  }

  Map<String, Object?> getProperties() {
    Map<String, Object?> result = <String, Object?>{};

    extendedAttributes
        .where((element) => element.group == "property")
        .forEach((item) {
      if (item.getValue() != null) {
        result[item.key] = item.getValue();
      }
    });

    // if (extendedAttributes != null) {
    //   extendedAttributes.forEach((item) {
    //     result[item.key] = item.getValue();
    //   });
    // }
    return result;
  }
}
