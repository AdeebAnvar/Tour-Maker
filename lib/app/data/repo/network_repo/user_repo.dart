import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/user_model.dart';

class UserRepository {
  List<String> getStates() => states;
  List<UserModel> userModelList = <UserModel>[];
  final Dio dio = Client().init();
  GetStorage storage = GetStorage();
  UserModel? userModel;
  Future<ApiResponse<Map<String, dynamic>>> checkUserExists() async {
    final dynamic token = await storage.read('token');
    try {
      final Response<Map<String, dynamic>> response = await dio.getUri(
        Uri.parse('user/profile'),
        options: Options(
          headers: <String, dynamic>{
            HttpHeaders.authorizationHeader: 'Bearer $token'
          },
        ),
      );

      if (response.statusCode == 200) {
        return ApiResponse<Map<String, dynamic>>.completed(
            response.data!['result'] as Map<String, dynamic>);
      } else {
        return ApiResponse<Map<String, dynamic>>.error(
            response.statusMessage.toString());
      }
    } on DioException catch (d) {
      return ApiResponse<Map<String, dynamic>>.error(d.message);
    } catch (ex) {
      return ApiResponse<Map<String, dynamic>>.error(ex.toString());
    }
  }

  Future<ApiResponse<UserModel>> getUserDetails() async {
    final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
    try {
      final Response<Map<String, dynamic>> response = await dio.getUri(
        Uri.parse('user/profile'),
        options: Options(headers: authHeader),
      );
      if (response.statusCode == 200) {
        final UserModel user = UserModel.fromJson(
            response.data!['result'] as Map<String, dynamic>);
        return ApiResponse<UserModel>.completed(user);
      } else {
        return ApiResponse<UserModel>.error(response.statusMessage.toString());
      }
    } on DioException catch (d) {
      log(d.message.toString());
      log(d.error.toString());
      log(d.response.toString());
      return ApiResponse<UserModel>.error(d.message);
    } catch (ex) {
      log(ex.toString());
      return ApiResponse<UserModel>.error(ex.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> signUpTheUser(
      String tAndCStatusOfUser) async {
    try {
      final Map<String, dynamic>? autheHeader = await Client().getAuthHeader();
      final FormData formData = FormData.fromMap(<String, dynamic>{
        't_and_c_status': tAndCStatusOfUser,
      });
      final Response<Map<String, dynamic>> res = await dio.postUri(
          Uri.parse('user/signup'),
          options: Options(headers: autheHeader),
          data: formData);
      if (res.statusCode == 200) {
        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>.error(e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> loginTheUser(UserModel um) async {
    try {
      final Map<String, dynamic>? autheHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.postUri(
        Uri.parse('user/signup'),
        options: Options(headers: autheHeader),
        data: um.toJson(),
      );
      if (res.statusCode == 200) {
        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>.error(e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> addUserProfilePic(
      String path, String fullPath) async {
    try {
      final Map<String, dynamic>? authHeader =
          await Client().getMultiPartAuthHeader();

      final FormData formData = FormData.fromMap(<String, dynamic>{
        'image': await MultipartFile.fromFile(
          fullPath, contentType: MediaType('image', 'jpeg'), //important
        ),
      });
      final Response<Map<String, dynamic>> res = await dio.put(
        'user/updateuser',
        options: Options(headers: authHeader),
        data: formData,
      );
      if (res.statusCode == 200) {
        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>.error(e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> updateUser(
      {String? categoryOFuser,
      String? districtOFuser,
      String? emailOFuser,
      String? genderOFuser,
      String? nameOFuser,
      String? stateOFuser,
      String? phoneNumberOfuser,
      String? addressOFuser,
      String? enterpriseNameOFuser,
      String? tAndCStatusOfUser,
      String? countryOFuser}) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final FormData formData = FormData.fromMap(<String, dynamic>{
        'address': addressOFuser,
        'category': categoryOFuser,
        'country': countryOFuser,
        'district': districtOFuser,
        'email': emailOFuser,
        'enterprise_name': enterpriseNameOFuser,
        'gender': genderOFuser,
        'name': nameOFuser,
        'phone_number': phoneNumberOfuser,
        'state': stateOFuser,
        't_and_c_status': tAndCStatusOfUser,
      });
      final Response<Map<String, dynamic>> res = await dio.putUri(
        Uri.parse('user/updateuser'),
        options: Options(headers: authHeader),
        data: formData,
      );
      if (res.statusCode == 200) {
        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>.error(e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> postFCMToken(
      String fcmToken) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.postUri(
        Uri.parse('fcmtoken'),
        options: Options(headers: authHeader),
        data: <String, dynamic>{'fcm_token': fcmToken},
      );
      if (res.statusCode == 200) {
        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>.error(e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> putFCMToken(String fcmToken) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.putUri(
        Uri.parse('fcmtoken'),
        options: Options(headers: authHeader),
        data: <String, dynamic>{'fcm_token': fcmToken},
      );
      log('jnofvn $fcmToken');
      if (res.statusCode == 200) {
        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>.error(e.toString());
    }
  }

  final List<String> states = <String>[
    'Select State',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttarakhand',
    'Uttar Pradesh',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Delhi',
    'Lakshadweep',
    'Puducherry',
  ];
}
