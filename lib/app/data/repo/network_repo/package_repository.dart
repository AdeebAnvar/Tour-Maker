import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/package_model.dart';

class PackageRepository {
  final Dio dio = Client().init();
  List<PackageModel> packageList = <PackageModel>[];
  Future<ApiResponse<List<PackageModel>>> getAllPackages() async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<dynamic> res = await dio.getUri(
          Uri.parse('tours/packages'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        packageList = (res.data['result'] as List<dynamic>).map(
          (dynamic e) {
            return PackageModel.fromJson(e as Map<String, dynamic>);
          },
        ).toList();

        return ApiResponse<List<PackageModel>>.completed(packageList);
      } else {
        return ApiResponse<List<PackageModel>>.error(res.statusMessage);
      }
    } on DioError catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }
}
