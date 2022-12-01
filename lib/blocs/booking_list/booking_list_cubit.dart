import 'package:bloc/bloc.dart';
import 'package:akarak/configs/config.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/repository/repository.dart';

import 'cubit.dart';

class BookingListCubit extends Cubit<BookingListState> {
  BookingListCubit() : super(BookingListLoading());

  int page = 1;
  List<BookingItemModel> list = [];
  PaginationModel? pagination;
  SortModel? sort;
  SortModel? status;
  List<SortModel> sortOption = [];
  List<SortModel> statusOption = [];

  Future<void> onLoad({
    SortModel? sort,
    SortModel? status,
    String? keyword,
  }) async {
    page = 1;

    ///Fetch API
    final result = await BookingRepository.loadList(
      page: page,
      perPage: Application.setting.pageSize,
      sort: sort,
      status: status,
      keyword: keyword,
    );
    if (result != null) {
      list = result[0];
      pagination = result[1];
      if (sortOption.isEmpty) {
        sortOption = result[2];
      }
      if (statusOption.isEmpty) {
        statusOption = result[3];
      }

      ///Notify
      emit(BookingListSuccess(
        list: list,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }

  Future<void> onLoadMore({
    SortModel? sort,
    SortModel? status,
    String? keyword,
  }) async {
    page = page + 1;

    ///Notify
    emit(BookingListSuccess(
      loadingMore: true,
      list: list,
      canLoadMore: pagination!.currentPage < pagination!.totalPages,
    ));

    ///Fetch API
    final result = await BookingRepository.loadList(
      page: page,
      perPage: Application.setting.pageSize,
      sort: sort,
      status: status,
      keyword: keyword,
    );

    if (result != null) {
      list.addAll(result[0]);
      pagination = result[1];

      ///Notify
      emit(BookingListSuccess(
        list: list,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }
}
