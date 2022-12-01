import 'package:flutter/material.dart';
import 'package:akarak/configs/config.dart';
import 'package:akarak/models/model.dart';

import 'model_feature.dart';
import 'model_location.dart';

class FilterModel {
  SectionType section;
  CategoryModel? category;
  final List<int> features;
  final List<int> roomsFilter;
  LocationModel? country;
  LocationModel? state;
  LocationModel? city;
  double? distance;
  CurrencyModel? currency;
  double? minPriceFilter;
  double? maxPriceFilter;
  UnitModel? unit;
  double? minAreaFilter;
  double? maxAreaFilter;
  FinishingType? finishingType;
  OverlookingType? overlooking;
  // String? color;
  SortModel? sortOptions;
  // TimeOfDay? startHour;
  // TimeOfDay? endHour;
  List<ExtendedAttributeModel>? extendedAttributes = [];

  FilterModel({
    required this.section,
    this.category,
    required this.features,
    required this.roomsFilter,
    this.country,
    this.state,
    this.city,
    this.distance,
    this.minPriceFilter,
    this.maxPriceFilter,
    this.currency,
    this.minAreaFilter,
    this.maxAreaFilter,
    this.unit,
    this.finishingType,
    this.overlooking,
    // this.color,
    this.sortOptions,
    // this.startHour,
    // this.endHour,
    this.extendedAttributes,
  });

  factory FilterModel.fromDefault() {
    return FilterModel(
      section: SectionType.sale,
      features: [],
      roomsFilter: [],
      sortOptions: Application.setting.sortOptions.first,
      extendedAttributes: [],
      // startHour: Application.setting.startHour,
      // endHour: Application.setting.endHour,
    );
  }

  factory FilterModel.fromSource(source) {
    return FilterModel(
      section: source.section,
      category: source.category,
      features: List<int>.from(source.features),
      roomsFilter: List<int>.from(source.roomsFilter),
      country: source.country,
      state: source.state,
      city: source.city,
      distance: source.distance,
      minPriceFilter: source.minPriceFilter,
      maxPriceFilter: source.maxPriceFilter,
      currency: source.currency,
      minAreaFilter: source.minAreaFilter,
      maxAreaFilter: source.maxAreaFilter,
      unit: source.unit,
      finishingType: source.finishingType,
      overlooking: source.overlooking,
      // color: source.color,
      sortOptions: source.sortOptions,
      // startHour: source.startHour,
      // endHour: source.endHour,
      extendedAttributes: source.extendedAttributes,
    );
  }

  FilterModel clone() {
    return FilterModel.fromSource(this);
  }

  void clear() {
    section = SectionType.sale;
    category = null;
    features.clear();
    roomsFilter.clear();
    sortOptions = Application.setting.sortOptions.first;
    country = null;
    state = null;
    city = null;
    distance = null;
    minPriceFilter = null;
    maxPriceFilter = null;
    currency = null;
    minAreaFilter = null;
    maxAreaFilter = null;
    unit = null;
    finishingType = null;
    overlooking = null;
    extendedAttributes = null;
  }

  bool isEmpty() {
    if (section != SectionType.sale) return false;
    if (category != null) return false;
    if (features.isNotEmpty) return false;
    if (roomsFilter.isNotEmpty) return false;
    if (country != null) return false;
    if (state != null) return false;
    if (city != null) return false;
    if (distance != null) return false;
    if (minPriceFilter != null) return false;
    if (maxPriceFilter != null) return false;
    if (currency != null) return false;
    if (minAreaFilter != null) return false;
    if (maxAreaFilter != null) return false;
    if (unit != null) return false;
    if (finishingType != null) return false;
    if (overlooking != null) return false;
    if (sortOptions != Application.setting.sortOptions.first) return false;
    if (extendedAttributes != null && extendedAttributes!.isNotEmpty)
      return false;
    return true;
  }
}
