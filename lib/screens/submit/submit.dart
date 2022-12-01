import 'dart:convert';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/configs/config.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/repository/repository.dart';
import 'package:akarak/utils/utils.dart';
import 'package:akarak/widgets/widget.dart';
import "package:flutter/services.dart";
import 'package:flutter/widgets.dart';

import '../../models/model_feature.dart';
import '../../repository/location_repository.dart';

class Submit extends StatefulWidget {
  final ProductModel? item;
  const Submit({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  _SubmitState createState() {
    return _SubmitState();
  }
}

class _SubmitState extends State<Submit> {
  final regInt = RegExp('[^0-9]');

  final _textTitleController = TextEditingController();
  final _textContentController = TextEditingController();
  // final _textTagsController = TextEditingController();
  final _textYoutubeVideoController = TextEditingController();
  final _textAddressController = TextEditingController();
  final _textWhatsappController = TextEditingController();
  final _textPhoneController = TextEditingController();
  final _textPriceController = TextEditingController();
  final _textAreaController = TextEditingController();
  final _textMainAreaController = TextEditingController();
  final _textMainPriceController = TextEditingController();

  final _focusTitle = FocusNode();
  final _focusContent = FocusNode();
  final _focusYoutubeVideo = FocusNode();
  final _focusAddress = FocusNode();
  final _focusWhatsapp = FocusNode();
  final _focusPhone = FocusNode();
  final _focusPrice = FocusNode();
  final _focusArea = FocusNode();

  bool _processing = false;

  String? _errorCurrency;
  String? _errorUnit;
  String? _errorTitle;
  String? _errorContent;
  String? _errorState;
  String? _errorCity;
  String? _errorCategory;
  String? _errorPaymentMethod;
  String? _errorGps;
  String? _errorYoutubeVideo;
  String? _errorAddress;
  String? _errorWhatsapp;
  String? _errorPhone;
  String? _errorStatus;
  String? _errorPrice;
  String? _errorArea;

  /// Data
  List<PropertyWidgett> _listPropertyWidgets = [];
  List<CategoryModel> _listCategories = [];
  List<FeatureModel> _listFeatures = [];
  List<LocationModel>? _listState;
  List<LocationModel>? _listCity;
  bool _loadingState = false;
  bool _loadingCity = false;

  ///Data Params
  SectionType _section = SectionType.sale;
  PaymentMethodType? _paymentMethod;
  String? _image;
  CategoryModel? _category;
  List<FeatureModel> _features = [];
  // List<String> _tags = [];
  LocationModel? _state;
  LocationModel? _city;
  CurrencyModel? _currency = Application.submitSetting.currencies.isNotEmpty
      ? Application.submitSetting.currencies
          .singleWhere((item) => item.isDefault)
      : null;
  UnitModel? _unit = Application.submitSetting.units.isNotEmpty
      ? Application.submitSetting.units.singleWhere((item) => item.isDefault)
      : null;
  CoordinateModel? _gps;
  List<ExtendedAttributeModel> _extendedAttributes = [];

  // Color? _color;
  // IconModel? _icon;
  String? _date;
  // List<OpenTimeModel>? _time;
  Map<String, dynamic> _socials = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _onProcess();
  }

  @override
  void dispose() {
    _textTitleController.dispose();
    _textContentController.dispose();
    // _textTagsController.dispose();
    _textYoutubeVideoController.dispose();
    _textAddressController.dispose();
    _textWhatsappController.dispose();
    _textPhoneController.dispose();
    _textPriceController.dispose();
    _textAreaController.dispose();
    _textMainAreaController.dispose();
    _textMainPriceController.dispose();
    _focusTitle.dispose();
    _focusContent.dispose();
    _focusYoutubeVideo.dispose();
    _focusAddress.dispose();
    _focusWhatsapp.dispose();
    _focusPhone.dispose();
    _focusPrice.dispose();
    _focusArea.dispose();
    super.dispose();
  }

  ///On show message fail
  void _showMessage(String title, String message, VoidCallback? func,
      String? funcName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            if (func != null)
              AppButton(
                funcName!,
                onPressed: func,
                type: ButtonType.text,
              ),
            AppButton(
              Translate.of(context).translate('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              type: ButtonType.text,
            ),
          ],
        );
      },
    );
  }

  ///On Load Edit Product
  void _onProcess() async {
    setState(() {
      _processing = true;
    });
    Map<String, dynamic> params = {};
    if (widget.item != null) {
      params['id'] = widget.item!.id;
    }
    _listCategories = Application.submitSetting.categories;
    _listFeatures = Application.submitSetting.features;

    if (widget.item != null) {
      final result = await ListRepository.loadProduct(widget.item!.id);
      if (result != null) {
        _image = result.image;
        // _gallery = result.gallery;
        _textTitleController.text = result.title;
        _textContentController.text = result.content;
        _category = result.category;
        _section = result.section;
        _paymentMethod = result.paymentMethod;
        _features = result.features;
        // _tags = result.tags;
        _state = result.state;
        _city = result.city;
        _currency = result.currency;
        _unit = result.unit;
        _gps = result.coordinate;
        _extendedAttributes = result.extendedAttributes;
        _date = result.date;
        _category?.groups?.forEach((group) {
          group.properties
              ?.where(
                  (property) => property.propertyType == PropertyType.entity)
              .where((e) => e.section == _section)
              .forEach((property) {
            _onSetProperty(property);
            // if (!result.extendedAttributes
            //     .any((ex) => ex.key == property.key)) {
            //   _onSetProperty(property);
            // }
            // _listPropertyWidgets.add(PropertyWidgett(
            //     property: property,
            //     extendedAttribute: result.extendedAttributes
            //         .singleWhere((ex) => ex.key == property.key)));
          });
        });

        _textPriceController.text = result.price.replaceAll(regInt, '');
        _textAreaController.text = result.area.replaceAll(regInt, '');

        _extendedAttributes
            .where((item) => item.group == "social")
            .forEach((item) {
          if (_extendedAttributes.any((e) => e.key == item.key)) {
            _socials[item.key] =
                _extendedAttributes.firstWhere((e) => e.key == item.key).text ??
                    '';
          }
        });
        if (_extendedAttributes.any((e) => e.key == "youtubeVideo")) {
          _textYoutubeVideoController.text = _extendedAttributes
                  .firstWhere((e) => e.key == "youtubeVideo")
                  .text ??
              '';
        }
        if (_extendedAttributes.any((e) => e.key == "address")) {
          _textAddressController.text =
              _extendedAttributes.firstWhere((e) => e.key == "address").text ??
                  '';
        }
        if (_extendedAttributes.any((e) => e.key == "whatsapp")) {
          _textWhatsappController.text =
              _extendedAttributes.firstWhere((e) => e.key == "whatsapp").text ??
                  '';
        }

        if (_extendedAttributes.any((e) => e.key == "phone")) {
          _textPhoneController.text =
              _extendedAttributes.firstWhere((e) => e.key == "phone").text ??
                  '';
        }

        // _time = result.openHours;
        _listState = await LocationRepository.loadLocationById(
            Application.currentCountry!.id);
        _listCity = await LocationRepository.loadLocationById(_state!.id);
      }
    }
    setState(() {
      _processing = false;
    });
  }

  ///On Upload Gallery
  void _onUploadGallery() async {
    final result = await Navigator.pushNamed(
      context,
      Routes.galleryUpload,
      arguments:
          _extendedAttributes.where((e) => e.key == "gallery").map((item) {
        return item.text!;
      }).toList(),
    );

    if (result != null && result is List<String>) {
      setState(() {
        _extendedAttributes.removeWhere((e) => e.key == "gallery");
        for (var e in result) {
          _extendedAttributes.add(ExtendedAttributeModel(
              key: "gallery", text: e, group: "gallery"));
        }
      });
    }
  }

  ///On Select Category
  void _onSetProprties() {
    setState(() {
      // _extendedAttributes.removeWhere((e) => e.group == "property");
      _listPropertyWidgets = [];
      if (_category != null) {
        _category?.groups?.forEach((group) {
          group.properties
              ?.where(
                  (property) => property.propertyType == PropertyType.entity)
              .where((e) => e.section == _section)
              .forEach((property) {
            _onSetProperty(property);
            // _listPropertyWidgets.add(PropertyWidgett(
            //     property: property,
            //     extendedAttribute: _extendedAttributes.last));
          });
        });
        setState(() {});
      }
    });
  }

  void _onSetProperty(PropertyModel property) {
    if (!_extendedAttributes.any((element) => element.key == property.key)) {
      if (property.valueType == ValueType.decimal) {
        _extendedAttributes.add(ExtendedAttributeModel(
            key: property.key,
            type: ExtendedAttributeType.decimal,
            group: "property",
            propertyId: property.id));
      } else if (property.valueType == ValueType.int) {
        _extendedAttributes.add(ExtendedAttributeModel(
            key: property.key,
            type: ExtendedAttributeType.int,
            group: "property",
            propertyId: property.id));
      } else if (property.valueType == ValueType.double) {
        _extendedAttributes.add(ExtendedAttributeModel(
            key: property.key,
            type: ExtendedAttributeType.double,
            group: "property",
            propertyId: property.id));
      } else if (property.valueType == ValueType.dateTime) {
        _extendedAttributes.add(ExtendedAttributeModel(
            key: property.key,
            type: ExtendedAttributeType.dateTime,
            group: "property",
            propertyId: property.id));
      } else if (property.valueType == ValueType.text) {
        _extendedAttributes.add(ExtendedAttributeModel(
            key: property.key,
            type: ExtendedAttributeType.text,
            group: "property",
            propertyId: property.id));
      }
    }
    _listPropertyWidgets.add(PropertyWidgett(
        property: property,
        extendedAttribute: _extendedAttributes
            .singleWhere((element) => element.key == property.key)
            .copyWith(propertyId: property.id)));
  }

  ///On Select Category
  void _onSelectCategory() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final selected = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: PickerModel(
        title: Translate.of(context).translate('choose_category'),
        selected: [_category],
        data: _listCategories,
      ),
    );
    if (selected != null && selected is CategoryModel) {
      setState(() {
        _category = selected;
        _errorCategory = null;
      });
      _onSetProprties();
    } else {
      setState(() {
        _errorCategory =
            "${Translate.of(context).translate('category')} ${Translate.of(context).translate('must_be_selected')}";
      });
    }
  }

  ///Select Payment Method
  Future<void> _onSelectPaymentMethod() async {
    List<String> data = [Translate.of(context).translate('cash')];
    String? selected = _paymentMethod == PaymentMethodType.cash
        ? Translate.of(context).translate('cash')
        : _paymentMethod == PaymentMethodType.installment
            ? Translate.of(context).translate('installment')
            : _paymentMethod == PaymentMethodType.cashAndInstallment
                ? Translate.of(context).translate('cash_and_installment')
                : null;
    if (_section == SectionType.sale) {
      data.addAll([
        Translate.of(context).translate('installment'),
        Translate.of(context).translate('cash_and_installment')
      ]);
      selected = _paymentMethod == PaymentMethodType.cashAndInstallment
          ? Translate.of(context).translate('cash_and_installment')
          : _paymentMethod == PaymentMethodType.installment
              ? Translate.of(context).translate('installment')
              : null;
    }
    final result = await showModalBottomSheet<String?>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => SafeArea(
                child: AppBottomPicker(
              picker: PickerModel(
                selected: [selected],
                data: data,
              ),
            )));
    if (result != null) {
      setState(() {
        _paymentMethod =
            result == Translate.of(context).translate('cash_and_installment')
                ? PaymentMethodType.cashAndInstallment
                : result == Translate.of(context).translate('installment')
                    ? PaymentMethodType.installment
                    : PaymentMethodType.cash;
      });
    }
  }

  ///Select Section
  Future<void> _onSelectSection() async {
    final result = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => AppBottomPicker(
        picker: PickerModel(
          selected: [
            _section == SectionType.rent
                ? Translate.of(context).translate('rent')
                : Translate.of(context).translate('sale')
          ],
          data: [
            Translate.of(context).translate('sale'),
            Translate.of(context).translate('rent'),
          ],
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _section = result == Translate.of(context).translate('rent')
            ? SectionType.rent
            : SectionType.sale;
        _paymentMethod = null;
      });
      _onSetProprties();
    }
  }

  ///On Select Features
  void _onSelectFeatures() async {
    final result = await Navigator.pushNamed(
      context,
      Routes.categoryPicker,
      arguments: PickerModel(
        title: Translate.of(context).translate('choose_features'),
        selected: _features,
        data: _listFeatures,
      ),
    );
    if (result != null && result is List<FeatureModel>) {
      setState(() {
        _features = result;
      });
    }
  }

  // ///On Input Tag
  // void _onChooseTag() async {
  //   final result = await Navigator.pushNamed(
  //     context,
  //     Routes.tagsPicker,
  //     arguments: _tags,
  //   );
  //   if (result != null && result is List<String>) {
  //     setState(() {
  //       _tags = result;
  //     });
  //   }
  // }

  ///On Select state
  void _onSelectState() async {
    _loadingState = true;
    setState(() {});

    _listState = await LocationRepository.loadLocationById(
        Application.currentCountry!.id);
    _loadingState = false;
    setState(() {});

    // ignore: use_build_context_synchronously
    final selected = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: PickerModel(
        title: Translate.of(context).translate('choose_state'),
        selected: [_state],
        data: _listState ?? [],
      ),
    );
    if (selected != null && selected is LocationModel) {
      setState(() {
        _state = selected;
        _listCity = null;
        _city = null;
      });
      setState(() {});
    }
  }

  ///On Select city
  void _onSelectCity() async {
    if (_state == null) {
      AppBloc.messageCubit.onShow('choose_state');
      return;
    }
    _loadingCity = true;
    setState(() {});

    _listCity = await LocationRepository.loadLocationById(_state!.id);
    _loadingCity = false;
    setState(() {});

    // ignore: use_build_context_synchronously
    final selected = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: PickerModel(
        title: Translate.of(context).translate('choose_city'),
        selected: [_city],
        data: _listCity ?? [],
      ),
    );
    if (selected != null && selected is LocationModel) {
      setState(() {
        _city = selected;
      });
    }
  }

  ///On Select currency
  void _onSelectCurrency() async {
    final selected = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: PickerModel(
        title: Translate.of(context).translate('choose_currency'),
        selected: [_currency],
        data: Application.submitSetting.currencies,
      ),
    );
    if (selected != null && selected is CurrencyModel) {
      setState(() {
        _currency = selected;
        _textMainPriceController.text =
            double.tryParse(_textPriceController.text) != null
                ? (double.parse(_textPriceController.text) *
                        (_currency?.exchange ?? 1))
                    .toString()
                : "";
      });
    }
  }

  ///On Select unit
  void _onSelectUnit() async {
    final selected = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: PickerModel(
        title: Translate.of(context).translate('choose_unit'),
        selected: [_unit],
        data: Application.submitSetting.units,
      ),
    );
    if (selected != null && selected is UnitModel) {
      setState(() {
        _unit = selected;
        _textMainAreaController.text =
            double.tryParse(_textAreaController.text) != null
                ? (double.parse(_textAreaController.text) *
                        (_unit?.exchange ?? 1))
                    .toString()
                : "";
      });
    }
  }

  ///On Select Address
  void _onSelectAddress() async {
    final selected = await Navigator.pushNamed(
      context,
      Routes.gpsPicker,
      arguments: _gps,
    );
    if (selected != null && selected is CoordinateModel) {
      setState(() {
        _gps = selected;
      });
    }
  }

  ///Show Picker Time
  void _onShowDatePicker() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      initialDate: now,
      firstDate: DateTime(now.year),
      context: context,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _date = picked.dateView;
      });
    }
  }

  // ///On Select Open Time
  // void _onOpenTime() async {
  //   final result = await Navigator.pushNamed(
  //     context,
  //     Routes.openTime,
  //     arguments: _time,
  //   );
  //   if (result != null && result is List<OpenTimeModel>) {
  //     setState(() {
  //       _time = result;
  //     });
  //   }
  // }

  ///Select social network
  void _onSocialNetwork() async {
    final result = await Navigator.pushNamed(
      context,
      Routes.socialNetwork,
      arguments: _socials,
    );
    if (result != null && result is Map<String, dynamic>) {
      _socials = result;
      _extendedAttributes.removeWhere((item) => item.group == "social");
      _socials.forEach((key, value) {
        _extendedAttributes.add(ExtendedAttributeModel(
            key: key,
            type: ExtendedAttributeType.text,
            text: value,
            group: "social"));
      });
    }
  }

  ///On Submit
  void _onSubmit() async {
    if (!AppBloc.userCubit.state!.phoneNumberConfirmed) {
      _showMessage(
        Translate.of(context).translate('confirm_phone_number'),
        Translate.of(context)
            .translate('the_phone_number_must_be_confirmed_first'),
        () {
          Navigator.of(context).pop();
          Navigator.pushNamed(
            context,
            Routes.otp,
            arguments: {
              "userId": AppBloc.userCubit.state!.id,
              "routeName": null
            },
          );
        },
        Translate.of(context).translate('confirm'),
      );
      return;
    }

    final success = _validData();
    if (success) {
      _extendedAttributes.removeWhere((ex) => ex.group == "property");
      for (var p in _listPropertyWidgets) {
        _extendedAttributes.add(p.extendedAttribute!);
      }

      final result = await AppBloc.submitCubit.onSubmit(
        id: widget.item?.id,
        title: _textTitleController.text,
        section: _section,
        content: _textContentController.text,
        country: Application.currentCountry,
        state: _state,
        city: _city,
        date: _date,
        image: _image ?? '',
        currency: _currency!,
        price: _textPriceController.text,
        unit: _unit!,
        area: _textAreaController.text,
        gps: _gps,
        // tags: _tags,
        category: _category!,
        paymentMethod: _paymentMethod!,
        features: _features,
        extendedAttributes: _extendedAttributes,
        // time: _time,
      );
      if (result) {
        _onSuccess();
      }
    }
  }

  ///On Success
  void _onSuccess() {
    Navigator.pushReplacementNamed(context, Routes.submitSuccess);
  }

  ///valid data
  bool _validData() {
    ///Title
    _errorTitle = UtilValidator.validate(
      _textTitleController.text,
    );

    ///Content
    _errorContent = UtilValidator.validate(
      _textContentController.text,
    );

    ///State
    _errorState = _state == null
        ? "${Translate.of(context).translate('state')} ${Translate.of(context).translate('must_be_selected')}"
        : null;

    ///City
    _errorCity = _city == null
        ? "${Translate.of(context).translate('city')} ${Translate.of(context).translate('must_be_selected')}"
        : null;

    ///Currency
    _errorCurrency = _currency == null
        ? "${Translate.of(context).translate('currency')} ${Translate.of(context).translate('must_be_selected')}"
        : null;

    ///Unit
    _errorUnit = _unit == null
        ? "${Translate.of(context).translate('Unit')} ${Translate.of(context).translate('must_be_selected')}"
        : null;

    ///Category
    if (_category == null) {
      _errorCategory = _category == null
          ? "${Translate.of(context).translate('category')} ${Translate.of(context).translate('must_be_selected')}"
          : null;
    }

    for (var property in _listPropertyWidgets) {
      property._validData();
    }

    ///Payment Method
    _errorPaymentMethod = _paymentMethod == null
        ? "${Translate.of(context).translate('payment_method')} ${Translate.of(context).translate('must_be_selected')}"
        : null;

    ///Gps
    _errorGps = _gps == null
        ? "${Translate.of(context).translate('location_coordinates')} ${Translate.of(context).translate('must_be_selected')}"
        : null;

    ///Youtube Video
    _errorYoutubeVideo = UtilValidator.validate(
      _textYoutubeVideoController.text,
      type: ValidateType.url,
      allowEmpty: true,
    );

    ///Address
    _errorAddress = UtilValidator.validate(
      _textAddressController.text,
    );

    ///Whatsapp
    _errorWhatsapp = UtilValidator.validate(
      _textWhatsappController.text,
      type: ValidateType.number,
      allowEmpty: true,
    );

    ///Phone
    _errorPhone = UtilValidator.validate(
      _textPhoneController.text,
      type: ValidateType.phone,
      allowEmpty: true,
    );

    ///Price
    _errorPrice = UtilValidator.validate(
      _textPriceController.text,
      type: ValidateType.number,
      allowEmpty: false,
    );

    ///Area
    _errorArea = UtilValidator.validate(
      _textAreaController.text,
      type: ValidateType.number,
      allowEmpty: false,
    );

    if (_errorTitle != null ||
        _errorContent != null ||
        _errorState != null ||
        _errorCity != null ||
        _errorCurrency != null ||
        _errorUnit != null ||
        _errorCategory != null ||
        _errorPaymentMethod != null ||
        _errorGps != null ||
        _errorYoutubeVideo != null ||
        _errorAddress != null ||
        _errorPhone != null ||
        _errorStatus != null ||
        _errorPrice != null ||
        _errorArea != null ||
        _listPropertyWidgets
                .any((e) => e.errorWedgit != null && e.errorWedgit != "") ==
            true) {
      setState(() {});
      return false;
    }

    ///Feature image
    if (_image == null) {
      AppBloc.messageCubit.onShow('feature_image_require');
      return false;
    }

    return true;
  }

  ///Build gallery
  Widget _buildGallery() {
    DecorationImage? decorationImage;
    IconData icon = Icons.add;
    if (_extendedAttributes.any((e) => e.key == "gallery")) {
      icon = Icons.dashboard_customize_outlined;
      decorationImage = DecorationImage(
        image: NetworkImage(
          Application.domain +
              _extendedAttributes
                  .where((e) => e.key == "gallery")
                  .first
                  .text!
                  .replaceAll("\\", "/")
                  .replaceAll("TYPE", "full"),
        ),
        fit: BoxFit.cover,
      );
    }
    return InkWell(
      onTap: _onUploadGallery,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        color: Theme.of(context).primaryColor,
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: decorationImage,
          ),
          alignment: Alignment.center,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  ///Build content
  Widget _buildContent() {
    String textActionOpenTime = Translate.of(context).translate('add');
    // Widget icon = Icon(
    //   Icons.help_outline,
    //   color: Theme.of(context).hintColor,
    // );
    // if (_time != null) {
    //   textActionOpenTime = Translate.of(context).translate('edit');
    // }
    if (_processing) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              child: AppUploadImage(
                title: Translate.of(context).translate('upload_feature_image'),
                type: UploadType.post,
                isTemp: true,
                image: _image,
                onChange: (result) {
                  setState(() {
                    _image = result;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildGallery(),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('title'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppTextInput(
              hintText: Translate.of(context).translate('input_title'),
              errorText: _errorTitle,
              controller: _textTitleController,
              focusNode: _focusTitle,
              textInputAction: TextInputAction.next,
              onChanged: (text) {
                setState(() {
                  _errorTitle = UtilValidator.validate(
                    _textTitleController.text,
                  );
                });
              },
              onSubmitted: (text) {
                UtilOther.fieldFocusChange(
                  context,
                  _focusTitle,
                  _focusContent,
                );
              },
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textTitleController.clear();
                },
                child: const Icon(Icons.clear),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('location'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppPickerItem(
                    title: _errorState ??
                        Translate.of(context).translate('choose_state'),
                    value: _state?.title,
                    loading: _loadingState,
                    color: _errorState != null
                        ? Theme.of(context).errorColor
                        : null,
                    onPressed: _onSelectState,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppPickerItem(
                    title: _errorCity ??
                        Translate.of(context).translate('choose_city'),
                    value: _city?.title,
                    loading: _loadingCity,
                    color: _errorCity != null
                        ? Theme.of(context).errorColor
                        : null,
                    withTooltip: true,
                    onPressed: _onSelectCity,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('section'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppPickerItem(
              title: Translate.of(context).translate('choose_section'),
              value: _section == SectionType.rent
                  ? Translate.of(context).translate('rent')
                  : Translate.of(context).translate('sale'),
              onPressed: () async {
                await _onSelectSection();
              },
            ),
            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('category'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppPickerItem(
              title: _errorCategory ??
                  Translate.of(context).translate('choose_category'),
              value: _category?.title,
              color:
                  _errorCategory != null ? Theme.of(context).errorColor : null,
              onPressed: _onSelectCategory,
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translate.of(context).translate('payment_method'),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    AppPickerItem(
                      // leading: _icon?.icon ?? icon,
                      title: _errorPaymentMethod ??
                          Translate.of(context)
                              .translate('choose_payment_method'),
                      value: _paymentMethod ==
                              PaymentMethodType.cashAndInstallment
                          ? Translate.of(context)
                              .translate('cash_and_installment')
                          : _paymentMethod == PaymentMethodType.installment
                              ? Translate.of(context).translate('installment')
                              : _paymentMethod == PaymentMethodType.cash
                                  ? Translate.of(context).translate('cash')
                                  : null,
                      color: _errorPaymentMethod != null
                          ? Theme.of(context).errorColor
                          : null,
                      onPressed: () async {
                        await _onSelectPaymentMethod();
                      },
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('area'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppTextInput(
                    hintText: Translate.of(context).translate(
                      'input_area',
                    ),
                    errorText: _errorArea,
                    controller: _textAreaController,
                    focusNode: _focusArea,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (text) {
                      setState(() {
                        _textMainAreaController.text =
                            double.tryParse(_textAreaController.text) != null
                                ? (double.parse(_textAreaController.text) *
                                        (_unit?.exchange ?? 1))
                                    .toString()
                                : "";
                        _errorArea = UtilValidator.validate(
                          _textAreaController.text,
                          type: ValidateType.number,
                          max: Application.setting.maxArea,
                          min: Application.setting.minArea,
                          allowEmpty: false,
                        );
                      });
                    },
                    onSubmitted: (text) {},
                    leading: Icon(
                      Icons.area_chart,
                      color: Theme.of(context).hintColor,
                    ),
                    // trailing: TextButton(
                    //   onPressed: _onSelectUnit,
                    //   child: Text(_unit!.code),
                    // ),
                    trailing: GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: () {
                        _textAreaController.clear();
                        setState(() {});
                      },
                      child: const Icon(Icons.clear),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppPickerItem(
                    title: _errorUnit ??
                        Translate.of(context).translate('choose_unit'),
                    value: _unit?.code,
                    color: _errorUnit != null
                        ? Theme.of(context).errorColor
                        : null,
                    withTooltip: true,
                    onPressed: _onSelectUnit,
                  ),
                ),
              ],
            ),
            if (_textAreaController.text.isNotEmpty &&
                _unit?.isDefault == false) ...[
              const SizedBox(height: 4),
              AppTextInput(
                hintText: Translate.of(context).translate(
                  'area_in_default_unit',
                ),
                controller: _textMainAreaController,
                // focusNode: _focusMainArea,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (text) {
                  // setState(() {
                  // });
                },
                onSubmitted: (text) {},
                leading: Icon(
                  Icons.area_chart,
                  color: Theme.of(context).hintColor,
                ),
                readOnly: true,
              ),
            ],
            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('price'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppTextInput(
                    hintText: Translate.of(context).translate(
                      'input_price',
                    ),
                    errorText: _errorPrice,
                    controller: _textPriceController,
                    focusNode: _focusPrice,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (text) {
                      setState(() {
                        _textMainPriceController.text =
                            double.tryParse(_textPriceController.text) != null
                                ? (double.parse(_textPriceController.text) *
                                        (_currency?.exchange ?? 1))
                                    .toString()
                                : "";
                        _errorPrice = UtilValidator.validate(
                          _textPriceController.text,
                          type: ValidateType.number,
                          max: Application.setting.maxPrice,
                          min: Application.setting.minPrice,
                          allowEmpty: false,
                        );
                      });
                    },
                    onSubmitted: (text) {},
                    leading: Icon(
                      Icons.price_change_outlined,
                      color: Theme.of(context).hintColor,
                    ),
                    // trailing: TextButton(
                    //   onPressed: _onSelectCurrency,
                    //   child: Text(_currency!.code),
                    // ),
                    trailing: GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: () {
                        _textPriceController.clear();
                        setState(() {});
                      },
                      child: const Icon(Icons.clear),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppPickerItem(
                    title: _errorCurrency ??
                        Translate.of(context).translate('choose_currency'),
                    value: _currency?.code,
                    color: _errorCurrency != null
                        ? Theme.of(context).errorColor
                        : null,
                    withTooltip: true,
                    onPressed: _onSelectCurrency,
                  ),
                ),
              ],
            ),
            if (_textPriceController.text.isNotEmpty &&
                _currency?.isDefault == false) ...[
              const SizedBox(height: 4),
              AppTextInput(
                hintText: Translate.of(context).translate(
                  'price_in_default_currency',
                ),
                controller: _textMainPriceController,
                // focusNode: _focusMainPrice,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (text) {
                  // setState(() {
                  // });
                },
                onSubmitted: (text) {
                  // UtilOther.fieldFocusChange(
                  //   context,
                  //   _focusPrice,
                  //   _focusPriceMax,
                  // );
                },
                leading: Icon(
                  Icons.price_change_outlined,
                  color: Theme.of(context).hintColor,
                ),
                readOnly: true,
              ),
            ],

            const SizedBox(height: 8),

            if (_category != null) Column(children: _listPropertyWidgets),

            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate('features'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppPickerItem(
              leading: Icon(
                Icons.featured_play_list_outlined,
                color: Theme.of(context).hintColor,
              ),
              title: Translate.of(context).translate('choose_features'),
              value: _features.map((e) => e.title).join(", "),
              onPressed: _onSelectFeatures,
            ),
            const SizedBox(height: 8),
            AppTextInput(
              hintText:
                  Translate.of(context).translate('input_youtube_video_url'),
              errorText: _errorYoutubeVideo,
              controller: _textYoutubeVideoController,
              focusNode: _focusYoutubeVideo,
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                setState(() {
                  _errorYoutubeVideo = UtilValidator.validate(
                      _textYoutubeVideoController.text,
                      type: ValidateType.url,
                      allowEmpty: true);
                  if (!_extendedAttributes
                      .any((item) => item.key == "youtube_video_url")) {
                    _extendedAttributes.add(ExtendedAttributeModel(
                        key: "youtubeVideo",
                        type: ExtendedAttributeType.text,
                        text: _textYoutubeVideoController.text,
                        group: "video"));
                  }
                  _extendedAttributes
                      .singleWhere((item) => item.key == "youtubeVideo")
                      .text = _textYoutubeVideoController.text;
                });
              },
              // onSubmitted: (text) {
              //   UtilOther.fieldFocusChange(
              //     context,
              //     _focusYoutubeVideo,
              //     _focusAddress,
              //   );
              // },
              leading: Icon(
                Icons.video_camera_back_outlined,
                color: Theme.of(context).hintColor,
              ),
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textYoutubeVideoController.clear();
                },
                child: const Icon(Icons.clear),
              ),
            ),
            // const SizedBox(height: 16),
            // Text(
            //   Translate.of(context).translate('tags'),
            //   style: Theme.of(context)
            //       .textTheme
            //       .subtitle1!
            //       .copyWith(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8),
            // AppPickerItem(
            //   title: Translate.of(context).translate('choose_tags'),
            //   value: _tags.isEmpty ? null : _tags.join(","),
            //   onPressed: _onChooseTag,
            // ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            AppPickerItem(
              leading: Icon(
                Icons.location_on_outlined,
                color: Theme.of(context).hintColor,
              ),
              title: _errorGps ??
                  Translate.of(context).translate(
                    'choose_gps_location',
                  ),
              value: _gps != null
                  ? '${_gps!.latitude.toStringAsFixed(3)},${_gps!.latitude.toStringAsFixed(3)}'
                  : null,
              color: _errorGps != null ? Theme.of(context).errorColor : null,
              onPressed: _onSelectAddress,
            ),

            const SizedBox(height: 8),
            AppTextInput(
              hintText: Translate.of(context).translate('input_address'),
              errorText: _errorAddress,
              controller: _textAddressController,
              focusNode: _focusAddress,
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                setState(() {
                  _errorAddress = UtilValidator.validate(
                    _textAddressController.text,
                  );
                  if (!_extendedAttributes
                      .any((item) => item.key == "address")) {
                    _extendedAttributes.add(ExtendedAttributeModel(
                        key: "address",
                        type: ExtendedAttributeType.text,
                        text: _textAddressController.text,
                        group: "concat"));
                  }
                  _extendedAttributes
                      .singleWhere((item) => item.key == "address")
                      .text = _textAddressController.text;
                });
              },
              onSubmitted: (text) {
                UtilOther.fieldFocusChange(
                  context,
                  _focusAddress,
                  _focusWhatsapp,
                );
              },
              leading: Icon(
                Icons.home_outlined,
                color: Theme.of(context).hintColor,
              ),
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textAddressController.clear();
                },
                child: const Icon(Icons.clear),
              ),
            ),
            const SizedBox(height: 8),
            AppTextInput(
              hintText: Translate.of(context).translate('input_whatsapp'),
              errorText: _errorWhatsapp,
              controller: _textWhatsappController,
              focusNode: _focusWhatsapp,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                setState(() {
                  _errorWhatsapp = UtilValidator.validate(
                    _textWhatsappController.text,
                    type: ValidateType.number,
                    allowEmpty: true,
                  );
                  if (!_extendedAttributes
                      .any((item) => item.key == "whatsapp")) {
                    _extendedAttributes.add(ExtendedAttributeModel(
                        key: "whatsapp",
                        type: ExtendedAttributeType.text,
                        text: _textWhatsappController.text,
                        group: "concat"));
                  }
                  _extendedAttributes
                      .singleWhere((item) => item.key == "whatsapp")
                      .text = _textWhatsappController.text;
                });
              },
              onSubmitted: (text) {
                UtilOther.fieldFocusChange(
                  context,
                  _focusWhatsapp,
                  _focusPhone,
                );
              },
              leading: Icon(
                Icons.whatsapp_outlined,
                color: Theme.of(context).hintColor,
              ),
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textWhatsappController.clear();
                },
                child: const Icon(Icons.clear),
              ),
            ),
            const SizedBox(height: 8),
            AppTextInput(
              hintText: Translate.of(context).translate('input_phone'),
              errorText: _errorPhone,
              controller: _textPhoneController,
              focusNode: _focusPhone,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                setState(() {
                  _errorPhone = UtilValidator.validate(
                    _textPhoneController.text,
                    type: ValidateType.phone,
                    allowEmpty: true,
                  );
                  if (!_extendedAttributes.any((item) => item.key == "phone")) {
                    _extendedAttributes.add(ExtendedAttributeModel(
                        key: "phone",
                        type: ExtendedAttributeType.text,
                        text: _textPhoneController.text,
                        group: "concat"));
                  }
                  _extendedAttributes
                      .singleWhere((item) => item.key == "phone")
                      .text = _textPhoneController.text;
                });
              },
              // onSubmitted: (text) {
              //   UtilOther.fieldFocusChange(
              //     context,
              //     _focusPhone,
              //     _focusFax,
              //   );
              // },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Translate.of(context).translate('social_network'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _onSocialNetwork,
                  child: Text(
                    textActionOpenTime,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              Translate.of(context).translate('the_explanation'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppTextInput(
              maxLines: 10,
              hintText: Translate.of(context).translate('input_explanation'),
              errorText: _errorContent,
              controller: _textContentController,
              focusNode: _focusContent,
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                setState(() {
                  _errorContent = UtilValidator.validate(
                    _textContentController.text,
                  );
                });
              },
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textContentController.clear();
                },
                child: const Icon(Icons.clear),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String textTitle = Translate.of(context).translate('add_new_listing');
    String textAction = Translate.of(context).translate('add');
    if (widget.item != null) {
      textTitle = Translate.of(context).translate('update_listing');
      textAction = Translate.of(context).translate('update');
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(textTitle),
          actions: [
            AppButton(
              textAction,
              onPressed: _onSubmit,
              type: ButtonType.text,
            )
          ],
        ),
        body: SafeArea(
          child: _buildContent(),
        ),
      ),
    );
  }
}

