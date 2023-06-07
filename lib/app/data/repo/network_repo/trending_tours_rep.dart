import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/package_model.dart';
import '../../models/network_models/single_trenidng_tour_model.dart';
import '../../models/network_models/trending_tours.dart';

class TrendingToursRepository {
  List<TrendingToursModel> trndingToursList = <TrendingToursModel>[];
  List<PackageModel> packageToursList = <PackageModel>[];
  List<SingleTrendingToursModel> singleTour = <SingleTrendingToursModel>[];
  final Dio dio = Client().init();

  Future<ApiResponse<List<TrendingToursModel>>> getAllTrendingTours() async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('tours/trending'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        trndingToursList =
            (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return TrendingToursModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<TrendingToursModel>>.completed(
            trndingToursList);
      } else {
        return ApiResponse<List<TrendingToursModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<TrendingToursModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<TrendingToursModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<SingleTrendingToursModel>>> getSingleTrendingTours(
      String name, int page) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('tours/trending?destination=$name&page=$page'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        singleTour = (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return SingleTrendingToursModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<SingleTrendingToursModel>>.completed(
            singleTour);
      } else {
        return ApiResponse<List<SingleTrendingToursModel>>.error(
            res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<SingleTrendingToursModel>>.error(
          de.error.toString());
    } catch (e) {
      return ApiResponse<List<SingleTrendingToursModel>>.error(e.toString());
    }
  }
}
