// import 'dart:convert';
// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:mime/mime.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../blocs/bloc.dart';
// import '../../configs/application.dart';
// import '../../configs/routes.dart';
// import '../../models/model.dart';
// import '../../utils/translate.dart';

// // استبدلنا Status.error ب Status.error
// class ChatScreen2 extends StatefulWidget {
//   final ChatUserModel chatUser;

//   const ChatScreen2({Key? key, required this.chatUser}) : super(key: key);

//   @override
//   State<ChatScreen2> createState() => _ChatScreen2State();
// }

// class _ChatScreen2State extends State<ChatScreen2> {
//   final SignalRHelper _signalR = SignalRHelper();

//   final List<types.Message> _messages = [];
//   late ChatTheme _chatTheme;
//   late types.User _user =
//       const types.User(id: '18770d4a-d9aa-4bd3-8f42-58d0d0d09cbf');

//   @override
//   void dispose() {
//     _signalR.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//        AppBloc.initCubit.contactId = widget.chatUser.id;
//     _user = types.User(
//         id: AppBloc.userCubit.state!.id,
//         imageUrl:
//             "${Application.domain}${AppBloc.userCubit.state!.profilePictureDataUrl}"
//                 .replaceAll("\\", "/")
//                 .replaceAll("TYPE", "thumb"));

//     // _scrollController.addListener(_onScroll);
//     // AppBloc.chatUsersListCubit.onLoad();
//     // final index = AppBloc.chatUsersListCubit.list
//     //     .indexWhere((e) => e.lastMessage?.fromUserId == widget.chatUser.id);
//     // AppBloc.chatUsersListCubit.list[index].lastMessage?.status == Status.seen;
//     // final updatedMessage = AppBloc.chatUsersListCubit.list[index];
//     // AppBloc.chatUsersListCubit.list[index] = updatedMessage;

//     _signalR.onReceiveMessage(
//         _receiveMessageHandler,
//         _receiveReadStatusMessageHandler,
//         _receiveDeliveredStatusMessageHandler);
//     _loadMessages();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _chatTheme = DefaultChatTheme(
//       primaryColor: Theme.of(context).primaryColor,
//       inputBackgroundColor: Theme.of(context).colorScheme.secondary,
//       errorIcon: Text(
//         // "√√",
//         "✔",
//         style: Theme.of(context).textTheme.caption?.copyWith(
//             color: Theme.of(context).colorScheme.primary, fontSize: 8),
//       ),
//       seenIcon: Text(
//         // "√√",
//         "✔✔",
//         style: Theme.of(context).textTheme.caption?.copyWith(
//             color: Theme.of(context).colorScheme.secondary, fontSize: 8),
//       ),
//       deliveredIcon: Text(
//         // "√√",
//         "✔✔",
//         style: Theme.of(context).textTheme.caption?.copyWith(
//             color: Theme.of(context).colorScheme.primary, fontSize: 8),
//       ),
//     );

//     return GestureDetector(
//         child: Scaffold(
//       appBar: AppBar(
//         title:
//             Text("${widget.chatUser.accountName} ${widget.chatUser.fullName}"),
//         actions: <Widget>[
//           GestureDetector(
//             child: const Icon(Icons.more_vert),
//           )
//         ],
//       ),
//       body: _messages != null
//           ? Chat(
//               // scrollController: _scrollController,
//               onAvatarTap: (p) => Navigator.pushNamed(context, Routes.profile,
//                   arguments: UserModel.fromJson({'id': widget.chatUser.id})),
//               messages: _messages,
//               onAttachmentPressed: _handleAttachmentPressed,
//               onMessageTap: _handleMessageTap,
//               onPreviewDataFetched: _handlePreviewDataFetched,
//               onSendPressed: _handleSendPressed,
//               showUserAvatars: true,
//               showUserNames: true,
//               onEndReached: _onReachedMessage,
//               isLastPage: AppBloc.initCubit.state is ChatSuccess_
//                   ? !(AppBloc.initCubit.state as ChatSuccess_).canLoadMore
//                   : false,
//               previewTapOptions: const PreviewTapOptions(
//                   openOnImageTap: true, openOnTitleTap: true),
//               usePreviewData: true,
//               user: _user,
//               theme: _chatTheme,
//               hideBackgroundOnEmojiMessages: false,
//               emojiEnlargementBehavior: EmojiEnlargementBehavior.single,
//               l10n: ChatL10nAr(
//                   attachmentButtonAccessibilityLabel:
//                       Translate.of(context).translate("send_media"),
//                   emptyChatPlaceholder:
//                       Translate.of(context).translate("no_messages_here_yet"),
//                   fileButtonAccessibilityLabel:
//                       Translate.of(context).translate("file"),
//                   inputPlaceholder: Translate.of(context).translate("message"),
//                   sendButtonAccessibilityLabel:
//                       Translate.of(context).translate("send")),
//             )
//           : Container(),
//     ));
//   }

