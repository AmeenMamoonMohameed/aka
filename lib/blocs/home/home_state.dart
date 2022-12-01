import 'package:akarak/models/model.dart';

import '../../models/model_location.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<LocationModel> popularLocations;
  final List<ProductModel> recentPosts;

  HomeSuccess({
    required this.popularLocations,
    required this.recentPosts,
  });
}
