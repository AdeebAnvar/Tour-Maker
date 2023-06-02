import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/order_model.dart';
import '../../models/network_models/order_payment_model.dart';
import '../../models/network_models/single_traveller_model.dart';
import '../../models/network_models/travellers_model.dart';

class PassengerRepository {
  SingleTravellerModel passengerList = SingleTravellerModel();
  List<TravellersModel> passengers = <TravellersModel>[];
  final Dio dio = Client().init();
  Future<ApiResponse<int>> addOrder(OrderModel om) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.postUri(
          Uri.parse('user/order'),
          data: om.toJson(),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        return ApiResponse<int>.completed(res.data!['order_id'] as int);
      } else {
        return ApiResponse<int>.error(res.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<int>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<int>.error(e.toString());
    }
  }

  Future<ApiResponse<OrderPaymentModel>> createPayment(
      OrderPaymentModel orderPaymentModel) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> response = await dio.postUri(
          Uri.parse('createpayment'),
          data: orderPaymentModel.toJson(),
          options: Options(headers: authHeader));
      if (response.statusCode == 200) {
        final OrderPaymentModel razorpay = OrderPaymentModel.fromJson(
            response.data!['result'] as Map<String, dynamic>);
        return ApiResponse<OrderPaymentModel>.completed(razorpay);
      } else {
        return ApiResponse<OrderPaymentModel>.error(response.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<OrderPaymentModel>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<OrderPaymentModel>.error(e.toString());
    }
  }

  Future<ApiResponse<OrderPaymentModel>> createAdvancePayment(
      OrderPaymentModel orderPaymentModel) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> response = await dio.postUri(
          Uri.parse('createpayment?payment_type=advance'),
          data: orderPaymentModel.toJson(),
          options: Options(headers: authHeader));

      if (response.statusCode == 200) {
        final OrderPaymentModel razorpay = OrderPaymentModel.fromJson(
            response.data!['result'] as Map<String, dynamic>);
        return ApiResponse<OrderPaymentModel>.completed(razorpay);
      } else {
        return ApiResponse<OrderPaymentModel>.error(response.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<OrderPaymentModel>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<OrderPaymentModel>.error(e.toString());
    }
  }

  Future<ApiResponse<OrderPaymentModel>> createRemainingAmountPayment(
      OrderPaymentModel orderPaymentModel) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> response = await dio.postUri(
          Uri.parse('createpayment?payment_type=remaining'),
          data: orderPaymentModel.toJson(),
          options: Options(headers: authHeader));
      if (response.statusCode == 200) {
        final OrderPaymentModel razorpay = OrderPaymentModel.fromJson(
            response.data!['result'] as Map<String, dynamic>);
        return ApiResponse<OrderPaymentModel>.completed(razorpay);
      } else {
        return ApiResponse<OrderPaymentModel>.error(response.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<OrderPaymentModel>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<OrderPaymentModel>.error(e.toString());
    }
  }

  Future<ApiResponse<bool>> verifyPayment(
    String? mpaymentID,
    String? msignature,
    String? orderID,
  ) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> response = await dio.postUri(
          Uri.parse('verifypayment'),
          options: Options(headers: authHeader),
          data: <String, dynamic>{
            'order_id': orderID,
            'merchant_payment_id': mpaymentID,
            'merchant_signature': msignature
          });
      if (response.statusCode == 200) {
        final bool razorpay = response.data!['success'] as bool;
        return ApiResponse<bool>.completed(razorpay);
      } else {
        return ApiResponse<bool>.error(response.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<bool>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<bool>.error(e.toString());
    }
  }

  Future<ApiResponse<bool>> addpassenger(String? name, String? phoneNumber,
      String? orderID, String? dob, String? address) async {
    try {
      final Map<String, dynamic>? authHeader =
          await Client().getMultiPartAuthHeader();
      final FormData formData = FormData.fromMap(<String, dynamic>{
        'name': name,
        'phone_number': phoneNumber,
        'date_of_birth': dob,
        'address': address,
        'order_id': orderID,
        // // 'image': await MultipartFile.fromFile(
        // //   fullPath,
        //   contentType: MediaType('image', 'jpeg'),
        // ),
      });
      final Response<Map<String, dynamic>> response = await dio.postUri(
          Uri.parse('user/traveller'),
          options: Options(headers: authHeader),
          data: formData);
      if (response.statusCode == 200) {
        final bool razorpay = response.data!['success'] as bool;
        return ApiResponse<bool>.completed(razorpay);
      } else {
        return ApiResponse<bool>.error(response.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<bool>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<bool>.error(e.toString());
    }
  }

  Future<ApiResponse<List<TravellersModel>>> getAllPassengersByOrderId(
      int orderId) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();

      final Response<Map<String, dynamic>> response = await dio.getUri(
        Uri.parse('user/traveller?order_id=$orderId'),
        options: Options(headers: authHeader),
      );
      if (response.statusCode == 200) {
        passengers =
            (response.data!['result'] as List<dynamic>).map((dynamic e) {
          return TravellersModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<TravellersModel>>.completed(passengers);
      } else {
        return ApiResponse<List<TravellersModel>>.error(response.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<List<TravellersModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<TravellersModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<TravellersModel>>> getSinglePassenger(int id) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();

      final Response<Map<String, dynamic>> response = await dio.getUri(
        Uri.parse('user/traveller?id=$id'),
        options: Options(headers: authHeader),
      );
      if (response.statusCode == 200) {
        passengers =
            (response.data!['result'] as List<dynamic>).map((dynamic e) {
          return TravellersModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<TravellersModel>>.completed(passengers);
      } else {
        return ApiResponse<List<TravellersModel>>.error(response.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<List<TravellersModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<TravellersModel>>.error(e.toString());
    }
  }

  // Future<ApiResponse<dynamic>> getadhar(String name, int id) async {
  //   try {
  //     final Map<String, dynamic>? authHeader = await Client().getAuthHeader();

  //     final Response<Map<String, dynamic>> response = await dio.postUri(
  //       Uri.parse('user/traveller/aadhar'),
  //       data: <String, dynamic>{'name': name, 'order_id': id},
  //       options: Options(headers: authHeader),
  //     );
  //     if (response.statusCode == 200) {
  //       return ApiResponse<dynamic>.completed(response.data!['result']);
  //     } else {
  //       return ApiResponse<dynamic>.error(response.statusMessage);
  //     }
  //   } on DioError catch (de) {
  //     return ApiResponse<dynamic>.error(de.error.toString());
  //   } catch (e) {
  //     return ApiResponse<dynamic>.error(e.toString());
  //   }
  // }
}
