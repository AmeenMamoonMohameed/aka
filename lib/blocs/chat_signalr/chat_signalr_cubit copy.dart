// import 'dart:io';

// import 'package:bloc/bloc.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:signalr_netcore/ihub_protocol.dart';
// import 'package:signalr_netcore/json_hub_protocol.dart';
// import 'package:signalr_netcore/msgpack_hub_protocol.dart';
// import '../../models/model_chat.dart';
// import '../bloc.dart';
// import 'package:signalr_netcore/signalr_client.dart';
// // Import theses libraries.
// import 'package:logging/logging.dart';

// class ChatSignalRCubit extends Cubit<ChatSignalRState> {
// // If you want only to log out the message for the higer level hub protocol:
//   final hubProtLogger = Logger("SignalR - hub");
// // If youn want to also to log out transport messages:
//   final transportProtLogger = Logger("SignalR - transport");

// // The location of the SignalR Server.
//   final serverUrl = "http://akarak-001-site4.gtempurl.com/signalRHub";
//   late final httpOptions = HttpConnectionOptions(
//     // transport: HttpTransportType.LongPolling,
//     // httpClient: WebSupportingHttpClient(
//     //   transportProtLogger,
//     // ),
//     // logger: transportProtLogger,
//     accessTokenFactory: () =>
//         Future.value(AppBloc.userCubit.state?.token ?? ""),
//   );
// //final httpOptions = new HttpConnectionOptions(logger: transportProtLogger, transport: HttpTransportType.WebSockets); // default transport type.
// //final httpOptions = new HttpConnectionOptions(logger: transportProtLogger, transport: HttpTransportType.ServerSentEvents);
// //final httpOptions = new HttpConnectionOptions(logger: transportProtLogger, transport: HttpTransportType.LongPolling);

// // If you need to authorize the Hub connection than provide a an async callback function that returns
// // the token string (see AccessTokenFactory typdef) and assigned it to the accessTokenFactory parameter:
// // final httpOptions = new HttpConnectionOptions( .... accessTokenFactory: () async => await getAccessToken() );

//   late final hubConnection = HubConnectionBuilder()
//       .withUrl(serverUrl, options: httpOptions)
//       // .configureLogging(hubProtLogger)
//       .withHubProtocol(JsonHubProtocol())
//       .withAutomaticReconnect()
//       .build();
//   void callback({Exception? error}) {
//     print("fd");
//   }
// // When the connection is closed, print out a message to the console.

//   ChatSignalRCubit() : super(ChatSignalRState.reconnecting) {
//     Logger.root.level = Level.ALL;
//     Logger.root.onRecord.listen((LogRecord rec) {
//       print('${rec.level.name}: ${rec.time}: ${rec.message}');
//     });
//     // hubConnection.onclose(callback);
//   }

//   Future<void> checkConnectionProcess() async {
//     await hubConnection.start();
//   }

//   Future<void> build(receiveMessageHandler, receiveReadStatusMessageHandler,
//       receiveDeliveredStatusMessageHandler) async {
//     if (hubConnection == null) return;
//     hubConnection.on('ReceiveMessage_', receiveMessageHandler);
//     if (receiveReadStatusMessageHandler != null) {
//       hubConnection.on(
//           'ReceiveReadStatusMessage', receiveReadStatusMessageHandler);
//     } else {
//       hubConnection.off('ReceiveReadStatusMessage');
//     }
//     if (receiveDeliveredStatusMessageHandler != null) {
//       hubConnection.on('ReceiveDeliveredStatusMessage',
//           receiveDeliveredStatusMessageHandler);
//     } else {
//       hubConnection.off('ReceiveDeliveredStatusMessage');
//     }
//     hubConnection.serverTimeoutInMilliseconds = 30000;
//     // hubConnection.serverTimeoutInMilliseconds = 360000;
//     hubConnection.keepAliveIntervalInMilliseconds = 15000;

//     await hubConnection.start()?.catchError((onError) {
//       debugPrint(onError is String ? "unk" : "ssssssssssa");
//     });
//   }

//   Future<void> sendMessage(String sender, String receiver, int msgId,
//       String remoteId, String userName, String message) async {
//     // if (hubConnection == null) return;

//     if (hubConnection.state == HubConnectionState.Disconnected) {
//       await hubConnection.start();
//     }

//     var newMsg = ChatModel(
//         id: msgId,
//         remoteId: remoteId,
//         fromUserId: sender,
//         toUserId: receiver,
//         message: message,
//         createdDate: null);
//     await hubConnection
//         .invoke('SendMessageAsync', args: [newMsg.toJson(), userName]);
//     // await hubConnection.invoke('SendMessage', args: [userName, message]);
//   }

//   Future<void> notifySendDeliveredStatusForAll(List<String> users) async {
//     if (hubConnection == null) return;

//     await hubConnection
//         .invoke('SendDeliveredStatusForUsersAsync', args: [users]);
//   }

//   Future<void> notifySendReadStatus(String fromUserId) async {
//     if (hubConnection == null) return;

//     await hubConnection.invoke('SendReadStatusAsync', args: [fromUserId]);
//   }

//   Future<void> notifySendDeliveredStatus(String fromUserId) async {
//     if (hubConnection == null) return;

//     await hubConnection.invoke('SendDeliveredStatusAsync', args: [fromUserId]);
//   }

//   void dispose() {
//     if (hubConnection == null) return;
//     hubConnection.onclose(({error}) {
//       print(error!.toString());
//     });
//     hubConnection.off('ReceiveReadStatusMessage');
//     hubConnection.off('ReceiveDeliveredStatusMessage');
//     hubConnection.stop();
//   }
// }