//   _receiveMessageHandler(List<dynamic>? args) {
//     if (args![0]['toUserId'] == widget.chatUser.id &&
//         args[0]['fromUserId'] == AppBloc.userCubit.state!.id) {
//       final index = _messages
//           .indexWhere((element) => element.remoteId == args[0]['remotId']);
//       final updatedMessage =
//           _messages[index].copyWith(status: types.Status.error);
//       setState(() {
//         _messages[0] = updatedMessage;
//       });
//     } else if (args[0]['toUserId'] == AppBloc.userCubit.state!.id &&
//         args[0]['fromUserId'] == widget.chatUser.id) {
//       final message = types.TextMessage(
//         id: args[0]['id'].toString(),
//         remoteId: args[0]['remoteId'],
//         author: types.User(
//             id: args[0]['fromUserId'],
//             imageUrl:
//                 "${Application.domain}${widget.chatUser.profilePictureDataUrl}"
//                     .replaceAll("\\", "/")
//                     .replaceAll("TYPE", "thumb")),
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         text: args[0]['message'],
//       );
//       setState(() {
//         _messages.insert(0, message);
//       });
//       _signalR
//           .notifySendReadStatus(
//             widget.chatUser.id, //fromUserId
//           )
//           .ignore();
//       AppBloc.initCubit.onSendReadStatus(fromUserId: widget.chatUser.id);
//     }
//     // else if (args[0]['toUserId'] == AppBloc.userCubit.state!.id &&
//     //     args[0]['fromUserId'] != widget.chatUser.id) {
//     //   final message = types.TextMessage(
//     //     id: args[0]['id'].toString(),
//     //     remoteId: args[0]['remoteId'],
//     //     author: types.User(
//     //         id: args[0]['fromUserId'],
//     //         imageUrl:
//     //             "${Application.domain}${widget.chatUser.profilePictureDataUrl}"
//     //                 .replaceAll("\\", "/")
//     //                 .replaceAll("TYPE", "thumb")),
//     //     createdAt: DateTime.now().millisecondsSinceEpoch,
//     //     text: args[0]['message'],
//     //   );
//     //   setState(() {
//     //     _messages.insert(0, message);
//     //   });
//     //   _signalR
//     //       .notifySendStatus(
//     //         widget.chatUser.id, //fromUserId
//     //       )
//     //       .ignore();
//     // }
//   }

//   _receiveDeliveredStatusMessageHandler(List<dynamic>? args) {
//     if (args![0] != AppBloc.userCubit.state!.id) return;
//     _messages
//         .where((e) =>
//             e.status != types.Status.seen && e.status != types.Status.delivered)
//         .forEach((e) {
//       final index = _messages.indexWhere((element) => element.id == e.id);
//       final updatedMessage = (_messages[index]).copyWith(
//         status: types.Status.delivered,
//       );
//       _messages[index] = updatedMessage;
//     });

//     setState(() {});
//   }

//   _receiveReadStatusMessageHandler(List<dynamic>? args) {
//     if (args![0] != AppBloc.userCubit.state!.id) return;
//     _messages.where((e) => e.status != types.Status.seen).forEach((e) {
//       final index = _messages.indexWhere((element) => element.id == e.id);
//       final updatedMessage = (_messages[index]).copyWith(
//         status: types.Status.seen,
//       );
//       _messages[index] = updatedMessage;
//     });

//     setState(() {});
//   }

//   Future<void> _addMessage(types.Message message) async {
//     setState(() {
//       _messages.insert(0, message.copyWith(status: types.Status.sending));
//     });
//     var remoteId = const Uuid().v4();
//     int? msgId = await AppBloc.submitMessageCubit
//         .onSave(
//             message: ChatModel(
//       id: 0,
//       remoteId: remoteId,
//       message: (message as types.TextMessage).text,
//       fromUserId: AppBloc.userCubit.state!.id,
//       status: Status.error,
//       toUserId: widget.chatUser.id,
//       createdDate: null, //DateTime.now(),
//     ))
//         .then((int? msgId) {
//       if (msgId != null) {
//         final index = _messages
//             .indexWhere((element) => element.remoteId == message.remoteId);
//         final updatedMessage =
//             _messages[index].copyWith(status: types.Status.error);
//         setState(() {
//           _messages[0] = updatedMessage;
//         });
//         _signalR
//             .sendMessage(
//                 AppBloc.userCubit.state!.id,
//                 widget.chatUser.id,
//                 msgId,
//                 remoteId,
//                 "${message.author.firstName} ${message.author.lastName}",
//                 message.type == types.MessageType.text ? (message).text : "")
//             .ignore();
//       } else {
//         final index = _messages
//             .indexWhere((element) => element.remoteId == message.remoteId);
//         final updatedMessage = (_messages[index] as types.TextMessage)
//             .copyWith(status: null, text: "X");
//         setState(() {
//           _messages[0] = updatedMessage;
//         });
//       }
//     });
//   }

