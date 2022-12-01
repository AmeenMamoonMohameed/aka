import 'package:bloc/bloc.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/repository/repository.dart';

import 'cubit.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewLoading());

  Future<void> onLoad(int id) async {
    ///Notify
    emit(ReviewLoading());

    ///Fetch API
    final result = await ReviewRepository.loadReview(id);
    if (result != null) {
      ///Notify
      emit(
        ReviewSuccess(
          list: result[0],
          rate: result[1],
        ),
      );
    }
  }

  Future<bool> onSave({
    required int id,
    required int postId,
    required String content,
    required double rate,
  }) async {
    ///Fetch API
    final result = await ReviewRepository.saveReview(
      id: id,
      postId: postId,
      content: content,
      rate: rate,
    );
    if (result) {
      final result = await ReviewRepository.loadReview(postId);
      if (result != null) {
        ///Notify
        emit(
          ReviewSuccess(
            postId: postId,
            list: result[0],
            rate: result[1],
          ),
        );
      }
    }
    return result;
  }

  Future<bool> onSaveReplay({
    required int id,
    required int reviewId,
    required int postId,
    required String content,
  }) async {
    ///Fetch API
    final result = await ReviewRepository.saveReplay(
      id: id,
      reviewId: reviewId,
      content: content,
    );
    if (result) {
      final result = await ReviewRepository.loadReview(postId);
      if (result != null) {
        ///Notify
        emit(
          ReviewSuccess(
            postId: postId,
            list: result[0],
            rate: result[1],
          ),
        );
      }
    }
    return result;
  }

  Future<bool> onRemove({
    required int id,
    required ReviewType type,
  }) async {
    ///Fetch API
    if (type == ReviewType.review) {
      final result = await ReviewRepository.removeReview(
        id: id,
      );
      return result;
    } else {
      final result = await ReviewRepository.removeReplay(
        id: id,
      );
      return result;
    }

    // if (result) {
    //   final result = await ReviewRepository.loadReview(postId);
    //   if (result != null) {
    //     ///Notify
    //     emit(
    //       ReviewSuccess(
    //         postId: postId,
    //         list: result[0],
    //         rate: result[1],
    //       ),
    //     );
    //   }
    // }
  }
}
