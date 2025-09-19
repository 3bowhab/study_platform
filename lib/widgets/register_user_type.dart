import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

class RegisterUserType extends StatefulWidget {
  final Function(String userType, String? childUsername) onUserTypeSelected;

  const RegisterUserType({super.key, required this.onUserTypeSelected});

  @override
  State<RegisterUserType> createState() => _RegisterUserTypeState();
}

class _RegisterUserTypeState extends State<RegisterUserType> {
  String? userType; // "student" | "teacher" | "parent"
  String? childUsername;

  final options = [
    {"title": "طالب", "value": "student", "icon": Icons.school},
    {"title": "مدرس", "value": "teacher", "icon": Icons.person},
    {"title": "ولي أمر", "value": "parent", "icon": Icons.family_restroom},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "اختر نوع المستخدم:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: AppFonts.mainFont),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.start, // 👈 يثبتهم ناحية البداية
          children:
              options.map((opt) {
                final isSelected = userType == opt["value"];

                return Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                  ), // مسافة بسيطة بين الكروت
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        userType = opt["value"] as String;
                        if (userType != "parent") childUsername = null;
                      });
                      widget.onUserTypeSelected(userType!, childUsername);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      width: 95,
                      decoration: BoxDecoration(
                        color:  Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? AppColors.primaryColor : AppColors.grayColor,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                                : [],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            opt["icon"] as IconData,
                            size: 28,
                            color:
                                isSelected ? AppColors.primaryColor : AppColors.grayColor,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            opt["title"] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: AppFonts.mainFont,
                              color:
                                  isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.blackColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),

        const SizedBox(height: 16),

        if (userType == "parent") ...[
          TextFormField(
            decoration: const InputDecoration(
              labelText: "اسم المستخدم للابن",
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              setState(() {
                childUsername = val;
              });
              widget.onUserTypeSelected(userType!, childUsername);
            },
            validator: (val) {
              if (userType == "parent" && (val == null || val.isEmpty)) {
                return "برجاء إدخال اسم الابن";
              }
              return null;
            },
          ),
        ],
      ],
    );
  }
}
