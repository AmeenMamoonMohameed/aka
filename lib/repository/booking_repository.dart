import 'package:flutter/material.dart';
import 'package:akarak/api/api.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/models/model.dart';

class BookingRepository {
  static Future<List?> loadBookingForm(id) async {
    final response = await Api.requestBookingForm({'resource_id': id});
    if (response.succeeded) {
      late BookingStyleModel bookingStyle;
      switch (response.data['type']) {
        case 'standard':
          bookingStyle = StandardBookingModel.fromJson(response.data);
          break;
        case 'daily':
          bookingStyle = DailyBookingModel.fromJson(response.data);
          break;
        case 'hourly':
          bookingStyle = HourlyBookingModel.fromJson(response.data);
          break;
        case 'table':
          bookingStyle = TableBookingModel.fromJson(response.data);
          break;
        case 'slot':
          bookingStyle = SlotBookingModel.fromJson(response.data);
          break;
        default:
          bookingStyle = StandardBookingModel(
            startDate: DateTime.now(),
            startTime: const TimeOfDay(
              hour: 0,
              minute: 0,
            ),
          );
          break;
      }
      return [bookingStyle, BookingPaymentModel.fromJson(response.payment)];
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return null;
  }

  static Future<String?> calcPrice(Map<String, dynamic> params) async {
    final response = await Api.requestPrice(params);
    if (response.succeeded) {
      return response.attr['total_display'];
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return null;
  }

  static Future<ResultApiModel> order(Map<String, dynamic> params) async {
    final response = await Api.requestOrder(params);
    if (response.succeeded) {
      String? url;
      switch (params['payment_method']) {
        case 'paypal':
          url = response.payment['links'][1]['href'];
          break;
        case 'stripe':
          url = response.payment['url'];
          break;
      }
      return ResultApiModel.fromJson({'success': true, 'data': url});
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return response;
  }

  static Future<List?> loadList({
    String? keyword,
    int? page,
    int? perPage,
    SortModel? sort,
    SortModel? status,
  }) async {
    Map<String, dynamic> params = {
      "currentPage": page,
      "pageSize": perPage,
      "s": keyword,
    };
    if (sort != null) {
      params['orderby'] = sort.field;
      params['order'] = sort.value;
    }
    if (status != null) {
      params['post_status'] = status.value;
    }
    final response = await Api.requestBookingList(params);
    if (response.succeeded) {
      final list = List.from(response.data ?? []).map((item) {
        return BookingItemModel.fromJson(item);
      }).toList();

      final listSort = List.from(response.attr['sort'] ?? []).map((item) {
        return SortModel.fromJson(item);
      }).toList();

      final listStatus = List.from(response.attr['status'] ?? []).map((item) {
        return SortModel.fromJson(item);
      }).toList();

      return [list, response.pagination, listSort, listStatus];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  static Future<BookingItemModel?> loadDetail(int id) async {
    final params = {'id': id};
    final response = await Api.requestBookingDetail(params);
    if (response.succeeded) {
      return BookingItemModel.fromJson(response.data);
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return null;
  }

  static Future<BookingItemModel?> cancel(int id) async {
    final params = {'id': id};
    final response = await Api.requestBookingCancel(params);
    if (response.succeeded) {
      return BookingItemModel.fromJson(response.data);
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return null;
  }
}
