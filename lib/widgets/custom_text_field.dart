import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.validator,
    this.onsaved,
    this.obscureText = false,
    this.controller,
    this.keyboardType, // ✅ نوع الكيبورد
    required this.labelText,
  });

  final String? Function(String?)? validator;
  final void Function(String?)? onsaved;
  final bool obscureText;
  final TextEditingController? controller;
  final String? labelText;
  final TextInputType? keyboardType; // ✅ جديد

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      onSaved: widget.onsaved,
      obscureText: _obscureText,
      controller: widget.controller,
      keyboardType: widget.keyboardType, // ✅ هنا بنستخدمها
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          fontFamily: AppFonts.mainFont,
          color: AppColors.blackColor,
        ),
        suffixIcon:
            widget.obscureText
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : null,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
