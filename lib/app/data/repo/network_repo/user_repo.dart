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
    log('tok in rep $token ');
    try {
      final Response<Map<String, dynamic>> response = await dio.getUri(
        Uri.parse('user/profile'),
        options: Options(
          headers: <String, dynamic>{
            HttpHeaders.authorizationHeader: 'Bearer $token'
          },
        ),
      );
      log('checkUserExists ${response.statusMessage}');
      // final Response<Map<String, dynamic>> res =
      //     response.data!['result'] as Response<Map<String, dynamic>>;
      if (response.statusCode == 200) {
        return ApiResponse<Map<String, dynamic>>.completed(
            response.data!['result'] as Map<String, dynamic>);
        // log('sts code');
        // final data = response.data!['result'];
        // log('dsdsd code ${data}');
        // if (response.data!['result'].isBlank != true ||
        //     response.data!['result'] != null) {
        //   log('isblank');
        //   // userModelList =
        //   //     (response.data!['result'] as List<dynamic>).map((dynamic e) {
        //   //   return UserModel.fromjson(e as Map<String, String>);
        //   // }).toList();

        // } else {
        //   log('log  s ${response.statusMessage}');

        //   return ApiResponse<Map<String, dynamic>>.error(
        //       response.statusMessage);
        // }
        // // return ApiResponse<bool>.completed(
        // //   response.data as bool,
        // // );
      } else {
        log('else');

        return ApiResponse<Map<String, dynamic>>.error(
            response.statusMessage.toString());
      }
    } on DioError catch (d) {
      return ApiResponse<Map<String, dynamic>>.error(d.message);
    } catch (ex) {
      return ApiResponse<Map<String, dynamic>>.error(ex.toString());
    }
  }

  Future<ApiResponse<UserModel>> getUserDetails() async {
    final dynamic token = await storage.read('token');
    log('tok in rep $token ');
    log('repo');
    final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
    try {
      final Response<Map<String, dynamic>> response = await dio.getUri(
        Uri.parse('user/profile'),
        options: Options(headers: authHeader),
      );
      log('getUserDetails ${response.statusMessage}');

      // final Response<Map<String, dynamic>> res =
      //     response.data!['result'] as Response<Map<String, dynamic>>;
      if (response.statusCode == 200) {
        log('sts code');
        final UserModel user = UserModel.fromJson(
            response.data!['result'] as Map<String, dynamic>);
        // log('adeeb rep ${response.}');
        return ApiResponse<UserModel>.completed(user);
      } else {
        return ApiResponse<UserModel>.error(response.statusMessage.toString());
      }
    } on DioError catch (d) {
      return ApiResponse<UserModel>.error(d.message);
    } catch (ex) {
      return ApiResponse<UserModel>.error(ex.toString());
    }
  }

  // userDataList = (res.data!['result'] as List<dynamic>).map((dynamic e) {
  //         return UserModel.fromjson(e as Map<String, String>);

  Future<ApiResponse<Map<String, dynamic>>> signUpTheUser(
      String tAndCStatusOfUser) async {
    try {
      final Map<String, dynamic>? autheHeader = await Client().getAuthHeader();
      log('auth hre $autheHeader');
      final FormData formData = FormData.fromMap(<String, dynamic>{
        't_and_c_status': tAndCStatusOfUser,
      });
      final Response<Map<String, dynamic>> res = await dio.postUri(
          Uri.parse('user/signup'),
          options: Options(headers: autheHeader),
          data: formData);
      log('signUpTheUser ${res.statusMessage}');

      if (res.statusCode == 200) {
        log('200 ${res.statusMessage}');

        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        log('adb');
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioError catch (de) {
      log('jnijk');
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      log('fgs');
      return ApiResponse<Map<String, dynamic>>.error(e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> loginTheUser(UserModel um) async {
    try {
      final Map<String, dynamic>? autheHeader = await Client().getAuthHeader();
      log('auth hre $autheHeader');
      // final FormData formData = FormData.fromMap(<String, dynamic>{
      //   'name': name,
      //   'phone_number': phoneNumber,
      //   'state': state,
      //   // 'category': category
      // });
      final Response<Map<String, dynamic>> res = await dio.postUri(
        Uri.parse('user/signup'),
        options: Options(headers: autheHeader),
        data: um.toJson(),
      );
      log('signUpTheUser ${res.statusMessage}');

      if (res.statusCode == 200) {
        log('200');

        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        log('adb');
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioError catch (de) {
      log('jnijk');
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      log('fgs');
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
      log('huigyuyugyuhb n$fullPath');
      log('for data ${formData.files}');
      final Response<Map<String, dynamic>> res = await dio.put(
        'user/updateuser',
        options: Options(headers: authHeader),
        data: formData,
      );
      log('KGF ROCKY BHAAI ${res.data}');
      if (res.statusCode == 200) {
        log('200');
        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        log('adb');
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioError catch (de) {
      log('jnijk err ${de.error}');
      log('jnijk msg ${de.message}');
      log('jnijk opt ${de.requestOptions}');
      log('jnijk resp ${de.response}');
      log('jnijk stktrc ${de.stackTrace}');
      log('jnijk type ${de.type}');
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      log('fgs');
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
      log('auth hre $authHeader');
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
      log('repo updateuser msg ${res.statusMessage}');
      log('repo updateuser code ${res.statusCode}');

      if (res.statusCode == 200) {
        log('200');
        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        log('adb');
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioError catch (de) {
      log('repo updateuser de error ${de.error}');
      log('repo updateuserde eror mess ${de.message}');
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      log('fgs');
      log('repo updaeuser code $e');
      return ApiResponse<Map<String, dynamic>>.error(e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> postFCMToken(
      String fcmToken) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      log('auth hre $authHeader');

      final Response<Map<String, dynamic>> res = await dio.postUri(
        Uri.parse('fcmtoken'),
        options: Options(headers: authHeader),
        data: <String, dynamic>{'fcm_token': fcmToken},
      );
      if (res.statusCode == 200) {
        log('200');
        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        log('adb');
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioError catch (de) {
      log('jnijk');
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      log('fgs');
      return ApiResponse<Map<String, dynamic>>.error(e.toString());
    }
  }

  // ignore: always_specify_types
  Future<ApiResponse<Map<String, dynamic>>> putFCMToken(var fcmToken) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      log('auth hre $authHeader');

      final Response<Map<String, dynamic>> res = await dio.putUri(
        Uri.parse('fcmtoken'),
        options: Options(headers: authHeader),
        data: <String, dynamic>{'fcm_token': fcmToken},
      );
      if (res.statusCode == 200) {
        log('200');
        return ApiResponse<Map<String, dynamic>>.completed(res.data);
      } else {
        log('adb');
        return ApiResponse<Map<String, dynamic>>.error(res.statusMessage);
      }
    } on DioError catch (de) {
      log('jnijk');
      return ApiResponse<Map<String, dynamic>>.error(de.error.toString());
    } catch (e) {
      log('fgs');
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
