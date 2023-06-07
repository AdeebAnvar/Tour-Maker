import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/wishlist_model.dart';

class WishListRepo {
  final Dio dio = Client().init();
  List<WishListModel> wishList = <WishListModel>[];

  Future<ApiResponse<List<WishListModel>>> getAllFav() async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('user/favourites'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        if (res.data!['result'] != null) {
          wishList = (res.data!['result'] as List<dynamic>).map((dynamic e) {
            return WishListModel.fromJson(e as Map<String, dynamic>);
          }).toList();
          return ApiResponse<List<WishListModel>>.completed(wishList);
        } else {
          return ApiResponse<List<WishListModel>>.completed(wishList);
        }
      } else {
        return ApiResponse<List<WishListModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<WishListModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<WishListModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> createFav(int? id) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.postUri(
          Uri.parse('user/create_favourites'),
          data: <String, dynamic>{'tour_id': id},
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

  Future<ApiResponse<Map<String, dynamic>>> deleteFav(int? id) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.deleteUri(
          Uri.parse('user/delete_favourites?tour_id=$id'),
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
