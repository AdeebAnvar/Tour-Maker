import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class DioConnectivityRequestRetryer {
  DioConnectivityRequestRetryer({
    required this.dio,
    required this.connectivity,
  });

  final Dio dio;
  final Connectivity connectivity;

  Future<Response<dynamic>> scheduleRequestRetry(
      RequestOptions requestOptions) async {
    StreamSubscription<dynamic>? streamSubscription;
    final Completer<Response<dynamic>> responseCompleter =
        Completer<Response<dynamic>>();
    streamSubscription = connectivity.onConnectivityChanged.listen(
      (ConnectivityResult connectivityResult) {
        if (connectivityResult != ConnectivityResult.none) {
          streamSubscription?.cancel();
          responseCompleter.complete(
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              options: Options(
                method: requestOptions.method,
                headers: requestOptions.headers,
                extra: requestOptions.extra,
                responseType: requestOptions.responseType,
                contentType: requestOptions.contentType,
                validateStatus: requestOptions.validateStatus,
                receiveDataWhenStatusError:
                    requestOptions.receiveDataWhenStatusError,
                followRedirects: requestOptions.followRedirects,
                maxRedirects: requestOptions.maxRedirects,
                requestEncoder: requestOptions.requestEncoder,
                responseDecoder: requestOptions.responseDecoder,
                listFormat: requestOptions.listFormat,
                sendTimeout: requestOptions.sendTimeout,
                receiveTimeout: requestOptions.receiveTimeout,
              ),
            ),
          );
        }
      },
    );
    return responseCompleter.future;
  }
}
