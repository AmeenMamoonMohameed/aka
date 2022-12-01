import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/configs/config.dart';
import 'package:akarak/models/model.dart';
import 'package:akarak/utils/utils.dart';
import 'package:akarak/widgets/widget.dart';

import '../../repository/repository.dart';

class Review extends StatefulWidget {
  final ProductModel product;

  const Review({Key? key, required this.product}) : super(key: key);

  @override
  _ReviewState createState() {
    return _ReviewState();
  }
}

class _ReviewState extends State<Review> {
  @override
  void initState() {
    super.initState();
    AppBloc.reviewCubit.onLoad(widget.product.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On refresh
  Future<void> _onRefresh() async {
    await AppBloc.reviewCubit.onLoad(widget.product.id);
  }

  ///On navigate write review
  void _onWriteReview() async {
    if (AppBloc.userCubit.state == null) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.writeReview,
      );
      if (result != Routes.writeReview) {
        return;
      }
    }
    if (!mounted) return;
    List<Object> obj = [widget.product, {}, "new"];
    Navigator.pushNamed(
      context,
      Routes.writeReview,
      arguments: widget.product,
    );
  }

  ///On show message fail
  void _showMessage(
      {required String title,
      required String message,
      VoidCallback? func,
      String? funcName}) async {
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

  ///On report product
  void _onReport(
      BuildContext context_, String reportedId, bool isReview) async {
    if (!AppBloc.userCubit.state!.phoneNumberConfirmed) {
      _showMessage(
        title: Translate.of(context).translate('confirm_phone_number'),
        message: Translate.of(context)
            .translate('the_phone_number_must_be_confirmed_first'),
        func: () {
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
        funcName: Translate.of(context).translate('confirm'),
      );
      return;
    }
    String? errorTitle;
    String? errorDescription;
    await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String? title;
        String? description;
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('report'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  Translate.of(context)
                      .translate('specify_the_main_reason_for_reporting'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  maxLines: 2,
                  errorText: errorTitle,
                  hintText: errorTitle ??
                      Translate.of(context).translate('report_title'),
                  controller: TextEditingController(),
                  textInputAction: TextInputAction.done,
                  onChanged: (text) {
                    setState(() {
                      title = text;
                      errorTitle =
                          UtilValidator.validate(text, allowEmpty: false);
                    });
                  },
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  maxLines: 10,
                  errorText: errorDescription,
                  hintText: errorDescription ??
                      Translate.of(context).translate('report_description'),
                  controller: TextEditingController(),
                  textInputAction: TextInputAction.done,
                  onChanged: (text) {
                    setState(() {
                      description = text;
                      errorDescription =
                          UtilValidator.validate(text, allowEmpty: false);
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context).translate('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              type: ButtonType.text,
            ),
            AppButton(
              Translate.of(context).translate('confirm'),
              onPressed: () async {
                errorTitle =
                    UtilValidator.validate(title ?? "", allowEmpty: false);
                errorDescription = UtilValidator.validate(description ?? "",
                    allowEmpty: false);
                setState(() {});
                if (errorTitle == null && errorDescription == null) {
                  Navigator.pop(context, description);
                  final result = await ChatRepository.sendReport(ReportModel(
                      reportedId: reportedId,
                      title: title!,
                      description: description!,
                      type: isReview ? ReportType.review : ReportType.replay));
                  if (result != null) {
                    AppBloc.messageCubit.onShow(Translate.of(context_)
                        .translate('the_message_has_been_sent'));
                  } else {
                    AppBloc.messageCubit.onShow(Translate.of(context_)
                        .translate(
                            'an_error_occurred,_the_message_was_not_sent'));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onAction(CommentModel item, BuildContext context) async {
    final result = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Widget bookingItem = Container();
        // if (item.bookingUse) {
        //   bookingItem = AppListTitle(
        //     title: Translate.of(context).translate("booking"),
        //     leading: const Icon(Icons.pending_actions_outlined),
        //     onPressed: () {
        //       Navigator.pop(context, "booking");
        //     },
        //   );
        // }
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    Column(
                      children: [
                        bookingItem,
                        if (AppBloc.userCubit.state!.id ==
                                widget.product.createdBy!.id &&
                            item.reviewType == ReviewType.review &&
                            (item.replaies != null &&
                                !item.replaies!.any((element) =>
                                    element.createdBy.id ==
                                    AppBloc.userCubit.state!.id)))
                          AppListTitle(
                            title: Translate.of(context).translate("replay"),
                            leading: const Icon(Icons.share_outlined),
                            onPressed: () {
                              Navigator.pop(context, "replay");
                            },
                            border: false,
                          ),
                        if (AppBloc.userCubit.state!.id != item.createdBy.id)
                          AppListTitle(
                            title: Translate.of(context).translate("report"),
                            leading: const Icon(Icons.flag_outlined),
                            onPressed: () {
                              Navigator.pop(context, "report");
                            },
                            border: false,
                          ),
                        if (AppBloc.userCubit.state!.id == item.createdBy.id)
                          AppListTitle(
                            title: Translate.of(context).translate("edit"),
                            leading: const Icon(Icons.share_outlined),
                            onPressed: () {
                              Navigator.pop(context, "edit");
                            },
                            border: false,
                          ),
                        if (AppBloc.userCubit.state!.id == item.createdBy.id)
                          AppListTitle(
                            title: Translate.of(context).translate("remove"),
                            leading: const Icon(Icons.delete_outline),
                            onPressed: () {
                              Navigator.pop(context, "remove");
                            },
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    if (result == 'replay') {
      List<Object> obj = [widget.product, item, "replay"];
      if (AppBloc.userCubit.state == null) {
        final result = await Navigator.pushNamed(
          context,
          Routes.writeReview,
          arguments: obj,
        );
        if (result != Routes.writeReview) {
          return;
        }
      }
    }

    if (result == 'report') {
      if (AppBloc.userCubit.state == null) {
        final result = await Navigator.pushNamed(
          context,
          Routes.signIn,
          arguments: Routes.review,
        );
        if (result != Routes.review) {
          return;
        }
      }
      _onReport(
          context, item.id.toString(), item.reviewType == ReviewType.review);
    }
    if (result == 'edit') {
      if (AppBloc.userCubit.state == null) {
        final result = await Navigator.pushNamed(
          context,
          Routes.signIn,
          arguments: Routes.writeReview,
        );
        if (result != Routes.writeReview) {
          return;
        }
      }
      List<Object> obj = [widget.product, item, "edit"];
      await Navigator.pushNamed(
        context,
        Routes.writeReview,
        arguments: obj,
      );
    }
    if (result == 'remove') {
      await AppBloc.reviewCubit.onRemove(id: item.id, type: item.reviewType);
      await _onRefresh();
    }
  }

  ///On Preview Profile
  void _onProfile(UserModel user) {
    Navigator.pushNamed(context, Routes.profile, arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('reviews'),
        ),
        actions: [
          AppButton(
            Translate.of(context).translate('write'),
            onPressed: _onWriteReview,
            type: ButtonType.text,
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ReviewCubit, ReviewState>(
          builder: (context, state) {
            RateModel? rate;

            ///Loading
            Widget content = ListView(
              children: List.generate(8, (index) => index).map(
                (item) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: AppCommentItem(),
                  );
                },
              ).toList(),
            );

            ///Success
            if (state is ReviewSuccess) {
              rate = state.rate;

              ///Empty
              if (state.list.isEmpty) {
                content = Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.sentiment_satisfied),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          Translate.of(context).translate('reviews'),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                content = RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      final item = state.list[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: AppCommentItem(
                          item: item,
                          onPressUser: () {
                            _onProfile(item.createdBy);
                          },
                          onAction:
                              (CommentModel item, BuildContext context) async =>
                                  await _onAction(item, context),
                        ),
                      );
                    },
                  ),
                );
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 16),
                  AppRating(rate: rate),
                  const SizedBox(height: 16),
                  Expanded(child: content),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
