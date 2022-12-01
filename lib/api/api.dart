import 'dart:async';
import 'package:akarak/api/http_manager.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/utils/utils.dart';
import '../blocs/app_bloc.dart';
import 'package:uuid/uuid.dart';

class Api {
  static final httpManager = HTTPManager();

  ///URL API
  static const String login = "api/identity/token";
  static const String authValidate = "api/identity/token/validateToken";
  static const String user = "api/identity/user/get-current";
  static const String register = "api/identity/user/register";
  static const String confirmPhoneNumber =
      "api/identity/user/confirm-phone-number";
  static const String confirmForgotPassword =
      "api/identity/user/confirm-forgot-password";
  static const String sendVerificationPhoneNumber =
      "api/identity/user/send-verification-phone-number";
  static const String forgotPassword = "api/identity/user/forgot-password";
  static const String validationPhoneNumber =
      "api/identity/user/validation-phone-number";
  static const String changePassword = "api/identity/account/changePassword";
  static const String resetPassword = "api/identity/user/reset-password";
  static const String changeProfile = "api/identity/account/updateProfile";
  static const String getUserRating = "api/identity/user/get-user-rating";
  static const String setting = "api/v1/setting/general";
  // static const String setting = "api/v1/setting";
  static const String submitSetting = "api/v1/setting/submit";
  static const String home = "api/v1/home";
  static const String categories = "api/v1/categories";
  static const String discovery = "";
  static const String withLists = "api/v1/wishs";
  static const String addWishList = "api/v1/wishs/";
  static const String removeWishList = "api/v1/wishs/";
  static const String clearWithList = "api/v1/wishs/clear";
  static const String list = "api/v1/posts/list";
  static const String deleteProduct = "api/v1/posts";
  static const String authorList = "api/v1/posts/user-list";
  static const String authorReview = "api/v1/reviews/list";
  static const String tags = "/akarak/v1/place/terms";
  static const String reviews = "api/v1/reviews/";
  static const String saveReview = "api/v1/reviews/";
  static const String removeReview = "api/v1/reviews/";
  static const String saveReplay = "api/v1/reviews/replay";
  static const String removeReplay = "api/v1/reviews/replay/";
  static const String product = "api/v1/posts/get";
  static const String addView = "api/v1/posts/add-view";
  static const String saveProduct = "api/v1/posts";
  static const String locations = "api/v1/locations";
  static const String locationsById = "api/v1/locations/get-all/";
  static const String uploadImage = "api/utilities/upload/upload-image";
  static const String uploadImageBytes = "api/utilities/upload/image";
  static const String bookingForm = "/akarak/v1/booking/form";
  static const String calcPrice = "/akarak/v1/booking/cart";
  static const String order = "/akarak/v1/booking/order";
  static const String bookingDetail = "/akarak/v1/booking/view";
  static const String bookingList = "/akarak/v1/booking/list";
  static const String bookingCancel = "/akarak/v1/booking/cancel_by_id";
  static const String sendContactUs = "api/v1/contactUs";
  static const String blockUser = "api/identity/user/block-user";
  static const String unblockUser = "api/identity/user/unblock-user";
  static const String sendPostReport = "api/v1/posts/send-report";
  static const String sendProfileReport = "api/identity/user/send-report";
  static const String sendReviewReport = "api/v1/reviews/send-report";
  static const String sendChatReport = "api/v1/chats/send-report";
  static const String chatLoad = "api/chats/chat-history";
  static const String saveMessage = "api/chats";
  static const String ping = "api/chats/ping";
  static const String confirmReceiptStatus = "api/chats/confirm-receipt-status";
  static const String sendReadStatus = "api/chats/send-read-status";
  static const String sendDeliveredStatus = "api/chats/send-delivered-status";
  static const String sendDeliveredStatusUsers =
      "api/chats/send-delivered-status-users";
  static const String blockedUsers = "api/chats/blocked-users";
  static const String chatUsers = "api/chats/users";
  static const String profiles = "api/v1/companies";
  static const String deactivate = "api/identity/account/deactive";

  ///Login api
  static Future<ResultApiModel> requestLogin(params) async {
    final result = await httpManager.post(url: login, data: params);
    if (result['succeeded'] == true) {
      HTTPManager.key = const Uuid().v4();
    }
    return ResultApiModel.fromJson(result);
  }

