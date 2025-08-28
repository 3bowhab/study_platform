import 'dart:io';
import 'package:dio/dio.dart';
import 'package:study_platform/services/auth_services.dart';

// ignore_for_file: avoid_print

class Api {
  final Dio dio = Dio();

  Future<dynamic> get({required String url, required String? token}) async {
    try {
      Map<String, String> headers = {};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('📌 [GET REQUEST]');
      print('➡️ URL: $url');
      print('➡️ Headers: ${headers.toString()}');

      Response response = await dio.get(
        url,
        options: Options(headers: headers),
      );

      print('✅ [GET SUCCESS] ${response.statusCode}');
      print('📦 Data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);

      // 🟢 Refresh token retry
      if (e.response?.statusCode == 401) {
        final newToken = await RefreshTokenService().refreshAccessToken();
        if (newToken != null) {
          return await get(url: url, token: newToken);
        }
      }
      rethrow;
    } catch (e) {
      print('❌ [GET UNEXPECTED ERROR] $e');
      throw Exception("Unexpected Error: $e");
    }
  }


  Future<dynamic> post({
    required String url,
    required dynamic body,
    required String? token,
  }) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('📌 [POST REQUEST]');
      print('➡️ URL: $url');
      print('➡️ Headers: ${headers.toString()}');
      print('➡️ Body: $body');

      Response response = await dio.post(
        url,
        data: body,
        options: Options(headers: headers),
      );

      print('✅ [POST SUCCESS] ${response.statusCode}');
      print('📦 Data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);

      if (e.response?.statusCode == 401) {
        final newToken = await RefreshTokenService().refreshAccessToken();
        if (newToken != null) {
          return await post(url: url, body: body, token: newToken);
        }
      }
      rethrow;
    } catch (e) {
      print('❌ [POST UNEXPECTED ERROR] $e');
      throw Exception("Unexpected Error: $e");
    }
  }


  Future<dynamic> put({
    required String url,
    required dynamic body,
    required String? token,
  }) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('📌 [PUT REQUEST]');
      print('➡️ URL: $url');
      print('➡️ Headers: ${headers.toString()}');
      print('➡️ Body: $body');

      Response response = await dio.put(
        url,
        data: body,
        options: Options(headers: headers),
      );

      print('✅ [PUT SUCCESS] ${response.statusCode}');
      print('📦 Data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);

      if (e.response?.statusCode == 401) {
        final newToken = await RefreshTokenService().refreshAccessToken();
        if (newToken != null) {
          return await put(url: url, body: body, token: newToken);
        }
      }
      rethrow;
    } catch (e) {
      print('❌ [PUT UNEXPECTED ERROR] $e');
      throw Exception("Unexpected Error: $e");
    }
  }


  Future<dynamic> postMultipart({
    required String url,
    required String fileField,
    required File file,
    required String? token,
  }) async {
    try {
      Map<String, String> headers = {};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('📌 [POST MULTIPART REQUEST]');
      print('➡️ URL: $url');
      print('➡️ Headers: ${headers.toString()}');
      print('➡️ File: ${file.path}');

      FormData formData = FormData.fromMap({
        fileField: await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      print('✅ [POST MULTIPART SUCCESS] ${response.statusCode}');
      print('📦 Data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);

      if (e.response?.statusCode == 401) {
        final newToken = await RefreshTokenService().refreshAccessToken();
        if (newToken != null) {
          return await postMultipart(
            url: url,
            fileField: fileField,
            file: file,
            token: newToken,
          );
        }
      }
      rethrow;
    } catch (e) {
      print('❌ [MULTIPART UNEXPECTED ERROR] $e');
      throw Exception("Unexpected Error: $e");
    }
  }


  // 🔹 Helper function لتوحيد التعامل مع Errors
  void _handleDioError(DioException e) {
    print('❌ DioException: ${e.message}');
    if (e.response != null) {
      print('❌ Status: ${e.response?.statusCode}');
      print('❌ Headers: ${e.response?.headers}');
      print('❌ Data: ${e.response?.data}');
    }
  }
}
