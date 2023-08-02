import 'package:dio/dio.dart';

const _accessToken =
    'pk.eyJ1IjoiZGFuaXJleXNhbiIsImEiOiJjbGtsa3c3a2YwY2QyM2xqdGJwaHI2M216In0.OBkGOGkZuTXeh3WicxDFRg';

class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': 'true',
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': 'false',
      'access_token': _accessToken,
    });
    super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);
  }
}
