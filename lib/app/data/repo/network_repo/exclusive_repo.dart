import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/exclusivetour_model.dart';
import '../../models/network_models/single_exclusive_tour_model.dart';

class ExclusiveTourRepository {
  List<ExclusiveToursModel> exclusiveToursList = <ExclusiveToursModel>[];
  List<SingleExclusiveTourModel> singleexclusiveToursList =
      <SingleExclusiveTourModel>[];

  final Dio dio = Client().init();

  Future<ApiResponse<List<ExclusiveToursModel>>> getAllExclusiveTours() async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('tours/exclusive'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        exclusiveToursList =
            (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return ExclusiveToursModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<ExclusiveToursModel>>.completed(
            exclusiveToursList);
      } else {
        return ApiResponse<List<ExclusiveToursModel>>.error(res.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<List<ExclusiveToursModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<ExclusiveToursModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<SingleExclusiveTourModel>>>
      getAllSingleExclusiveTours(String destination) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('tours/packages?exclusive=$destination'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        singleexclusiveToursList =
            (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return SingleExclusiveTourModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<SingleExclusiveTourModel>>.completed(
            singleexclusiveToursList);
      } else {
        return ApiResponse<List<SingleExclusiveTourModel>>.error(
            res.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<List<SingleExclusiveTourModel>>.error(
          de.error.toString());
    } catch (e) {
      return ApiResponse<List<SingleExclusiveTourModel>>.error(e.toString());
    }
  }
}
