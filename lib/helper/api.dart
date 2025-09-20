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
      final message = handleDioError(e);
      throw Exception(message); // ✅ رجع رسالة بسيطة
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
      final message = handleDioError(e);
      throw Exception(message); // ✅ رجع رسالة بسيطة
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
      final message = handleDioError(e);
      throw Exception(message); // ✅ رجع رسالة بسيطة
    } catch (e) {
      print('❌ [PUT UNEXPECTED ERROR] $e');
      throw Exception("Unexpected Error: $e");
    }
  }

  Future<dynamic> patch({
    required String url,
    required dynamic body,
    required String? token,
  }) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('📌 [PATCH REQUEST]');
      print('➡️ URL: $url');
      print('➡️ Headers: ${headers.toString()}');
      print('➡️ Body: $body');

      Response response = await dio.patch(
        url,
        data: body,
        options: Options(headers: headers),
      );

      print('✅ [PATCH SUCCESS] ${response.statusCode}');
      print('📦 Data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      final message = handleDioError(e);
      throw Exception(message);
    } catch (e) {
      print('❌ [PATCH UNEXPECTED ERROR] $e');
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
      final message = handleDioError(e);
      throw Exception(message);
    } catch (e) {
      print('❌ [MULTIPART UNEXPECTED ERROR] $e');
      throw Exception("Unexpected Error: $e");
    }
  }


  Future<dynamic> delete({required String url, required String? token}) async {
    try {
      Map<String, String> headers = {};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('📌 [DELETE REQUEST]');
      print('➡️ URL: $url');
      print('➡️ Headers: ${headers.toString()}');

      Response response = await dio.delete(
        url,
        options: Options(headers: headers),
      );

      print('✅ [DELETE SUCCESS] ${response.statusCode}');
      print('📦 Data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      final message = handleDioError(e);
      throw Exception(message);
    } catch (e) {
      print('❌ [DELETE UNEXPECTED ERROR] $e');
      throw Exception("Unexpected Error: $e");
    }
  }

  String handleDioError(DioException e) {
    // 🖨️ اطبع كل التفاصيل عشان المطوّر يشوفها في Logcat
    print('❌ DioException: ${e.message}');
    if (e.response != null) {
      print('❌ Status: ${e.response?.statusCode}');
      print('❌ Headers: ${e.response?.headers}');
      print('❌ Data: ${e.response?.data}');
    }

    // 🎯 رجّع للمستخدم رسالة مختصرة بس
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map) {
        final firstKey = data.keys.first;
        final firstValue = data[firstKey];
        if (firstValue is List && firstValue.isNotEmpty) {
          return firstValue.first.toString();
        } else {
          return firstValue.toString();
        }
      } else {
        return data.toString();
      }
    } else {
      return e.message ?? "Unknown error";
    }
  }
}
