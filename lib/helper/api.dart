import 'dart:io';
import 'package:dio/dio.dart';
// ignore_for_file: avoid_print

class Api {
  final Dio dio = Dio();

  Future<dynamic> get({required String url, required String? token}) async {
    try {
      Map<String, String> headers = {};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('📌 GET REQUEST');
      print('URL: $url');
      print('Headers: ${headers.toString()}');

      Response response = await dio.get(
        url,
        options: Options(headers: headers),
      );

      print('✅ Response status: ${response.statusCode}');
      print('✅ Response headers: ${response.headers}');
      print('✅ Response data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      if (e.response != null) {
        print('❌ DioException status: ${e.response?.statusCode}');
        print('❌ DioException headers: ${e.response?.headers}');
        print('❌ DioException data: ${e.response?.data}');
      }
      throw Exception("HTTP Error: ${e.response?.statusCode} - ${e.message}");
    } catch (e) {
      print('❌ Unexpected Error: $e');
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

      print('📌 POST REQUEST');
      print('URL: $url');
      print('Headers: ${headers.toString()}');
      print('Body: $body');

      Response response = await dio.post(
        url,
        data: body,
        options: Options(headers: headers),
      );

      print('✅ Response status: ${response.statusCode}');
      print('✅ Response headers: ${response.headers}');
      print('✅ Response data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      if (e.response != null) {
        print('❌ DioException status: ${e.response?.statusCode}');
        print('❌ DioException headers: ${e.response?.headers}');
        print('❌ DioException data: ${e.response?.data}');
       final data = e.response?.data;

        if (data is Map) {
          final List<String> errors = [];

          data.forEach((key, value) {
            if (value is List) {
              // لو السيرفر رجّع ليستة
              errors.addAll(value.map((e) => e.toString()));
            } else {
              // لو السيرفر رجّع سترنج عادي
              errors.add(value.toString());
            }
          });

          // نطبع الأخطاء
          for (var msg in errors) {
            print("❌ $msg");
          }

          // نعمل سترنج واحد للـ UI
          final allErrors = errors.join("\n");
          throw allErrors;
        } else {
          throw data.toString();
        }

      } else {
        throw e.message ?? "Unknown Dio error";
      }
    } catch (e) {
      print('❌ Unexpected Error: $e');
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

      print('📌 PUT REQUEST');
      print('URL: $url');
      print('Headers: ${headers.toString()}');
      print('Body: $body');

      Response response = await dio.put(
        url,
        data: body,
        options: Options(headers: headers),
      );

      print('✅ Response status: ${response.statusCode}');
      print('✅ Response headers: ${response.headers}');
      print('✅ Response data: ${response.data}');

      print('response: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      if (e.response != null) {
        print('❌ DioException status: ${e.response?.statusCode}');
        print('❌ DioException headers: ${e.response?.headers}');
        print('❌ DioException data: ${e.response?.data}');
      }
      throw Exception("HTTP Error: ${e.response?.statusCode} - ${e.response?.data}");
    } catch (e) {
      print('❌ Unexpected Error: $e');
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

      print('📌 POST MULTIPART REQUEST');
      print('URL: $url');
      print('Headers: ${headers.toString()}');
      print('File: ${file.path}');

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

      print('✅ Response status: ${response.statusCode}');
      print('✅ Response headers: ${response.headers}');
      print('✅ Response data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      if (e.response != null) {
        print('❌ DioException status: ${e.response?.statusCode}');
        print('❌ DioException headers: ${e.response?.headers}');
        print('❌ DioException data: ${e.response?.data}');
      }
      throw Exception("HTTP Error: ${e.response?.statusCode} - ${e.message}");
    } catch (e) {
      print('❌ Unexpected Error: $e');
      throw Exception("Unexpected Error: $e");
    }
  }
}
