import 'package:flutter/material.dart';
import 'package:study_platform/helper/storage_service.dart';
import 'package:study_platform/services/authentication/refresh_token_service.dart';
import 'package:study_platform/views/register_view.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

void handleAuthenticationError(BuildContext context, String errorMessage) {
  if (errorMessage.contains("No token found") ||
      errorMessage.contains("Invalid token")) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "انتهت الجلسة",
              style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              "برجاء إعادة تسجيل الدخول للاستمرار.",
              style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // 💡 الخطوات التي تحدث عند الضغط على الزر
                  // 1. مسح البيانات من الذاكرة المحلية
                  StorageService().logout();
                  // 2. إيقاف مؤقت تحديث الـ token
                  RefreshTokenService().stopAutoRefresh();
                  // 3. الانتقال لصفحة تسجيل الدخول وحذف كل الصفحات السابقة
                  if (context.mounted) {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const RegisterView()),
                      (route) => false,
                    );
                  }
                },
                child: Text(
                  "إعادة تسجيل الدخول",
                  style: TextStyle(fontFamily: AppFonts.mainFont),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