//   void _handleAttachmentPressed() {
//     showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) => SafeArea(
//         child: SizedBox(
//           height: 144,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleImageSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('Photo'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleFileSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('File'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('Cancel'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleFileSelection() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.any,
//     );

//     if (result != null && result.files.single.path != null) {
//       final message = types.FileMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         id: const Uuid().v4(),
//         mimeType: lookupMimeType(result.files.single.path!),
//         name: result.files.single.name,
//         size: result.files.single.size,
//         uri: result.files.single.path!,
//       );

//       await _addMessage(message);
//     }
//   }

//   void _handleImageSelection() async {
//     final result = await ImagePicker().pickImage(
//       imageQuality: 70,
//       maxWidth: 1440,
//       source: ImageSource.gallery,
//     );

//     if (result != null) {
//       final bytes = await result.readAsBytes();
//       final image = await decodeImageFromList(bytes);

//       final message = types.ImageMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         height: image.height.toDouble(),
//         id: const Uuid().v4(),
//         name: result.name,
//         size: bytes.length,
//         uri: result.path,
//         width: image.width.toDouble(),
//       );

//       await _addMessage(message);
//     }
//   }

//   void _handleMessageTap(BuildContext _, types.Message message) async {
//     if (message is types.FileMessage) {
//       var localPath = message.uri;

//       if (message.uri.startsWith('http')) {
//         try {
//           final index =
//               _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//               (_messages[index] as types.FileMessage).copyWith(
//             isLoading: true,
//           );

//           setState(() {
//             _messages[index] = updatedMessage;
//           });

//           final client = http.Client();
//           final request = await client.get(Uri.parse(message.uri));
//           final bytes = request.bodyBytes;
//           final documentsDir = (await getApplicationDocumentsDirectory()).path;
//           localPath = '$documentsDir/${message.name}';

//           if (!File(localPath).existsSync()) {
//             final file = File(localPath);
//             await file.writeAsBytes(bytes);
//           }
//         } finally {
//           final index =
//               _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//               (_messages[index] as types.FileMessage).copyWith(
//             isLoading: null,
//           );

//           setState(() {
//             _messages[index] = updatedMessage;
//           });
//         }
//       }

//       await OpenFile.open(localPath);
//     }
//   }

//   void _handlePreviewDataFetched(
//     types.TextMessage message,
//     types.PreviewData previewData,
//   ) {
//     final index = _messages.indexWhere((element) => element.id == message.id);
//     final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
//       previewData: previewData,
//     );

//     setState(() {
//       _messages[index] = updatedMessage;
//     });
//   }

//   Future<void> _handleSendPressed(types.PartialText message) async {
//     final textMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: message.text,
//     );

//     await _addMessage(textMessage);
//   }

//   void _loadMessages() async {

//     await AppBloc.initCubit.onLoadChat();
//     final state = AppBloc.initCubit.state;
//     if (state is ChatSuccess && !state.loadingMore) {
//       for (int i = 0; i < state.list.length; i++) {
//         _messages.add(types.TextMessage(
//           author: types.User(
//               id: state.list[i].fromUserId,
//               imageUrl:
//                   "${Application.domain}${widget.chatUser.profilePictureDataUrl}"
//                       .replaceAll("\\", "/")
//                       .replaceAll("TYPE", "thumb")),
//           createdAt: state.list[i].unixTimeMilliseconds,
//           id: state.list[i].id.toString(),
//           text: state.list[i].message,
//           type: types.MessageType.values[state.list[i].type.index],
//           status: types.Status.values[state.list[i].status.index],
//         ));
//       }
//       if (state.list.any((e) =>
//           e.fromUserId != AppBloc.userCubit.state!.id &&
//           e.status.index != types.Status.seen.index)) {
//         _signalR.notifySendReadStatus(
//           widget.chatUser.id,
//         );
//         AppBloc.initCubit.onSendReadStatus(fromUserId: widget.chatUser.id);
//       }

//       setState(() => {});
//     }
//   }

//   Future<void> _onReachedMessage() async {
//     final state = AppBloc.initCubit.state;
//     if (state is ChatSuccess_ && state.canLoadMore && !state.loadingMore) {
//       await AppBloc.initCubit.onLoadMore();
//       for (int i = _messages.length; i < state.list.length; i++) {
//         _messages.add(types.TextMessage(
//           author: types.User(
//               id: state.list[i].fromUserId,
//               imageUrl:
//                   "${Application.domain}${widget.chatUser.profilePictureDataUrl}"
//                       .replaceAll("\\", "/")
//                       .replaceAll("TYPE", "thumb")),
//           createdAt: state.list[i].unixTimeMilliseconds,
//           id: state.list[i].id.toString(),
//           text: state.list[i].message,
//           type: types.MessageType.values[state.list[i].type.index],
//           status: types.Status.values[state.list[i].status.index],
//         ));
//       }
//       setState(() => {});
//     }
//   }
// }
