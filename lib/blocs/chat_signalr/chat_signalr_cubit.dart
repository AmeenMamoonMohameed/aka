import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/io_client.dart';
import 'package:signalr_core/signalr_core.dart';
import '../../configs/application.dart';
import '../../models/model_chat.dart';
import '../../repository/repository.dart';
import '../app_bloc.dart';
import '../bloc.dart';

class ChatSignalRCubit extends Cubit<ChatSignalRState> {
  ChatSignalRCubit() : super(ChatSignalRState.reconnecting) {
    // checkConnectionProcess();
  }

  static const url = 'http://akarak-001-site1.gtempurl.com/signalRHub';
  // static const url = 'http://10.0.2.2:5000/signalRHub';

  HubConnection? hubConnection;

  Future<void> onPing() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 10)).whenComplete(() async {
        await ChatRepository.ping();
      });
    }
  }

  Future<void> startAsync() async {
    try {
      if (hubConnection != null) {
        if (hubConnection?.state != HubConnectionState.connected &&
            hubConnection?.state != HubConnectionState.connecting &&
            hubConnection?.state != HubConnectionState.reconnecting) {
          await hubConnection!.start();
        }
      }
    } finally {
      if (hubConnection?.state == HubConnectionState.connected) {
        await onPing();
        // await hubConnection!.invoke('PingRequestAsync');
        // await ChatRepository.ping();
      }
    }
  }

  Future<void> build(receiveMessageHandler, receiveReadStatusMessageHandler,
      receiveDeliveredStatusMessageHandler) async {
    if (AppBloc.userCubit.state == null) return;
    if (hubConnection != null) {
      if (hubConnection?.state != HubConnectionState.connected &&
          hubConnection?.state != HubConnectionState.connecting &&
          hubConnection?.state != HubConnectionState.reconnecting) {
        await startAsync();
      }
      return;
    }
    hubConnection = HubConnectionBuilder()
        .withUrl(
      url,
      HttpConnectionOptions(
          client: IOClient(
              HttpClient()..badCertificateCallback = (x, y, z) => true),
          logging: (level, message) async {
            if (message.contains('HttpConnection connected successfully') &&
                state != ChatSignalRState.reconnected) {
              emit(ChatSignalRState.reconnected);
            } else if (message.contains('Starting HubConnection') &&
                state != ChatSignalRState.reconnected) {
              emit(ChatSignalRState.reconnected);
            } else if (message.contains(
                    'ignored because the connection is already in the disconnecting state.') &&
                state != ChatSignalRState.reconnecting) {
              emit(ChatSignalRState.reconnecting);
            } else if (message.contains(
                    'ignored because the connection is already in the disconnecting state.') &&
                state != ChatSignalRState.reconnecting) {
              emit(ChatSignalRState.reconnecting);
            } else if (message.contains(
                    'Connection stopped during reconnect delay. Done reconnecting') &&
                state != ChatSignalRState.reconnecting) {
              emit(ChatSignalRState.reconnecting);
            } else if (message
                    .contains('An onreconnecting callback called with error') &&
                state != ChatSignalRState.reconnecting) {
              emit(ChatSignalRState.reconnecting);
            } else if (message.contains(
                    'Connection left the reconnecting state in onreconnecting callback. Done reconnecting') &&
                state != ChatSignalRState.reconnecting) {
              emit(ChatSignalRState.reconnecting);
            } else if (message.contains('Stopping HubConnection') &&
                state != ChatSignalRState.reconnecting) {
              emit(ChatSignalRState.reconnecting);
            } else if (message.contains(
                    'Exception: Server timeout elapsed without receiving a message from the server') &&
                state != ChatSignalRState.reconnecting) {
              emit(ChatSignalRState.reconnecting);
            } else if (message.contains(
                    'Exception: Cannot send until the transport is connected') &&
                state != ChatSignalRState.reconnecting) {
              emit(ChatSignalRState.reconnecting);
            } else if (message.contains('Stopping polling') &&
                state != ChatSignalRState.reconnecting) {
              emit(ChatSignalRState.reconnecting);
            }
            // else if (message.contains('HttpConnection.stopConnection(null) ') &&
            //     state != ChatSignalRState.reconnecting) {
            //   emit(ChatSignalRState.reconnecting);
            // }
            else if (level == LogLevel.error &&
                state != ChatSignalRState.reconnecting) {
              emit(ChatSignalRState.reconnecting);
            }
            // debugPrint("");
            print(message);
          },
          accessTokenFactory: () async {
            return "${AppBloc.userCubit.state?.token}";
          },
          // skipNegotiation: true,
          transport: HttpTransportType.longPolling),
      // transport: HttpTransportType.longPolling),
    )
        .withAutomaticReconnect([0, 3000, 5000, 10000, 15000, 30000])
        // .withHubProtocol(JsonHubProtocol())
        .build();
    ////
    if (hubConnection == null) return;
    hubConnection!.on('ReceiveMessage_', receiveMessageHandler);
    if (receiveReadStatusMessageHandler != null) {
      hubConnection!
          .on('ReceiveReadStatusMessage', receiveReadStatusMessageHandler);
    } else {
      hubConnection!.off('ReceiveReadStatusMessage');
    }
    if (receiveDeliveredStatusMessageHandler != null) {
      hubConnection!.on('ReceiveDeliveredStatusMessage',
          receiveDeliveredStatusMessageHandler);
    } else {
      hubConnection!.off('ReceiveDeliveredStatusMessage');
    }
    hubConnection!.serverTimeoutInMilliseconds = 60000;
    // hubConnection!.serverTimeoutInMilliseconds = 360000;
    hubConnection!.keepAliveIntervalInMilliseconds = 10000;
    // hubConnection!.keepAliveIntervalInMilliseconds = 60000;
    hubConnection!.onreconnecting((exception) {
      emit(ChatSignalRState.reconnecting);
    });
    hubConnection!.onreconnected((exception) async {
      emit(ChatSignalRState.reconnected);
      await ChatRepository.ping();
      // await hubConnection!.invoke('PingRequestAsync');
    });
    hubConnection!.onclose((exception) async {
      // debugPrint(exception);
      emit(ChatSignalRState.close);
      if (hubConnection!.state == HubConnectionState.disconnected) {
        await startAsync();
      }
    });
    await startAsync();
    // await hubConnection!.start()?.catchError((onError) {
    //   debugPrint(onError is String ? "unk" : onError.toString());
    // });
  }

  Future<void> sendMessage(String sender, String receiver, int msgId,
      String remoteId, String userName, String message) async {
    if (hubConnection == null) return;

    if (hubConnection!.state == HubConnectionState.disconnected) {
      await startAsync();
    }

    var newMsg = ChatModel(
        id: msgId,
        remoteId: remoteId,
        fromUserId: sender,
        toUserId: receiver,
        message: message,
        createdDate: null);
    await hubConnection!
        .invoke('SendMessageAsync', args: [newMsg.toJson(), userName]);
    // await hubConnection!.invoke('SendMessage', args: [userName, message]);
  }

  Future<void> notifySendDeliveredStatusForAll(List<String> users) async {
    if (hubConnection == null) return;
    if (hubConnection!.state == HubConnectionState.disconnected) {
      await startAsync();
    }

    await hubConnection!
        .invoke('SendDeliveredStatusForUsersAsync', args: [users]);
  }

  Future<void> notifySendReadStatus(String fromUserId) async {
    if (hubConnection == null) return;
    if (hubConnection!.state == HubConnectionState.disconnected) {
      await startAsync();
    }

    await hubConnection!.invoke('SendReadStatusAsync', args: [fromUserId]);
  }

  Future<void> notifySendDeliveredStatus(String fromUserId) async {
    if (hubConnection == null) return;
    if (hubConnection!.state == HubConnectionState.disconnected) {
      await startAsync();
    }

    await hubConnection!.invoke('SendDeliveredStatusAsync', args: [fromUserId]);
  }

  Future<void> notifyReceiptDeliveredStatus() async {
    if (hubConnection == null) return;
    if (hubConnection!.state == HubConnectionState.disconnected) {
      await startAsync();
    }

    await hubConnection!
        .invoke('ReceiptStatusAsync', args: ["SendDeliveredStatus"]);
  }

  Future<void> notifyReceiptReadStatus() async {
    if (hubConnection == null) return;
    if (hubConnection!.state == HubConnectionState.disconnected) {
      await startAsync();
    }

    await hubConnection!.invoke('ReceiptStatusAsync', args: ["SendReadStatus"]);
  }

  void dispose() {
    if (hubConnection == null) return;
    hubConnection!.off('ReceiveReadStatusMessage');
    hubConnection!.off('ReceiveDeliveredStatusMessage');
    hubConnection!.stop();
    hubConnection = null;
  }
}
