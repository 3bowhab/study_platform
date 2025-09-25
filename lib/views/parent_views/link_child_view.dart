import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/services/authentication/link_child_service.dart';
import 'package:study_platform/widgets/loading_indecator.dart'; // Make sure this is a real file
import 'package:study_platform/widgets/custom_text_field.dart'; // Make sure this is a real file
import 'package:study_platform/helper/app_colors_fonts.dart'; // Make sure this is a real file

class LinkChildView extends StatefulWidget {
  const LinkChildView({super.key});

  @override
  State<LinkChildView> createState() => _LinkChildViewState();
}

class _LinkChildViewState extends State<LinkChildView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _childUsernameController =
      TextEditingController(); // Use a controller for text fields
  bool _isLoading = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // 🔹 الجزء العلوي (ديزاين مع الأنيميشن)
                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/background.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 40,
                          left: 10,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: FadeInUp(
                            duration: const Duration(seconds: 1),
                            child: Image.asset("assets/images/light-1.png"),
                          ),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 120,
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Image.asset("assets/images/light-2.png"),
                          ),
                        ),
                        Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Image.asset("assets/images/clock.png"),
                          ),
                        ),
                        Positioned(
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "ربط حساب",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontFamily: AppFonts.mainFont,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "الابن",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontFamily: AppFonts.mainFont,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 الجزء السفلي (الفورم الحقيقي)
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: autovalidateMode,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: <Widget>[
                            FadeInUp(
                              duration: const Duration(milliseconds: 1800),
                              child: CustomTextField(
                                controller: _childUsernameController,
                                labelText: "اسم المستخدم للابن",
                                validator: AppValidators.requiredField,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // زرار الربط
                            FadeInUp(
                              duration: const Duration(milliseconds: 1900),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                onPressed: _linkChild,
                                child: const Text(
                                  "ربط",
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontFamily: AppFonts.mainFont,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) const LoadingIndicator(),
      ],
    );
  }

  Future<void> _linkChild() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      FocusScope.of(context).unfocus(); // عشان يقفل الكيبورد

      try {
        await LinkChildService().linkChild(
          _childUsernameController.text.trim(),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "✅ تم ربط ${_childUsernameController.text.trim()} بنجاح",
            ),
            backgroundColor: AppColors.successColor,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ فشل ربط الابن: $e")));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      setState(() => autovalidateMode = AutovalidateMode.always);
    }
  }
}
