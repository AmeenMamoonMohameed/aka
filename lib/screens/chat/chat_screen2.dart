import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/bloc.dart';
import '../../configs/application.dart';
import '../../configs/routes.dart';
import '../../models/model.dart';
import '../../repository/chat_repository.dart';
import '../../utils/translate.dart';
import '../../utils/validate.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_input.dart';

// استبدلنا Status.error ب Status.error
class ChatScreen2 extends StatefulWidget {
  final ChatUserModel chatUser;

  const ChatScreen2({Key? key, required this.chatUser}) : super(key: key);

  @override
  State<ChatScreen2> createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  final List<types.Message> _messages = [];
  late ChatTheme _chatTheme;
  late types.User _user =
      const types.User(id: '18770d4a-d9aa-4bd3-8f42-58d0d0d09cbf');
  Widget chatWidget = Container();

  @override
  void dispose() {
    AppBloc.initCubit.contactId = '';
    AppBloc.initCubit.chatList = [];
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _messages.forEach((element) {
    //   _messages.remove(element);
    // });
    AppBloc.initCubit.contactId = widget.chatUser.id;
    AppBloc.initCubit.onLoadChat();
    // _loadMessages();
    _user = types.User(
        id: AppBloc.userCubit.state!.id,
        imageUrl:
            "${Application.domain}${AppBloc.userCubit.state!.profilePictureDataUrl}"
                .replaceAll("\\", "/")
                .replaceAll("TYPE", "thumb"));
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _chatTheme = DefaultChatTheme(
      primaryColor: Theme.of(context).primaryColor,
      inputBackgroundColor: Theme.of(context).colorScheme.secondary,
      errorIcon: Text(
        // "√√",
        "✔",
        style: Theme.of(context).textTheme.caption?.copyWith(
            color: Theme.of(context).colorScheme.primary, fontSize: 8),
      ),
      seenIcon: Text(
        // "√√",
        "✔✔",
        style: Theme.of(context).textTheme.caption?.copyWith(
            color: Theme.of(context).colorScheme.secondary, fontSize: 8),
      ),
      deliveredIcon: Text(
        // "√√",
        "✔✔",
        style: Theme.of(context).textTheme.caption?.copyWith(
            color: Theme.of(context).colorScheme.primary, fontSize: 8),
      ),
    );
    String sendMediaText = Translate.of(context).translate("send_media");
    String noMessagesText =
        Translate.of(context).translate("no_messages_here_yet");
    String fileText = Translate.of(context).translate("file");
    String messageText = Translate.of(context).translate("message");
    String sendText = Translate.of(context).translate("send");

    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "${widget.chatUser.accountName} ${widget.chatUser.fullName}"),
          actions: <Widget>[
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(Translate.of(context).translate("block")),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(Translate.of(context).translate("report")),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                _onBlock(context);
              } else if (value == 1) {
                _onReport(context);
              }
            }),
          ],
        ),
        body: BlocBuilder<InitCubit, InitState>(builder: (context_, state) {
          AppBloc.initCubit.stream.listen((state) {
            if (state is ReadStatusSuccess) {
              for (int i = 0; i < _messages.length; i++) {
                if (_messages[i].status != types.Status.seen) {
                  _messages[i] =
                      _messages[i].copyWith(status: types.Status.seen);
                }
              }
            }
            if (state is DeliveredStatusSuccess) {
              for (int i = 0; i < _messages.length; i++) {
                if (_messages[i].status != types.Status.delivered &&
                    _messages[i].status != types.Status.seen) {
                  _messages[i] =
                      _messages[i].copyWith(status: types.Status.delivered);
                }
              }
            }
            if (state is ChatSuccess) {
              for (int i = 0; i < (state).list.length; i++) {
                if (!_messages.any(
                    (element) => element.id == state.list[i].id.toString())) {
                  _messages.insert(
                      i,
                      types.TextMessage(
                        author: types.User(
                            id: state.list[i].fromUserId,
                            imageUrl:
                                "${Application.domain}${widget.chatUser.profilePictureDataUrl}"
                                    .replaceAll("\\", "/")
                                    .replaceAll("TYPE", "thumb")),
                        createdAt: state.list[i].unixTimeMilliseconds,
                        id: state.list[i].id.toString(),
                        text: state.list[i].message,
                        type:
                            types.MessageType.values[state.list[i].type.index],
                        status: types.Status.values[state.list[i].status.index],
                      ));
                }
              }
            }

            chatWidget = Chat(
              
              onAvatarTap: (p) => Navigator.pushNamed(context_, Routes.profile,
                  arguments: UserModel.fromJson({'id': widget.chatUser.id})),
              messages: _messages,
              onAttachmentPressed: _handleAttachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              onEndReached: _onReachedMessage,
              isLastPage: AppBloc.initCubit.state is ChatSuccess
                  ? !(AppBloc.initCubit.state as ChatSuccess).canLoadMore
                  : false,
              previewTapOptions: const PreviewTapOptions(
                  openOnImageTap: true, openOnTitleTap: true),
              usePreviewData: true,
              user: _user,
              theme: _chatTheme,
              hideBackgroundOnEmojiMessages: false,
              emojiEnlargementBehavior: EmojiEnlargementBehavior.single,
              l10n: ChatL10nAr(
                  attachmentButtonAccessibilityLabel: sendMediaText,
                  emptyChatPlaceholder: noMessagesText,
                  fileButtonAccessibilityLabel: fileText,
                  inputPlaceholder: messageText,
                  sendButtonAccessibilityLabel: sendText),
            );
          });

          // setState(() => {});
          return chatWidget;
        }),
      ),
    );
  }

  ///On block user
  void _onBlock(
    BuildContext mainContext,
  ) async {
    String? errorTitle;
    await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String? title;
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('block'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  Translate.of(context).translate('because_of'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  maxLines: 2,
                  errorText: errorTitle,
                  hintText: errorTitle ??
                      Translate.of(context).translate('because_of'),
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
                    UtilValidator.validate(title ?? "", allowEmpty: true);
                setState(() {});
                if (errorTitle == null) {
                  Navigator.pop(context);
                  final result = await ChatRepository.blockUser(
                      userId: widget.chatUser.id, because: title);
                  if (result ?? false) {
                    Navigator.pop(mainContext);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  ///On report product
  void _onReport(
    BuildContext context_,
  ) async {
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
                      reportedId: widget.chatUser.id,
                      title: title!,
                      description: description!,
                      type: ReportType.profile));
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

  Future<void> _addMessage(types.Message message) async {
    var remoteId = const Uuid().v4();
    setState(() {
      _messages.insert(0,
          message.copyWith(status: types.Status.sending, remoteId: remoteId));
    });
    AppBloc.initCubit.onEmit();
    await AppBloc.initCubit
        .onSave(
            message: ChatModel(
      id: 0,
      remoteId: remoteId,
      message: (message as types.TextMessage).text,
      fromUserId: AppBloc.userCubit.state!.id,
      status: Status.error,
      toUserId: widget.chatUser.id,
      createdDate: null, //DateTime.now(),
    ))
        .then((int? msgId) {
      if (msgId != null) {
        final index =
            _messages.indexWhere((element) => element.remoteId == remoteId);
        final updatedMessage = _messages[index]
            .copyWith(id: msgId.toString(), status: types.Status.error);
        setState(() {
          _messages[0] = updatedMessage;
        });
      }
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      await _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      await _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    await _addMessage(textMessage);
  }

  Future<void> _onReachedMessage() async {
    final state = AppBloc.initCubit.state;
    await AppBloc.initCubit.onLoadMoreChat();
    if (state is ChatSuccess && state.canLoadMore && !state.loadingMore) {
      for (int i = _messages.length; i < state.list.length; i++) {
        _messages.add(types.TextMessage(
          author: types.User(
              id: state.list[i].fromUserId,
              imageUrl:
                  "${Application.domain}${widget.chatUser.profilePictureDataUrl}"
                      .replaceAll("\\", "/")
                      .replaceAll("TYPE", "thumb")),
          createdAt: state.list[i].unixTimeMilliseconds,
          id: state.list[i].id.toString(),
          text: state.list[i].message,
          type: types.MessageType.values[state.list[i].type.index],
          status: types.Status.values[state.list[i].status.index],
        ));
      }
      setState(() => {});
    }
  }
}
