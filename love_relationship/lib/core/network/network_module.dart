import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:love_relationship/core/config/app_config.dart';
import 'package:love_relationship/core/network/auth_interceptor.dart';
import 'package:love_relationship/core/network/rest_api.dart';
import 'package:love_relationship/features/auth/domain/repositories/auth_repository.dart';

/// Módulo de rede responsável por configurar Dio e RestClient (Retrofit).
/// A baseUrl é obtida do AppConfig conforme o flavor (dev, qa, prod).
class NetworkModule {
  static Dio? _dioInstance;
  static RestClient? _restClientInstance;
  static AuthRepository? _authRepository;

  /// Configura o AuthRepository para o interceptor. Chamar antes de getRestClientInstance.
  static void configureAuth(AuthRepository authRepository) {
    _authRepository = authRepository;
  }

  static RestClient getRestClientInstance() {
    return _restClientInstance ?? _provideRestClient();
  }

  static Dio getDioInstance() {
    return _dioInstance ?? _provideDio();
  }

  static RestClient _provideRestClient() {
    final baseUrl = _getBaseUrl();
    if (kDebugMode) {
      log('NetworkModule: Criando RestClient com baseUrl: $baseUrl');
    }
    final rest = RestClient(_getDioInstance(), baseUrl: baseUrl);
    _restClientInstance = rest;
    return rest;
  }

  static Dio _getDioInstance() {
    return _dioInstance ?? _provideDio();
  }

  static String _getBaseUrl() {
    var baseUrl = AppConfig.instance.baseUrl.trim();
    while (baseUrl.endsWith('/') || baseUrl.endsWith('.')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    if (kDebugMode) {
      log('NetworkModule: BaseUrl: $baseUrl');
    }
    return baseUrl;
  }

  static Dio _provideDio() {
    final config = AppConfig.instance;
    final dioInstance = Dio();

    _dioInstance = dioInstance;

    dioInstance
      ..options.connectTimeout = config.connectionTimeout
      ..options.receiveTimeout = config.receiveTimeout
      ..interceptors.add(
        LogInterceptor(
          request: kDebugMode,
          responseBody: kDebugMode,
          requestBody: kDebugMode,
          requestHeader: kDebugMode,
          error: true,
          responseHeader: false,
          logPrint: (obj) => log(obj.toString()),
        ),
      );

    if (_authRepository != null) {
      dioInstance.interceptors.add(AuthInterceptor(_authRepository!));
    }

    dioInstance.interceptors.add(
        InterceptorsWrapper(
          onRequest: (
            RequestOptions options,
            RequestInterceptorHandler handler,
          ) async {
            return handler.next(options);
          },
          onResponse: (
            Response response,
            ResponseInterceptorHandler handler,
          ) async {
            if (response.data == null || response.data == '') {
              response.data = <String, dynamic>{};
            }
            return handler.next(response);
          },
          onError: (
            DioException error,
            ErrorInterceptorHandler handler,
          ) async {
            return handler.next(error);
          },
        ),
      );

    return dioInstance;
  }

  /// Libera recursos (útil para testes)
  static void reset() {
    _dioInstance = null;
    _restClientInstance = null;
    _authRepository = null;
  }
}
