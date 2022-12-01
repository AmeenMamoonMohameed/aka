import 'package:flutter/cupertino.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/utils/utils.dart';

enum CategoryType { main, sub }

class CategoryModel {
  late final int id;
  final int? parentId;
  final String title;
  final String description;
  final List<GroupModel>? groups;
  final int? count;
  final String? image;
  final IconData? icon;
  final String? iconUrl;
  final Color? color;
  final CategoryType? type;

  CategoryModel({
    required this.id,
    this.parentId,
    required this.title,
    this.groups,
    required this.description,
    this.count,
    this.image,
    this.icon,
    this.iconUrl,
    this.color,
    this.type,
  });

  @override
  bool operator ==(Object other) => other is CategoryModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    CategoryType type = CategoryType.values[
        int.parse(json['type'] == null ? "0" : json['type'].toString())];
    final icon = UtilIcon.getIconFromCss("fas fa-archway");
    final color = UtilColor.getColorFromHex(json['color'] ?? "ff2b5097");
    return CategoryModel(
      id: json['id'] ?? 0,
      parentId: json['parentId'],
      title: json['title'] ?? 'Unknown',
      groups: json['groups'] == null
          ? []
          : List.from(json['groups'])
              .map((e) => GroupModel.fromJson(e))
              .toList(),
      description: json['description'] ?? 'Unknown',
      count: json['count'] ?? 0,
      image: json['image'] ?? '',
      icon: icon,
      iconUrl: json['icon'] ?? '',
      color: color,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'title': title,
      'groups': groups?.map((e) => e.toJson()).toList(),
      'count': count,
      'image': image,
      'color': color?.toHex,
      'type': type?.index,
    };
  }
}
