import 'package:flutter/material.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/screens/screen.dart';

import '../models/model_feature.dart';
import '../models/model_location.dart';

class RouteArguments<T> {
  final T? item;
  final VoidCallback? callback;
  RouteArguments({this.item, this.callback});
}

class Routes {
  static const String home = "/home";
  static const String discovery = "/discovery";
  static const String wishList = "/wishList";
  static const String account = "/account";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String otp = "/confirmPhoneNumber";
  static const String forgotPassword = "/forgotPassword";
  static const String otpForgotPassword = "/otpForgotPassword";
  static const String productDetail = "/productDetail";
  static const String searchHistory = "/searchHistory";
  static const String category = "/category";
  static const String profile = "/profile";
  static const String listProfile = "/listProfile";
  static const String profileQRCode = "/profileQRCode";
  static const String submit = "/submit";
  static const String editProfile = "/editProfile";
  static const String changePassword = "/changePassword";
  static const String changeLanguage = "/changeLanguage";
  static const String contactUs = "/contactUs";
  static const String aboutUs = "/aboutUs";
  static const String gallery = "/gallery";
  static const String themeSetting = "/themeSetting";
  static const String listProduct = "/listProduct";
  static const String filter = "/filter";
  static const String review = "/review";
  static const String writeReview = "/writeReview";
  static const String location = "/location";
  static const String setting = "/setting";
  static const String chatterScreen = "/chatterScreen";
  static const String fontSetting = "/fontSetting";
  static const String picker = "/picker";
  static const String galleryUpload = "/galleryUpload";
  static const String categoryPicker = "/categoryPicker";
  static const String gpsPicker = "/gpsPicker";
  static const String submitSuccess = "/submitSuccess";
  static const String openTime = "/openTime";
  static const String socialNetwork = "/socialNetwork";
  static const String tagsPicker = "/tagsPicker";
  static const String webView = "/webView";
  static const String booking = "/booking";
  static const String bookingList = "/bookingList";
  static const String bookingDetail = "/bookingDetail";
  static const String blockedUsersList = "/blocked_users_list";
  static const String chatList = "/chat_users_list";
  static const String chat = "/chat";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(
          builder: (context) {
            return SignIn(from: settings.arguments as String);
          },
          fullscreenDialog: true,
        );

      case signUp:
        return MaterialPageRoute(
          builder: (context) {
            return const SignUp();
          },
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (context) {
            return const ForgotPassword();
          },
        );

      case otpForgotPassword:
        return MaterialPageRoute(
          builder: (context) {
            return OtpForgotPassword(
              countryCode:
                  (settings.arguments as Map<String, dynamic>)['countryCode'],
              phoneNumber:
                  (settings.arguments as Map<String, dynamic>)['phoneNumber'],
            );
          },
        );

      case otp:
        return MaterialPageRoute(
          builder: (context) {
            return Otp(
              userId: (settings.arguments as Map<String, dynamic>)['userId'],
              routeName:
                  (settings.arguments as Map<String, dynamic>)['routeName'],
            );
          },
        );

      case contactUs:
        return MaterialPageRoute(
          builder: (context) {
            return const ContactUs();
          },
        );

      case productDetail:
        return MaterialPageRoute(
          builder: (context) {
            return ProductDetail(id: settings.arguments as int);
          },
        );

      case searchHistory:
        return MaterialPageRoute(
          builder: (context) {
            return const SearchHistory();
          },
          fullscreenDialog: true,
        );

      case category:
        return MaterialPageRoute(
          builder: (context) {
            if (settings.arguments is int) {
              return Category(
                parentId: settings.arguments as int,
              );
            }
            return const Category();
          },
        );

      case profile:
        return MaterialPageRoute(
          builder: (context) {
            return Profile(user: settings.arguments as UserModel);
          },
        );

      case listProfile:
        return MaterialPageRoute(
          builder: (context) {
            // return const ListProfile();
            return ListProfile(userType: settings.arguments as UserType);
          },
        );

      case profileQRCode:
        return MaterialPageRoute(
          builder: (context) {
            return ProfileQRCode(user: settings.arguments as UserModel);
          },
          fullscreenDialog: true,
        );

      case submit:
        return MaterialPageRoute(
          builder: (context) {
            ProductModel? item;
            if (settings.arguments != null) {
              item = settings.arguments as ProductModel;
            }
            return Submit(item: item);
          },
          fullscreenDialog: true,
        );

      case editProfile:
        return MaterialPageRoute(
          builder: (context) {
            return const EditProfile();
          },
        );

      case changePassword:
        return MaterialPageRoute(
          builder: (context) {
            return ChangePassword(
              token: settings.arguments is Map<String, dynamic>
                  ? (settings.arguments as Map<String, dynamic>)['token']
                  : null,
              countryCode: settings.arguments is Map<String, dynamic>
                  ? (settings.arguments as Map<String, dynamic>)['countryCode']
                  : null,
              phoneNumber: settings.arguments is Map<String, dynamic>
                  ? (settings.arguments as Map<String, dynamic>)['phoneNumber']
                  : null,
            );
          },
        );

      case changeLanguage:
        return MaterialPageRoute(
          builder: (context) {
            return const LanguageSetting();
          },
        );

