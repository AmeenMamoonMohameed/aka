import 'package:bloc/bloc.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/repository/repository.dart';

import 'cubit.dart';

class SubmitMessageCubit extends Cubit<SubmitMessageState?> {
  SubmitMessageCubit() : super(SubmitLoading());

  Future<int?> onSave({required ChatModel message}) async {
    final id = await ChatRepository.saveMessage(message: message);
    if (id != null) {
      emit(SubmitSuccess(id));
    }
    return id;
  }
}
