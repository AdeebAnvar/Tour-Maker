import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/suggest_a_friend.dart';

class SuggestAFriendRepo {
  final Dio dio = Client().init();

  Future<ApiResponse<Map<String, dynamic>>> suggestAFriend({
    ReferAFriend? referAFriend,
  }) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.postUri(
          Uri.parse('user/referrals'),
          data: referAFriend!.toJson(),
          options: Options(headers: authHeader));
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
}
