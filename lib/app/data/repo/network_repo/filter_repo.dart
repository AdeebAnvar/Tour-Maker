import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/package_model.dart';

class FilterRepository {
  final Dio dio = Client().init();
  List<PackageModel> destinationsLis = <PackageModel>[];

  Future<ApiResponse<List<PackageModel>>> getDestination(
      dynamic destination) async {
    try {
      final Map<String, dynamic>? authorHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.get(
          'tours/packages?destination=$destination',
          options: Options(headers: authorHeader));

      if (res.statusCode == 200) {
        destinationsLis =
            (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return PackageModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<PackageModel>>.completed(destinationsLis);
      } else {
        return ApiResponse<List<PackageModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<PackageModel>>> getDomesticTours() async {
    try {
      final Map<String, dynamic>? authorHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.get(
          'tours/packages?domestic=true',
          options: Options(headers: authorHeader));
      if (res.statusCode == 200) {
        destinationsLis =
            (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return PackageModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<PackageModel>>.completed(destinationsLis);
      } else {
        return ApiResponse<List<PackageModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<PackageModel>>> getToursbyBudget(
      String amount) async {
    try {
      final Map<String, dynamic>? authorHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.get(
          'tours/packages?amount=$amount',
          options: Options(headers: authorHeader));
      if (res.statusCode == 200) {
        destinationsLis =
            (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return PackageModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<PackageModel>>.completed(destinationsLis);
      } else {
        return ApiResponse<List<PackageModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<PackageModel>>> getToursByDuration(
      String duration) async {
    try {
      final Map<String, dynamic>? authorHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.get(
          'tours/packages?duration=$duration',
          options: Options(headers: authorHeader));
      if (res.statusCode == 200) {
        destinationsLis =
            (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return PackageModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<PackageModel>>.completed(destinationsLis);
      } else {
        return ApiResponse<List<PackageModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<PackageModel>>> getCategory(dynamic category) async {
    try {
      final Map<String, dynamic>? authorHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.get(
          'tours/packages?category=$category',
          options: Options(headers: authorHeader));
      if (res.statusCode == 200) {
        destinationsLis =
            (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return PackageModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<PackageModel>>.completed(destinationsLis);
      } else {
        return ApiResponse<List<PackageModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }
}
