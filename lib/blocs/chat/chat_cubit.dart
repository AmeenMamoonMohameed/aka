import 'package:bloc/bloc.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/repository/repository.dart';

import '../../api/signalR.dart';
import '../../configs/application.dart';
import 'cubit.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatLoading());
  String contactId = '';
  int currentPage = 1;
  List<ChatModel> list = [];
  PaginationModel? pagination;

  Future<void> onLoad({required String contactId}) async {
    this.contactId = contactId;
    currentPage = 1;
    pagination = null;

    // emit(ChatSuccess(
    //   loadingMore: true,
    //   list: list,
    //   canLoadMore: pagination!.currentPage < pagination!.totalPages,
    // ));

    final result = await ChatRepository.loadChat(
      contactId: contactId,
      pageNumber: currentPage,
      pageSize: Application.setting.pageSize,
      loading: true,
    );

    ///Notify
    if (result != null) {
      list = result[0];
      pagination = result[1];

      emit(ChatSuccess_(
        list: list,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));

      await ChatRepository.sendDeliveredStatusForUsers([contactId]);
    }
  }

  Future<void> onLoadMore() async {
    currentPage = currentPage + 1;

    ///Notify
    emit(ChatSuccess_(
      loadingMore: true,
      list: list,
      canLoadMore: pagination!.currentPage < pagination!.totalPages,
    ));

    ///Fetch API
    final result = await ChatRepository.loadChat(
      contactId: contactId,
      pageNumber: currentPage,
      pageSize: Application.setting.pageSize,
      loading: false,
    );
    if (result != null) {
      list.addAll(result[0]);
      pagination = result[1];

      ///Notify
      emit(ChatSuccess_(
        list: list,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }

  Future<void> onSendReadStatus({required String fromUserId}) async {
    await ChatRepository.sendReadStatus(fromUserId: fromUserId);
  }
}
