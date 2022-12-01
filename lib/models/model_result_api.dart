import 'package:akarak/models/model.dart';

class ResultApiModel {
  final bool succeeded;
  final bool isDisplay;
  final dynamic data;
  final dynamic attr;
  final dynamic payment;
  final PaginationModel? pagination;
  final UserModel? user;
  final String message;

  ResultApiModel({
    required this.succeeded,
    required this.message,
    required this.isDisplay,
    this.data,
    this.pagination,
    this.attr,
    this.payment,
    this.user,
  });

  factory ResultApiModel.fromJson(Map<String, dynamic> json) {
    UserModel? user;
    PaginationModel? pagination;
    String message = 'Unknown';

    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }
    if (json['currentPage'] != null) {
      pagination = PaginationModel.fromJson(json);
    }
    if (json['succeeded'] == true) {
      message = "save_data_success";
    }
    return ResultApiModel(
      succeeded: json['succeeded'] ?? false,
      isDisplay: json['isDisplay'] ?? false,
      data: json['data'],
      pagination: pagination,
      attr: json['attr'],
      payment: json['payment'],
      user: user,
      message: json['message'] ?? json['msg'] ?? message,
    );
  }
}
