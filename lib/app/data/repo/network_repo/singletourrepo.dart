import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/single_tour_model.dart';

class SingleTourRepository {
  SingleTourModel tourData = SingleTourModel();
  List<PackageData> individualTours = <PackageData>[];
  final Dio dio = Client().init();
  Future<ApiResponse<SingleTourModel>> getSingleTour(int id, int page) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('tours/packages/$id?option=batch&page=$page'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        tourData = SingleTourModel.fromJson(
            res.data!['result'] as Map<String, dynamic>);

        return ApiResponse<SingleTourModel>.completed(tourData);
      } else {
        return ApiResponse<SingleTourModel>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<SingleTourModel>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<SingleTourModel>.error(e.toString());
    }
  }

  Future<ApiResponse<SingleTourModel>> getSingleTourIndividual(
      int id, int page) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('tours/packages/$id?option=individual&page=$page'),
          options: Options(headers: authHeader));

      if (res.statusCode == 200) {
        final SingleTourModel customDepartureToures = SingleTourModel.fromJson(
            res.data!['result'] as Map<String, dynamic>);

        log('Adeeb rep res statusge ${customDepartureToures.packageData!}');
        // if (customDepartureToures.packageData != null) {
        //   individualTours = customDepartureToures.packageData!;
        // } else {
        //   individualTours = <PackageData>[];
        // }
        // individualTours = customDepartureToures.packageData!;
        return ApiResponse<SingleTourModel>.completed(customDepartureToures);

        // if (res.data!['result'] != null) {
        //   final SingleTourModel customDepartureToures =
        //       SingleTourModel.fromJson(
        //           res.data!['result'] as Map<String, dynamic>);

        //   log('Adeeb rep res statusge ${customDepartureToures.packageData!}');

        //   individualTours = customDepartureToures.packageData!;
        //   return ApiResponse<SingleTourModel>.completed(individualTours);
        // } else {
        //   return ApiResponse<SingleTourModel>.completed(res.da);
        // }
      } else {
        return ApiResponse<SingleTourModel>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<SingleTourModel>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<SingleTourModel>.error(e.toString());
    }
  }
}
