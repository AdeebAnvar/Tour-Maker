import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/payment_model.dart';
import '../../models/network_models/single_payment_model.dart';

class PaymentRepository {
  List<PaymentModel> bookingList = <PaymentModel>[];
  List<SinglePaymentModel> singleBookingList = <SinglePaymentModel>[];
  final Dio dio = Client().init();
  Future<ApiResponse<List<PaymentModel>>> getAllPayments(
      String paymentStatus) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('user/payment?payment_status=$paymentStatus'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        if (res.data!['result'] != null) {
          bookingList = (res.data!['result'] as List<dynamic>).map((dynamic e) {
            return PaymentModel.fromJson(e as Map<String, dynamic>);
          }).toList();
          return ApiResponse<List<PaymentModel>>.completed(bookingList);
        }
        return ApiResponse<List<PaymentModel>>.completed(bookingList);
      } else {
        return ApiResponse<List<PaymentModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PaymentModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PaymentModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<SinglePaymentModel>>> getSinglePayment(int id) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('user/payment?id=$id'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        if (res.data!['result'] != null) {
          singleBookingList =
              (res.data!['result'] as List<dynamic>).map((dynamic e) {
            return SinglePaymentModel.fromJson(e as Map<String, dynamic>);
          }).toList();
          return ApiResponse<List<SinglePaymentModel>>.completed(
              singleBookingList);
        }
        return ApiResponse<List<SinglePaymentModel>>.completed(
            singleBookingList);
      } else {
        return ApiResponse<List<SinglePaymentModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<SinglePaymentModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<SinglePaymentModel>>.error(e.toString());
    }
  }
}