class PropertyWidgett extends StatelessWidget {
  late BuildContext context;
  final PropertyModel property;
  late String? errorWedgit;
  final ExtendedAttributeModel? extendedAttribute;
  final TextEditingController _controle = TextEditingController();

  PropertyWidgett({Key? key, required this.property, this.extendedAttribute})
      : super(key: key) {
    errorWedgit = "";
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    if (property.fieldType == FieldType.textInput) {
      return _buildtextInputProperty();
    } else if (property.fieldType == FieldType.itemPicker) {
      return _builditemPickerProperty();
    } else if (property.fieldType == FieldType.itemsPicker) {
      return _builditemsPickerProperty();
    } else if (property.fieldType == FieldType.slider) {
      return _buildSlider();
    } else if (property.fieldType == FieldType.rangSlider) {
      return _buildRangSlider();
    }
    return Container();
  }

  ///valid data
  bool _validData() {
    if (property.isRequired) {
      if (extendedAttribute!.getValue() == null ||
          extendedAttribute!.getValue().toString().isEmpty) {
        if (property.fieldType == FieldType.textInput) {
          errorWedgit = Translate.of(context).translate('value_not_empty');
        } else if (property.fieldType == FieldType.itemPicker) {
          errorWedgit = Translate.of(context).translate('must_be_selected');
        } else if (property.fieldType == FieldType.itemsPicker) {
          errorWedgit = Translate.of(context).translate('must_be_selected');
        } else {
          errorWedgit = null;
        }
      } else {
        errorWedgit = null;
      }
    }
    (context as Element).markNeedsBuild();
    return true;
  }

// Text input
  Widget _buildtextInputProperty() {
    _controle.text = extendedAttribute!.getValue()?.toString() ?? "";

    return Row(children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate(property.title),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Tooltip(
              triggerMode: TooltipTriggerMode.longPress,
              showDuration: const Duration(seconds: 1),
              message: errorWedgit != null &&
                      errorWedgit!.isNotEmpty &&
                      extendedAttribute!.getValue() == null
                  ? Translate.of(context).translate(property.inputPlacement)
                  : extendedAttribute!.getValue()?.toString() ?? "",
              child: AppTextInput(
                hintText:
                    Translate.of(context).translate(property.inputPlacement),
                errorText: errorWedgit,
                controller: _controle,
                keyboardType: property.valueType == ValueType.text
                    ? TextInputType.text
                    : TextInputType.number,
                inputFormatters: property.valueType == ValueType.int ||
                        property.valueType == ValueType.decimal
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : [],
                textInputAction: TextInputAction.done,
                onChanged: (text) {
                  extendedAttribute!.setValue(text);
                  errorWedgit = UtilValidator.validate(
                    text,
                    type: property.valueType == ValueType.int
                        ? ValidateType.realNumber
                        : property.valueType == ValueType.double
                            ? ValidateType.number
                            : ValidateType.normal,
                    max: property.max == 0 ? null : property.max,
                    min: property.min == 0 ? null : property.min,
                    allowEmpty: !property.isRequired,
                  );
                  // (context as Element).markNeedsBuild();
                },
                trailing: GestureDetector(
                  dragStartBehavior: DragStartBehavior.down,
                  onTap: () {
                    _controle.clear();
                    extendedAttribute!.setValue(null);
                  },
                  child: const Icon(Icons.clear),
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }

// dropbox input
  Widget _builditemsPickerProperty() {
    List<JsonProperty> selectedList = [];
    extendedAttribute!.getValue()?.toString().split(',').forEach((item) {
      if (property.json.any((j) => j.value == item.toString())) {
        selectedList
            .add(property.json.singleWhere((j) => j.value == item.toString()));
      }
    });

    return Row(children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate(property.title),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppPickerItem(
              leading: Icon(
                Icons.bedroom_parent_outlined,
                color: Theme.of(context).hintColor,
              ),
              value: selectedList
                  .map((e) => e.title /** title => key */)
                  .join(','),
              title: errorWedgit != null && errorWedgit!.isNotEmpty
                  ? errorWedgit!
                  : Translate.of(context).translate(property.inputPlacement),
              color: errorWedgit != null && errorWedgit!.isNotEmpty
                  ? Theme.of(context).errorColor
                  : null,
              onPressed: () {
                _onSelectPropertyItems();
              },
            ),
            if (errorWedgit != null)
              Text(
                errorWedgit!,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Theme.of(context).errorColor),
              )
          ],
        ),
      ),
    ]);
  }

  ///Select Property Items
  void _onSelectPropertyItems() async {
    List<JsonProperty> selectedList = [];
    extendedAttribute!.getValue()?.toString().split(',').forEach((item) {
      if (property.json.any((j) => j.value == item.toString())) {
        selectedList
            .add(property.json.singleWhere((j) => j.value == item.toString()));
      }
    });
    final result = await Navigator.pushNamed(
      context,
      Routes.categoryPicker,
      arguments: PickerModel(
        title: Translate.of(context).translate(property.title),
        selected: selectedList,
        data: property.json,
      ),
    );
    if (result != null && result is List<JsonProperty>) {
      extendedAttribute!.setValue(result.map((e) => e.value).join(','));
      _validData();
      (context as Element).markNeedsBuild();
    }
  }

