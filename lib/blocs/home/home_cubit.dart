import 'package:bloc/bloc.dart';
import 'package:akarak/api/api.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/configs/config.dart';
import 'package:akarak/models/model.dart';

import '../../models/model_location.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  Future<void> onLoad() async {
    ///Fetch API Home
    final response = await Api.requestHome();
    if (response.succeeded) {
      final popularLocations =
          List.from(response.data['popularLocations'] ?? []).map((item) {
        return LocationModel.fromJson(item);
      }).toList();

      final recentPosts =
          List.from(response.data['recentPosts'] ?? []).map((item) {
        return ProductModel.fromJson(
          item,
          setting: Application.setting,
        );
      }).toList();

      ///Notify
      emit(HomeSuccess(
        popularLocations: popularLocations,
        recentPosts: recentPosts,
      ));
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
  }
}