      case themeSetting:
        return MaterialPageRoute(
          builder: (context) {
            return const ThemeSetting();
          },
        );

      case filter:
        return MaterialPageRoute(
          builder: (context) {
            return Filter(filter: settings.arguments as FilterModel);
          },
          fullscreenDialog: true,
        );

      case review:
        return MaterialPageRoute(
          builder: (context) {
            return Review(product: settings.arguments as ProductModel);
          },
        );

      case blockedUsersList:
        return MaterialPageRoute(
          builder: (context) {
            return const BlockedUsersList();
          },
        );

      case chatList:
        return MaterialPageRoute(
          builder: (context) {
            return const ChatUsersList();
          },
        );

      case chat:
        return MaterialPageRoute(
          builder: (context) {
            if (settings.arguments is UserModel) {
              return ChatScreen2(
                  chatUser: ChatUserModel(
                      id: (settings.arguments as UserModel).id,
                      userName: (settings.arguments as UserModel).userName,
                      profilePictureDataUrl: (settings.arguments as UserModel)
                          .profilePictureDataUrl,
                      accountName:
                          (settings.arguments as UserModel).accountName,
                      fullName: (settings.arguments as UserModel).fullName));
            }
            return ChatScreen2(chatUser: settings.arguments as ChatUserModel);
          },
        );

      case setting:
        return MaterialPageRoute(
          builder: (context) {
            return const Setting();
          },
        );

      case fontSetting:
        return MaterialPageRoute(
          builder: (context) {
            return const FontSetting();
          },
        );

      case writeReview:
        return MaterialPageRoute(
          builder: (context) => WriteReview(
            product: settings.arguments is ProductModel
                ? settings.arguments as ProductModel
                : ((settings.arguments as List<Object>)[0] as ProductModel),
            review: settings.arguments is ProductModel
                ? null
                : ((settings.arguments as List<Object>)[1] as CommentModel),
            type: settings.arguments is ProductModel
                ? ''
                : ((settings.arguments as List<Object>)[2] as String),
          ),
        );

      case location:
        return MaterialPageRoute(
          builder: (context) => Location(
            location: settings.arguments as CoordinateModel,
          ),
        );

      case listProduct:
        return MaterialPageRoute(
          builder: (context) {
            if (settings.arguments is LocationModel) {
              return ListProduct(location: settings.arguments as LocationModel);
            } else if (settings.arguments is FeatureModel) {
              return ListProduct(feature: settings.arguments as FeatureModel);
            } else {
              return ListProduct(category: settings.arguments as CategoryModel);
            }
          },
        );

      case gallery:
        return MaterialPageRoute(
          builder: (context) {
            return Gallery(product: settings.arguments as ProductModel);
          },
          fullscreenDialog: true,
        );

      case galleryUpload:
        return MaterialPageRoute(
          builder: (context) {
            return GalleryUpload(
              images: settings.arguments as List<String>,
            );
          },
          fullscreenDialog: true,
        );

      case categoryPicker:
        return MaterialPageRoute(
          builder: (context) {
            return CategoryPicker(
              picker: settings.arguments as PickerModel,
            );
          },
          fullscreenDialog: true,
        );

      case gpsPicker:
        return MaterialPageRoute(
          builder: (context) {
            CoordinateModel? item;
            if (settings.arguments != null) {
              item = settings.arguments as CoordinateModel;
            }
            return GPSPicker(
              picked: item,
            );
          },
          fullscreenDialog: true,
        );

      case picker:
        return MaterialPageRoute(
          builder: (context) {
            return Picker(
              picker: settings.arguments as PickerModel,
            );
          },
          fullscreenDialog: true,
        );

      case openTime:
        return MaterialPageRoute(
          builder: (context) {
            List<OpenTimeModel>? arguments;
            if (settings.arguments != null) {
              arguments = settings.arguments as List<OpenTimeModel>;
            }
            return OpenTime(
              selected: arguments,
            );
          },
          fullscreenDialog: true,
        );
      case socialNetwork:
        return MaterialPageRoute(
          builder: (context) {
            return SocialNetwork(
              socials: settings.arguments as Map<String, dynamic>?,
            );
          },
          fullscreenDialog: true,
        );

      case submitSuccess:
        return MaterialPageRoute(
          builder: (context) {
            return const SubmitSuccess();
          },
          fullscreenDialog: true,
        );

      case tagsPicker:
        return MaterialPageRoute(
          builder: (context) {
            return TagsPicker(
              selected: settings.arguments as List<String>,
            );
          },
          fullscreenDialog: true,
        );

      case webView:
        return MaterialPageRoute(
          builder: (context) {
            return Web(
              web: settings.arguments as WebViewModel,
            );
          },
          fullscreenDialog: true,
        );

      case booking:
        return MaterialPageRoute(
          builder: (context) {
            return Booking(
              id: settings.arguments as int,
            );
          },
        );
      case bookingList:
        return MaterialPageRoute(
          builder: (context) {
            return const BookingList();
          },
        );

      case bookingDetail:
        return MaterialPageRoute(
          builder: (context) {
            return BookingDetail(
              arguments: settings.arguments as RouteArguments,
            );
          },
        );

      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Not Found"),
              ),
              body: Center(
                child: Text('No path for ${settings.name}'),
              ),
            );
          },
        );
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
