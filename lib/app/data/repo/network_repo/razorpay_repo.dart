import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/razorpay_model.dart';

class RazorPayRepository {
  final Dio dio = Client().init();
  // RazorPayModel razorpayModel = RazorPayModel();
  Future<ApiResponse<RazorPayModel>> createPayment(
      RazorPayModel razorPayModel) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> response = await dio.postUri(
          Uri.parse('createinitialpayment'),
          options: Options(headers: authHeader),
          data: razorPayModel.toJson());
      if (response.statusCode == 200) {
        final RazorPayModel razorpay = RazorPayModel.fromJson(
            response.data!['result'] as Map<String, dynamic>);
        return ApiResponse<RazorPayModel>.completed(razorpay);
      } else {
        return ApiResponse<RazorPayModel>.error(response.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<RazorPayModel>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<RazorPayModel>.error(e.toString());
    }
  }

  Future<ApiResponse<bool>> verifyOrderPayment(
      String? paymentID, String? signature, String? orderID) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> response = await dio.postUri(
          Uri.parse('verifypayment'),
          options: Options(headers: authHeader),
          data: <String, dynamic>{
            'order_id': orderID,
            'merchant_payment_id': paymentID,
            'merchant_signature': signature
          });
      if (response.statusCode == 200) {
        final bool razorpay = response.data!['success'] as bool;
        return ApiResponse<bool>.completed(razorpay);
      } else {
        return ApiResponse<bool>.error(response.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<bool>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<bool>.error(e.toString());
    }
  }

  Future<ApiResponse<bool>> verifyInitialPayment(
      String? paymentID, String? signature, String? orderID) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> response = await dio.postUri(
          Uri.parse('verifyinitialpayment'),
          options: Options(headers: authHeader),
          data: <String, dynamic>{
            'order_id': orderID,
            'merchant_payment_id': paymentID,
            'merchant_signature': signature
          });
      if (response.statusCode == 200) {
        final bool razorpay = response.data!['success'] as bool;
        return ApiResponse<bool>.completed(razorpay);
      } else {
        return ApiResponse<bool>.error(response.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<bool>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<bool>.error(e.toString());
    }
  }
}
