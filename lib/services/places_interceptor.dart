import 'package:dio/dio.dart';

const accessToken =
    'pk.eyJ1IjoiZGFuaXJleXNhbiIsImEiOiJjbGtsa3c3a2YwY2QyM2xqdGJwaHI2M216In0.OBkGOGkZuTXeh3WicxDFRg';

class PlacesInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token': accessToken,
      'language': 'es',
    });
    super.onRequest(options, handler);
  }
}
