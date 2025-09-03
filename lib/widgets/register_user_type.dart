// register_user_type.dart
import 'package:flutter/material.dart';

class RegisterUserType extends StatefulWidget {
  final Function(String userType, String? childUsername) onUserTypeSelected;

  const RegisterUserType({super.key, required this.onUserTypeSelected});

  @override
  State<RegisterUserType> createState() => _RegisterUserTypeState();
}

class _RegisterUserTypeState extends State<RegisterUserType> {
  String? userType; // "student" | "teacher" | "parent"
  String? childUsername;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select User Type:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        RadioListTile<String>(
          title: const Text("طالب"),
          value: "student",
          groupValue: userType,
          onChanged: (val) {
            setState(() {
              userType = val;
              childUsername = null;
            });
            widget.onUserTypeSelected(userType!, childUsername);
          },
        ),
        RadioListTile<String>(
          title: const Text("مدرس"),
          value: "teacher",
          groupValue: userType,
          onChanged: (val) {
            setState(() {
              userType = val;
              childUsername = null;
            });
            widget.onUserTypeSelected(userType!, childUsername);
          },
        ),
        RadioListTile<String>(
          title: const Text("ولي أمر"),
          value: "parent",
          groupValue: userType,
          onChanged: (val) {
            setState(() {
              userType = val;
            });
            widget.onUserTypeSelected(userType!, childUsername);
          },
        ),

        if (userType == "parent") ...[
          const SizedBox(height: 16),
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
