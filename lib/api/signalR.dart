// // import 'dart:convert';
// // import 'dart:developer';

// // import 'package:flutter/material.dart';
// // import 'package:signalr_netcore/signalr_client.dart';
// // import 'package:logging/logging.dart';
// // import '../../configs/application.dart';
// // import '../../models/model_message.dart';

// // class SignalR {
// //   final url = '${Application.domain}signalRHub';
// //   late HubConnection hubConnection!;
// //   var messageList = <MessageModel>[];
// //   String textMessage = '';

// //   void connect(receiveMessageHandler) {
// //     hubConnection! = HubConnectionBuilder().withUrl(url).build();

// //     // hubConnection!.onclose((error) {

// //     // });
// //     hubConnection!.on('ReceiveMessage', receiveMessageHandler);
// //     hubConnection!.start();
// //   }

// //   Future<void> sendMessage(String userName, String message) async {
// //     var newMsg = MessageModel(
// //         id: 1,
// //         fromUserId: "0c697be0-6f3e-466b-bcfd-d03140e12de1",
// //         toUserId: "3f614d02-ada9-44ec-8b4a-fe7045f33d30",
// //         message: message,
// //         createdDate: null);
// //     await hubConnection!
// //         .invoke('SendMessageAsync', args: [newMsg.toJson(), userName]);
// //     // messageList.add(Message(
// //     //     name: name,
// //     //     message: message,
// //     //     isMine: true));
// //     textMessage = '';
// //   }

// //   receiveMessageHandlert(List<Object>? args) {
// //     var sssss = "ssssssss";
// //     // signalR.messageList.add(MessageModel(fromUserId: args[0], message: args[1]));
// //   }

// //   void disconnect() {
// //     hubConnection!.stop();
// //   }
// // }
// import 'dart:io';

// import 'package:http/io_client.dart';
// import 'package:signalr_core/signalr_core.dart';
// import '../../configs/application.dart';
// import '../../models/model_chat.dart';
// import '../blocs/app_bloc.dart';

// class SignalR {
//   static const url = 'http://akarak-001-site4.gtempurl.com/signalRHub';
//   // static const url = 'http://10.0.2.2:5000/signalRHub';

//   HubConnection? hubConnection = HubConnectionBuilder()
//       .withUrl(
//     url,
//     HttpConnectionOptions(
//         client:
//             IOClient(HttpClient()..badCertificateCallback = (x, y, z) => true),
//         logging: (level, message) => print(message),
//         accessTokenFactory: () async {
//           return "${AppBloc.userCubit.state?.token}";
//         },
//         // skipNegotiation: true,
//         transport: HttpTransportType.longPolling),
//   )
//       .withAutomaticReconnect([0, 3000, 5000, 10000, 15000, 30000]).build();

//   Future<void> onHasNewMessages(hasNewMessagesHandler) async {
//     if (hubConnection == null) return;
//     hubConnection!.on('HasNewMessages', hasNewMessagesHandler);
//     hubConnection!.serverTimeoutInMilliseconds = 360000;
//     hubConnection!.keepAliveIntervalInMilliseconds = 360000;
//     // hubConnection!.keepAliveIntervalInMilliseconds = 60000;
//     hubConnection!.onreconnecting((exception) {});
//     hubConnection!.onreconnected((exception) {});
//     hubConnection!.onclose((exception) {});
//     await hubConnection!.start();
//   }

//   Future<void> onReceiveMessage(
//       receiveMessageHandler,
//       receiveReadStatusMessageHandler,
//       receiveDeliveredStatusMessageHandler) async {
//     if (hubConnection == null) return;
//     hubConnection!.on('ReceiveMessage_', receiveMessageHandler);
//     if (receiveReadStatusMessageHandler != null) {
//       hubConnection!
//           .on('ReceiveReadStatusMessage', receiveReadStatusMessageHandler);
//     } else {
//       hubConnection!.off('ReceiveReadStatusMessage');
//     }
//     if (receiveDeliveredStatusMessageHandler != null) {
//       hubConnection!.on('ReceiveDeliveredStatusMessage',
//           receiveDeliveredStatusMessageHandler);
//     } else {
//       hubConnection!.off('ReceiveDeliveredStatusMessage');
//     }
//     hubConnection!.serverTimeoutInMilliseconds = 360000;
//     hubConnection!.keepAliveIntervalInMilliseconds = 360000;
//     // hubConnection!.keepAliveIntervalInMilliseconds = 60000;
//     hubConnection!.onreconnecting((exception) {});
//     hubConnection!.onclose((exception) {});
//     await hubConnection!.start();
//   }

//   Future<void> sendMessage(String sender, String receiver, int msgId,
//       String remoteId, String userName, String message) async {
//     if (hubConnection == null) return;

//     if (hubConnection!.state == HubConnectionState.disconnected) {
//       await hubConnection!.start();
//     }

//     var newMsg = ChatModel(
//         id: msgId,
//         remoteId: remoteId,
//         fromUserId: sender,
//         toUserId: receiver,
//         message: message,
//         createdDate: null);
//     await hubConnection!
//         .invoke('SendMessageAsync', args: [newMsg.toJson(), userName]);
//     // await hubConnection!.invoke('SendMessage', args: [userName, message]);
//   }

//   Future<void> notifySendDeliveredStatusForAll(List<String> users) async {
//     if (hubConnection == null) return;

//     await hubConnection!
//         .invoke('SendDeliveredStatusForUsersAsync', args: [users]);
//   }

//   Future<void> notifySendReadStatus(String fromUserId) async {
//     if (hubConnection == null) return;

//     await hubConnection!.invoke('SendReadStatusAsync', args: [fromUserId]);
//   }

//   Future<void> notifySendDeliveredStatus(String fromUserId) async {
//     if (hubConnection == null) return;

//     await hubConnection!.invoke('SendDeliveredStatusAsync', args: [fromUserId]);
//   }

//   void dispose() {
//     if (hubConnection == null) return;
//     hubConnection!.off('ReceiveReadStatusMessage');
//     hubConnection!.off('ReceiveDeliveredStatusMessage');
//     hubConnection!.stop();
//     hubConnection = null;
//   }
// }