  ///Validate token valid
  static Future<ResultApiModel> requestValidateToken() async {
    Map<String, dynamic> result = {};
    try {
      result = await httpManager.post(url: authValidate);
      result['success'] = result['code'] == 'jwt_auth_valid_token';
      result['message'] = result['code'] ?? result['message'];
    } catch (Exception) {
      result['success'] = result['code'] == 'jwt_auth_no_valid_token';
      result['message'] = result['code'] ?? 'jwt_auth_no_valid_token';
    }
    return ResultApiModel.fromJson(result);
  }

  ///Validation phone number
  static Future<ResultApiModel> requestValidationPhoneNumber(params) async {
    Map<String, dynamic> result = await httpManager.post(
      url: validationPhoneNumber,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Forgot password
  static Future<ResultApiModel> requestSendVerifiyCodeForgotPassword(
      params) async {
    Map<String, dynamic> result = await httpManager.post(
      url: forgotPassword,
      data: params,
      loading: true,
    );
    result['message'] = result['code'] ?? result['msg'];
    return ResultApiModel.fromJson(result);
  }

  ///Confirm Forgot Password
  static Future<ResultApiModel> requestConfirmForgotPassword(params) async {
    final result = await httpManager.post(
      // url:
      //     "$confirmForgotPassword/${params['countryCode']}/${params['phoneNumber']}/${params['otp']}",
      url: confirmForgotPassword,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Register account
  static Future<ResultApiModel> requestRegister(params) async {
    final result = await httpManager.post(
      url: register,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Confirm PhoneNumber
  static Future<ResultApiModel> requestConfirmPhoneNumber(params) async {
    final result = await httpManager.post(
      url: "$confirmPhoneNumber/${params['userId']}/${params['otp']}",
      // data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Resend Verification PhoneNumber
  static Future<ResultApiModel> requestSendVerificationPhoneNumber(
      params) async {
    final result = await httpManager.post(
      url:
          "$sendVerificationPhoneNumber/${params['userId']}/${params['confirmType']}",
      // data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Change Profile
  static Future<ResultApiModel> requestChangeProfile(params) async {
    final result = await httpManager.put(
      url: changeProfile,
      data: params,
      loading: true,
    );
    // final convertResponse = {
    //   "success": result['code'] == null,
    //   "message": result['code'] ?? "update_info_success",
    //   "data": result
    // };
    return ResultApiModel.fromJson(result);
  }

  ///change password
  static Future<ResultApiModel> requestChangePassword(params) async {
    final result = await httpManager.put(
      url: changePassword,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///change password
  static Future<ResultApiModel> requestResetPassword(params) async {
    final result = await httpManager.post(
      url: resetPassword,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get User
  static Future<ResultApiModel> requestUser() async {
    final result = await httpManager.get(url: user);
    return ResultApiModel.fromJson(result);
  }

  static Future<ResultApiModel> requestUserRating(String userId) async {
    final result =
        await httpManager.get(url: "$getUserRating/$userId", loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Get Setting
  static Future<ResultApiModel> requestSetting() async {
    final result = await httpManager.get(url: setting);
    return ResultApiModel.fromJson(result);
  }

  ///Get Submit Setting
  static Future<ResultApiModel> requestSubmitSetting(int countryId) async {
    final result = await httpManager.get(
      url: "$submitSetting/$countryId",
      // params: params,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Location
  static Future<ResultApiModel> requestLocation(LocationType? type) async {
    String url = locations;
    if (type != null) {
      url = "$locations?type=${type.index}";
    }
    final result = await httpManager.get(url: url);

    return ResultApiModel.fromJson(result);
  }

  ///Get Location
  static Future<ResultApiModel> requestLocationById(param) async {
    final result = await httpManager.get(
        url: "$locationsById ${param['parentId']}", loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Get Category
  static Future<ResultApiModel> requestCategory() async {
    final result = await httpManager.get(url: categories);
    return ResultApiModel.fromJson(result);
  }

  ///Get Discovery
  static Future<ResultApiModel> requestDiscovery() async {
    final result = await httpManager.get(url: discovery);
    return ResultApiModel.fromJson(result);
  }

  ///Get Home
  static Future<ResultApiModel> requestHome() async {
    final result = await httpManager.get(url: home);
    return ResultApiModel.fromJson(result);
  }

  ///Get ProductDetail
  static Future<ResultApiModel> requestProduct(params) async {
    final result = await httpManager.get(
      url: "$product/${params['id']}",
    );
    if (result['succeeded'] == true) {
      httpManager.post(url: addView, data: params).ignore();
    }
    return ResultApiModel.fromJson(result);
  }

  ///Get Wish List
  static Future<ResultApiModel> requestWishList(params) async {
    final result =
        await httpManager.get(url: withLists, params: {'id': params});
    return ResultApiModel.fromJson(result);
  }

  ///Save Wish List
  static Future<ResultApiModel> requestAddWishList(params) async {
    final result = await httpManager.post(url: addWishList + params.toString());
    return ResultApiModel.fromJson(result);
  }

  ///Save Product
  static Future<ResultApiModel> requestSaveProduct(params) async {
    final result = await httpManager.post(
      url: saveProduct,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Remove Wish List
  static Future<ResultApiModel> requestRemoveWishList(params) async {
    final result = await httpManager.delete(
      url: removeWishList + params.toString(),
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Clear Wish List
  static Future<ResultApiModel> requestClearWishList() async {
    final result = await httpManager.delete(url: clearWithList, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Get Product List
  static Future<ResultApiModel> requestList(params, loading) async {
    final result = await httpManager.post(
      url: list,
      data: params,
      loading: loading ?? true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Tags List
  static Future<ResultApiModel> requestTags(params) async {
    final result = await httpManager.get(url: tags, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Clear Wish List
  static Future<ResultApiModel> requestDeleteProduct(id) async {
    final result = await httpManager.delete(
      url: "$deleteProduct/$id",
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Author Product List
  static Future<ResultApiModel> requestAuthorList(params) async {
    final result = await httpManager.post(
      url: authorList,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Author Review List
  static Future<ResultApiModel> requestAuthorReview(params) async {
    final result = await httpManager.post(
      url: authorReview,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Review
  static Future<ResultApiModel> requestReview(params) async {
    final result =
        await httpManager.get(url: reviews + params["postId"].toString());
    return ResultApiModel.fromJson(result);
  }

  ///Save Review
  static Future<ResultApiModel> requestSaveReview(params) async {
    final result = await httpManager.post(
      url: saveReview,
      data: params,
      loading: true,
    );

    return ResultApiModel.fromJson(result);
  }

  ///Save Replay
  static Future<ResultApiModel> requestSaveReplay(params) async {
    final result = await httpManager.post(
      url: saveReplay,
      data: params,
      loading: true,
    );

    return ResultApiModel.fromJson(result);
  }

  ///Remove Review
  static Future<ResultApiModel> requestRemoveReview(id) async {
    final result = await httpManager.delete(
      url: removeReview + id.toString(),
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Remove Replay
  static Future<ResultApiModel> requestRemoveReplay(id) async {
    final result = await httpManager.delete(
      url: removeReplay + id.toString(),
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Companies
  static Future<ResultApiModel> requestProfiles({
    required int pageNumber,
    required int pageSize,
    required String searchString,
    required int userType,
    bool loading = false,
  }) async {
    final result = await httpManager.get(
        url:
            "$profiles?pageNumber=$pageNumber&pageSize=$pageSize&searchString=$searchString&userType=$userType");
    return ResultApiModel.fromJson(result);
  }

  ///Upload image
  static Future<ResultApiModel> requestUploadImage(formData, progress) async {
    var result = await httpManager.post(
      url: uploadImage,
      formData: formData,
      progress: progress,
    );

    final convertResponse = {"success": result['id'] != null, "data": result};
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Upload image Bytes
  static Future<ResultApiModel> requestUploadImageBytes(
      params, progress) async {
    var result = await httpManager.post(
      url: uploadImageBytes,
      data: params,
      progress: progress,
    );

    // final convertResponse = {"success": result['id'] != null, "data": result};
    return ResultApiModel.fromJson(result);
  }

  ///Get booking form
  static Future<ResultApiModel> requestBookingForm(params) async {
    final result = await httpManager.get(
      url: bookingForm,
      params: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Price
  static Future<ResultApiModel> requestPrice(params) async {
    final result = await httpManager.post(
      url: calcPrice,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Order
  static Future<ResultApiModel> requestOrder(params) async {
    final result = await httpManager.post(
      url: order,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Booking Detail
  static Future<ResultApiModel> requestBookingDetail(params) async {
    final result = await httpManager.get(url: bookingDetail, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Get Booking List
  static Future<ResultApiModel> requestBookingList(params) async {
    final result = await httpManager.get(url: bookingList, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Booking Cancel
  static Future<ResultApiModel> requestBookingCancel(params) async {
    final result = await httpManager.post(
      url: bookingCancel,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Download file
  static Future<ResultApiModel> requestDownloadFile({
    required FileModel file,
    required progress,
    String? directory,
  }) async {
    directory ??= await UtilFile.getFilePath();
    final filePath = '$directory/${file.name}.${file.type}';
    final result = await httpManager.download(
      url: file.url,
      filePath: filePath,
      progress: progress,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Deactivate account
  static Future<ResultApiModel> requestDeactivate(params) async {
    final result = await httpManager.post(
      url: "$deactivate/${params['deactiveReason']}",
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Block User
  static Future<ResultApiModel> requestBlockUser(params) async {
    final result = await httpManager.post(
      url: "$blockUser/${params['userId']}/${params['because']}",
      // data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///UnBlock User
  static Future<ResultApiModel> requestUnBlockUser(String userId) async {
    final result = await httpManager.post(
      url: "$unblockUser/$userId",
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Send Report
  static Future<ResultApiModel> requestSendReport(
      params, ReportType reportType) async {
    final result = await httpManager.post(
      url: reportType == ReportType.post
          ? sendPostReport
          : reportType == ReportType.profile
              ? sendProfileReport
              : reportType == ReportType.chat
                  ? sendChatReport
                  : sendReviewReport,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Send Message Contact Us
  static Future<ResultApiModel> requestSendContactUs(params) async {
    final result = await httpManager.post(
      url: sendContactUs,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Chat
  static Future<ResultApiModel> requestChat({
    required String contactId,
    required int pageNumber,
    required int pageSize,
    bool loading = false,
  }) async {
    final result = await httpManager.get(
      url: "$chatLoad/$contactId/$pageNumber/$pageSize",
      loading: loading,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Save Message Chat
  static Future<ResultApiModel> requestSaveMessage(params) async {
    final result = await httpManager.post(
      url: saveMessage,
      data: params,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Ping
  static Future requestPing() async {
    await httpManager.get(
      url: ping,
      loading: false,
    );
  }

  ///Ping
  static Future requestConfirmReceiptStatus(statusType) async {
    await httpManager.post(
      url: "$confirmReceiptStatus/$statusType",
      loading: false,
    );
  }

  ///Send Read Status
  static Future<ResultApiModel> requestSendReadStatus(fromUserId) async {
    final result = await httpManager.post(
      url: "$sendReadStatus/$fromUserId",
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Send Delivered Status
  static Future<ResultApiModel> requestSendDeliveredStatus(fromUserId) async {
    final result = await httpManager.post(
      url: "$sendDeliveredStatus/$fromUserId",
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Send Delivered Status
  static Future<ResultApiModel> requestSendDeliveredStatusForUsers(
      List<String> users) async {
    final result = await httpManager.post(
      url: sendDeliveredStatusUsers,
      data: users,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Chat Users
  static Future<ResultApiModel> requestChatUsers({
    required String keyword,
    required int pageNumber,
    required int pageSize,
    bool loading = false,
  }) async {
    final result = await httpManager.get(
      url:
          "$chatUsers/${keyword.isNotEmpty ? keyword : "empty"}/$pageNumber/$pageSize",
      loading: loading,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Blocked Users
  static Future<ResultApiModel> requestBlockedUsers({
    required String keyword,
    required int pageNumber,
    required int pageSize,
    bool loading = false,
  }) async {
    final result = await httpManager.get(
      url:
          "$blockedUsers/${keyword.isNotEmpty ? keyword : "empty"}/$pageNumber/$pageSize",
      loading: loading,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Singleton factory
  static final Api _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Api._internal();
}
