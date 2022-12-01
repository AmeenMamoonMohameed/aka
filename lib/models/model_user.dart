import '../configs/application.dart';
import '../configs/image.dart';

enum UserType { owner, broker, office, company }

class UserModel {
  late final String id;
  late String userName;
  // late String nickName;
  late String accountName;
  late String fullName;
  late String countryCode;
  late String phoneNumber;
  late String profilePictureDataUrl;
  late String url;
  late final int userLevel;
  late String description;
  late final String tag;
  late double ratingAvg;
  late final int totalComment;
  late int total;
  late final String token;
  // late final String refreshToken;
  late String email;
  late UserType userType;
  late bool phoneNumberConfirmed;

  UserModel({
    required this.id,
    required this.userName,
    // required this.nickName,
    required this.accountName,
    required this.fullName,
    required this.countryCode,
    required this.phoneNumber,
    required this.profilePictureDataUrl,
    required this.url,
    required this.userLevel,
    required this.description,
    required this.tag,
    required this.ratingAvg,
    required this.totalComment,
    required this.total,
    required this.token,
    // required this.refreshToken,
    required this.email,
    required this.userType,
    required this.phoneNumberConfirmed,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var userType = UserType.owner;
    if (json['userType'] != null) {
      userType = UserType.values[int.parse(json['userType'].toString())];
    }
    return UserModel(
      id: json['id'] ?? 'Unknown',
      userName: json['userName'] ?? 'Unknown',
      // nickName: json['userName'] ?? 'Unknown',
      accountName: json['accountName'] ?? 'Unknown',
      fullName: json['fullName'] ?? 'Unknown',
      countryCode: json['countryCode'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePictureDataUrl: json['profilePictureDataUrl'] ?? '',
      url: json['url'] ?? 'Unknown',
      userLevel: json['userLevel'] ?? 0,
      description: json['description'] ?? 'description',
      tag: json['tag'] ?? json['Tag'] ?? 'Unknown',
      ratingAvg: double.tryParse('${json['ratingAvg']}') ?? 0.0,
      totalComment: int.tryParse('${json['totalComment']}') ?? 0,
      total: json['total'] ?? 0,
      token: json['token'] ?? "Unknown",
      // refreshToken: json['refreshToken'] ?? "Unknown",
      email: json['email'] ?? 'Unknown',
      userType: userType,
      phoneNumberConfirmed: json['phoneNumberConfirmed'] ?? false,
    );
  }

  UserModel updateUser({
    // String? nickname,
    String? accountName,
    String? fullName,
    String? countryCode,
    String? phoneNumber,
    String? email,
    String? url,
    String? description,
    String? image,
    int? total,
    bool? phoneNumberConfirmed,
    double? ratingAvg,
  }) {
    // this.nickName = userName ?? this.userName;
    this.accountName = accountName ?? this.accountName;
    this.fullName = fullName ?? this.fullName;
    this.countryCode = countryCode ?? this.countryCode;
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
    this.email = email ?? this.email;
    this.url = url ?? this.url;
    this.description = description ?? this.description;
    profilePictureDataUrl = image ?? profilePictureDataUrl;
    this.total = total ?? this.total;
    this.phoneNumberConfirmed =
        phoneNumberConfirmed ?? this.phoneNumberConfirmed;
    this.ratingAvg = ratingAvg ?? this.ratingAvg;
    return clone();
  }

  UserModel.fromSource(source) {
    id = source.id;
    userName = source.userName;
    // nickName = source.nickName;
    accountName = source.accountName;
    fullName = source.fullName;
    countryCode = source.countryCode;
    phoneNumber = source.phoneNumber;
    profilePictureDataUrl = source.profilePictureDataUrl;
    url = source.url;
    userLevel = source.userLevel;
    description = source.description;
    tag = source.tag;
    ratingAvg = source.ratingAvg;
    totalComment = source.totalComment;
    total = source.total;
    token = source.token;
    email = source.email;
    phoneNumberConfirmed = source.phoneNumberConfirmed;
    // refreshToken = source.refreshToken;
  }

  UserModel clone() {
    return UserModel.fromSource(this);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'accountName': accountName,
      'fullName': fullName,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'image': profilePictureDataUrl,
      'url': url,
      'userLevel': userLevel,
      'description': description,
      'tag': tag,
      'ratingAvg': ratingAvg,
      'totalComment': totalComment,
      'total': total,
      'token': token,
      'email': email,
      'phoneNumberConfirmed': phoneNumberConfirmed,
      // 'refreshToken': refreshToken,
    };
  }

  String getProfileImage({String? imageType}) {
    if (profilePictureDataUrl.isNotEmpty) {
      return "${Application.domain}$profilePictureDataUrl"
          .replaceAll("\\", "/")
          .replaceAll("TYPE", imageType ?? "thumb");
    }
    return '';
  }
}
