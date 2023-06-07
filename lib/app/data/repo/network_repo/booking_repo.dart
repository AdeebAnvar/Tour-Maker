import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/booking_model.dart';
import '../../models/network_models/single_booking_model.dart';

class BookingRepository {
  List<BookingsModel> bookingList = <BookingsModel>[];
  List<SingleBookingModel> singleBookingList = <SingleBookingModel>[];
  final Dio dio = Client().init();
  Future<ApiResponse<List<BookingsModel>>> getAllBookings(
      String bookingStatus) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('user/order?order_status=$bookingStatus'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        bookingList = (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return BookingsModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<BookingsModel>>.completed(bookingList);
      } else {
        return ApiResponse<List<BookingsModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<BookingsModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<BookingsModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<SingleBookingModel>>> getSingleBooking(int id) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('user/order?id=$id'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        singleBookingList =
            (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return SingleBookingModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<SingleBookingModel>>.completed(
            singleBookingList);
      } else {
        return ApiResponse<List<SingleBookingModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<SingleBookingModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<SingleBookingModel>>.error(e.toString());
    }
  }
}
