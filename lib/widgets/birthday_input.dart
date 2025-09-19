import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

class BirthDateField extends StatefulWidget {
  final String hintText;
  final String? initialValue;
  final String? initialDate;
  final Function(String)? onChanged;

  const BirthDateField({
    super.key,
    this.hintText = "تاريخ الميلاد",
    this.initialDate,
    this.onChanged,
    this.initialValue,
  });

  @override
  BirthDateFieldState createState() => BirthDateFieldState();
}

class BirthDateFieldState extends State<BirthDateField> {
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.initialDate ?? '');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          (_dateController.text.isNotEmpty)
              ? DateTime.tryParse(_dateController.text) ?? DateTime.now()
              : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor, // اللون الأساسي
              onPrimary: Colors.white,
              onSurface: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted =
          "${picked.year}-${_twoDigits(picked.month)}-${_twoDigits(picked.day)}";
      setState(() {
        _dateController.text = formatted;
      });
      widget.onChanged?.call(formatted);
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        validator: feildValidator,
        controller: _dateController,
        readOnly: true,
        onTap: () => _selectDate(context),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelText: widget.initialValue ?? widget.hintText,
          labelStyle: const TextStyle(
            color: AppColors.blackColor,
            fontFamily: AppFonts.mainFont,
          ),
          prefixIcon: const Icon(Icons.cake,),
          filled: true,
          fillColor: AppColors.grayColor.withValues(alpha: 0.1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.blackColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
          errorStyle: const TextStyle(
            color: AppColors.errorColor,
            fontSize: 12,
            fontFamily: AppFonts.mainFont,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        style: const TextStyle(
          color: AppColors.blackColor,
          fontFamily: AppFonts.mainFont,
          fontSize: 16,
        ),
      ),
    );
  }

  String? feildValidator(String? data) {
    if (data == null || data.isEmpty) {
      return "⚠️ برجاء اختيار تاريخ الميلاد";
    }
    return null;
  }
}
