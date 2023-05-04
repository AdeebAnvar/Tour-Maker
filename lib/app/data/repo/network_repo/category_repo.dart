import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/category_model.dart';
import '../../models/network_models/package_model.dart';

class CategoryRepository {
  List<CategoryModel> categoryList = <CategoryModel>[];
  List<PackageModel> singleCategoryList = <PackageModel>[];
  final Dio dio = Client().init();
  Future<ApiResponse<List<CategoryModel>>> getAllCategory() async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('tours/categories'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        categoryList = (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return CategoryModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<CategoryModel>>.completed(categoryList);
      } else {
        return ApiResponse<List<CategoryModel>>.error(res.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<List<CategoryModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<CategoryModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<PackageModel>>> getCategorybycategoryName(
      dynamic categoryname) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> response = await dio.getUri(
          Uri.parse('tours/packages?category=$categoryname'),
          options: Options(headers: authHeader));
      if (response.statusCode == 200) {
        if (response.data!['result'] != null) {
          singleCategoryList =
              (response.data!['result'] as List<dynamic>).map((dynamic e) {
            return PackageModel.fromJson(e as Map<String, dynamic>);
          }).toList();
        }

        return ApiResponse<List<PackageModel>>.completed(singleCategoryList);
      } else {
        return ApiResponse<List<PackageModel>>.error(response.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }
}
