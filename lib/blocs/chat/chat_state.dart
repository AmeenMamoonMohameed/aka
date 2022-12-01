import 'package:akarak/models/model.dart';

abstract class ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess_ extends ChatState {
  final List<ChatModel> list;
  final bool canLoadMore;
  final bool loadingMore;
  ChatSuccess_({
    required this.list,
    required this.canLoadMore,
    this.loadingMore = false,
  });
}
