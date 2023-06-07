import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/destinations_model.dart';

class DestinationRepository {
  final Dio dio = Client().init();
  List<DestinationsModel> destinationsList = <DestinationsModel>[];

  Future<ApiResponse<List<DestinationsModel>>> getAllDestinations() async {
    try {
      final Map<String, dynamic>? authorHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio
          .get('tours/destination', options: Options(headers: authorHeader));
      if (res.statusCode == 200) {
        destinationsList =
            (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return DestinationsModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<DestinationsModel>>.completed(destinationsList);
      } else {
        return ApiResponse<List<DestinationsModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<DestinationsModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<DestinationsModel>>.error(e.toString());
    }
  }
}
