import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';

class BirthDateField extends StatefulWidget {
  final String hintText;
  final String? initialValue;
  final String? initialDate; // تاريخ الميلاد الافتراضي
  final Function(String)? onChanged; // يتم استدعاؤها عند التغيير

  const BirthDateField({
    super.key,
    this.hintText = "العمر",
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
              primary: Color(0xFF20B2AA), // لون البنفسجي الجديد
              onPrimary: Colors.white,
              onSurface: AppColors.gray,
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
      if (widget.onChanged != null) {
        widget.onChanged!(formatted);
      }
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        validator: (data) => feildValidator(data),
        controller: _dateController,
        readOnly: true,
        onTap: () => _selectDate(context),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: widget.initialValue ?? "تاريخ الميلاد",
          labelStyle: const TextStyle(
            color: AppColors.gray,
            fontFamily: 'KidzhoodArabic',
          ),
          // prefixIcon: Icon(Icons.cake, color: AppColors.secondaryColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            // borderSide: BorderSide(color: AppColors.secondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            // borderSide: BorderSide(color: AppColors.secondaryColor, width: 2),
          ),
          errorStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 17, 0),
            fontSize: 12,
            fontFamily: 'KidzhoodArabic',
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: const TextStyle(
          color: AppColors.textColor,
          fontFamily: 'KidzhoodArabic',
        ),
      ),
    );
  }

  String? feildValidator(String? data) {
    if (data == null || data.isEmpty) {
      return "هذا الحقل لا يمكن أن يكون فارغًا";
    }
    return null;
  }
}
