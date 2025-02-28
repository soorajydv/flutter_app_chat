import 'package:amazetalk_flutter/app_routes.dart';
import 'package:amazetalk_flutter/constants/urls.dart';
import 'package:amazetalk_flutter/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../features/auth/data/datasource/auth_local_data_source.dart';

class DioClient {
  static final DioClient _singleton = DioClient._internal();

  factory DioClient() {
    return _singleton;
  }

  DioClient._internal();

  Dio? _dio;
  final AuthLocalDataSource _authLocalDataSource =
      AuthLocalDataSource(); // Initialize the AuthLocalDataSource

  Dio get dio {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: BACKEND_URL, // Replace with your base URL
        connectTimeout: Duration(seconds: 5), // 5 seconds
        receiveTimeout: Duration(seconds: 3), // 3 seconds
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          return status != null &&
              status < 500; // Accept all statuses below 500
        },
      ));

      // Add interceptors for logging and error handling
      _dio?.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Fetch the token from local storage
          String? token = await _authLocalDataSource.getToken();
          if (token != null) {
            options.headers['Authorization'] =
                'Bearer $token'; // Add token to headers
          }
          print("Requesting: ${options.method} ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode == 401) {
            // Handle unauthorized error
            print("Unauthorized error");
            AppRoutes.go(AppRoutes.login);
          }
          // print("Response: ${response.statusCode} ${response.data}");
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          if (error.response != null) {
            if (error.response?.statusCode == 401) {
              // Handle unauthorized error
              print("Unauthorized errorx");
              if (navigatorKey.currentContext != null) {
                print("Navigator key is not null");
                Navigator.of(navigatorKey.currentContext!)
                    .pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
                return;
                // return handler.resolve(Response(
                //   requestOptions: error.requestOptions,
                //   data: error.response?.data,
                //   statusCode: error.response?.statusCode,
                //   statusMessage: error.response?.statusMessage,
                // ));
              }
              print('No context');
              // AppRoutes.go(AppRoutes.login);
            }

            if (error.response?.statusCode == 400) {
              // Handle unauthorized error
              print("Bad Request ");

              return handler.resolve(Response(
                requestOptions: error.requestOptions,
                data: error.response?.data,
                statusCode: error.response?.statusCode,
                statusMessage: error.response?.statusMessage,
              ));
            }
          }
          print("Error: ${error.message}");
          return handler.next(error); // You can customize error handling here
        },
      ));
    }
    return _dio!;
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await dio.get(path, queryParameters: queryParams);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, {Object? data, Options? options}) async {
    try {
      return await dio.post(path, data: data, options: options);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    try {
      return await dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String path, {Map<String, dynamic>? data}) async {
    try {
      return await dio.delete(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
}
