import 'package:flutter/cupertino.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/utils/utils.dart';

enum LocationType { country, state, city }

class LocationModel {
  final int id;
  final int parentId;
  final String title;
  final int? count;
  final String? image;
  final IconData? icon;
  final Color? color;
  final LocationType? locationType;

  LocationModel({
    required this.id,
    required this.parentId,
    required this.title,
    this.count,
    this.image,
    this.icon,
    this.color,
    this.locationType = LocationType.country,
  });

  @override
  bool operator ==(Object other) => other is LocationModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    LocationType locationType = LocationType.country;
    String? image;
    if (json['locationType'] != null) {
      locationType = json['locationType'] == 2
          ? LocationType.city
          : json['locationType'] == 1
              ? LocationType.state
              : LocationType.country;
    }
    if (json['image'] != null) {
      image = json['image'] ?? '';
    }

    final icon = UtilIcon.getIconFromCss(json['icon']);
    final color = UtilColor.getColorFromHex(json['color']);
    return LocationModel(
      id: json['id'] ?? 0,
      parentId: json['parentId'] ?? json['parentId'] ?? 0,
      title: json['title'] ?? 'Unknown',
      count: json['count'] ?? 0,
      image: image,
      icon: icon,
      color: color,
      locationType: locationType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'title': title,
      'count': count,
      'image': image,
      'color': color?.toHex,
      'locationType': locationType?.index,
    };
  }
}