// dropbox input
  Widget _builditemPickerProperty() {
    return Row(children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate(property.title),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppPickerItem(
              leading: Icon(
                Icons.bedroom_parent_outlined,
                color: Theme.of(context).hintColor,
              ),
              value: property.json
                      .any((j) => j.value == extendedAttribute!.text)
                  ? property.json
                      .singleWhere((j) => j.value == extendedAttribute!.text)
                      .title
                  : "",
              title: errorWedgit != null && errorWedgit!.isNotEmpty
                  ? errorWedgit!
                  : Translate.of(context).translate(property.inputPlacement),
              color: errorWedgit != null && errorWedgit!.isNotEmpty
                  ? Theme.of(context).errorColor
                  : null,
              onPressed: () async {
                await _onSelectPropertyItem();
              },
            ),
            if (errorWedgit != null)
              Text(
                errorWedgit!,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Theme.of(context).errorColor),
              )
          ],
        ),
      ),
    ]);
  }

  ///Select Property Items
  Future<void> _onSelectPropertyItem() async {
    final result = await showModalBottomSheet<JsonProperty?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => AppBottomPicker(
        picker: PickerModel(
          selected: [
            property.json.any((e) => e.value == extendedAttribute!.getValue())
                ? property.json.singleWhere(
                    (e) => e.value == extendedAttribute!.getValue())
                : null
          ],
          data: property.json,
        ),
        hasScroll: true,
      ),
    );

    if (result != null) {
      var propertySelected =
          property.json.singleWhere((e) => e.title == result.title);
      extendedAttribute!.setValue(propertySelected.value);
      _validData();
      (context as Element).markNeedsBuild();
    }
  }

  ///Create Slider
  Widget _buildSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        Text(
          Translate.of(context).translate(property.title),
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              property.min.toString(),
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              extendedAttribute!.double_?.toString() ?? property.max.toString(),
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
        SizedBox(
            height: 8,
            child: Slider(
              value: extendedAttribute!.double_?.toDouble() ?? property.max,
              max: property.max,
              min: property.min,
              divisions: (property.max - property.min).toInt(),
              inactiveColor: Theme.of(context).colorScheme.secondary,
              label: '${extendedAttribute!.double_ ?? 0}',
              onChanged: (value) {
                extendedAttribute!.double_ = value;
                (context as Element).markNeedsBuild();
              },
            )),
        if (errorWedgit != null && errorWedgit!.isNotEmpty)
          Text(
            errorWedgit!,
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: Theme.of(context).errorColor),
          )
      ],
    );
  }

  ///Create Range Slider
  Widget _buildRangSlider() {
    extendedAttribute!.rangMin ??= property.min;
    extendedAttribute!.rangMax ??= property.max;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Translate.of(context).translate(property.title),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    property.min.toString(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    property.max.toString(),
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              SizedBox(
                height: 16,
                child: RangeSlider(
                  min: property.min,
                  max: property.max,
                  values: RangeValues(
                    extendedAttribute!.rangMin ?? property.min,
                    extendedAttribute!.rangMax ?? property.max,
                  ),
                  divisions: (property.max - property.min).toInt(),
                  inactiveColor: Theme.of(context).colorScheme.secondary,
                  labels: RangeLabels(
                    property.min.toString(),
                    property.max.toString(),
                  ),
                  onChanged: (range) {
                    extendedAttribute!.rangMin = range.start;
                    extendedAttribute!.rangMax = range.end;
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
              if (errorWedgit != null && errorWedgit!.isNotEmpty)
                Text(
                  errorWedgit!,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(color: Theme.of(context).errorColor),
                ),
              if (errorWedgit == null || errorWedgit!.isEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      Translate.of(context).translate(property.inputPlacement),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      '${extendedAttribute!.rangMin ?? property.min} - ${extendedAttribute!.rangMax ?? property.max}',
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                  ],
                ),
            ],
          ),
        ]);
  }
}

class WidgetItem {
  // final PropertyModel property;
  final int propertyId;
  late Widget? widget;
  late Object? value = "";
  late String? errorWedgit;
  late Object? controle = Object;

  WidgetItem({required this.propertyId, this.widget, this.errorWedgit = ""});
}
