import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/configs/config.dart';
import 'package:akarak/repository/list_repository.dart';

import 'cubit.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(InitialSearchState());
  Timer? timer;

  void onSearch(String keyword) async {
    if (keyword.isNotEmpty) {
      timer?.cancel();
      timer = Timer(const Duration(milliseconds: 500), () async {
        emit(SearchLoading());
        final result = await ListRepository.loadList(
          searchString: keyword,
          pageSize: Application.setting.pageSize,
          pageNumber: 1,
        );
        if (result != null) {
          emit(SearchSuccess(list: result[0]));
        }
      });
    }
  }

  void onClear() {
    emit(InitialSearchState());
  }
}
