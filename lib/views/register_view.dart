import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/models/authentication/register_model.dart';
import 'package:study_platform/services/authentication/register_service.dart';
import 'package:study_platform/views/confirm_email_view.dart';
import 'package:study_platform/views/login_view.dart';
import 'package:study_platform/widgets/birthday_input.dart';
import 'package:study_platform/widgets/custom_text_field.dart';
import 'package:study_platform/widgets/loading_indecator.dart';
import 'package:study_platform/widgets/register_user_type.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final formkey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  String? firstName,
      lastName,
      phoneNumber,
      userType,
      childUsername,
      dateOfBirth;

  bool isLoading = false;

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
                  // 🔹 الجزء العلوي (نفس ديزاين اللوجين)
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
                          right: 10,
                          top: 105,
                          width: 240,
                          height: 270,
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Image.asset(
                              "assets/images/register_img.png",
                            ),
                          ),
                        ),
                        Positioned(
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: Container(
                              // margin: const EdgeInsets.only(top: 10),
                              child: const Center(
                                child: Text(
                                  "إنشاء حساب",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontFamily: AppFonts.mainFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 الجزء السفلي (الفورم)
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: formkey,
                      autovalidateMode: autovalidateMode,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: <Widget>[
                            FadeInUp(
                              duration: const Duration(milliseconds: 1800),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    labelText: 'اسم المستخدم',
                                    validator: AppValidators.usernameValidator,
                                    controller: _usernameController,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    labelText: 'البريد الإلكتروني',
                                    validator: AppValidators.emailValidator,
                                    controller: _emailController,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    labelText: 'كلمة المرور',
                                    controller: _passwordController,
                                    validator: AppValidators.passwordValidator,
                                    obscureText: true,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    labelText: 'تأكيد كلمة المرور',
                                    controller: _confirmController,
                                    obscureText: true,
                                    validator:
                                        (value) =>
                                            AppValidators.confirmPasswordValidator(
                                              value,
                                              _passwordController.text,
                                            ),
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    labelText: 'الاسم الأول',
                                    validator: AppValidators.usernameValidator,
                                    onsaved: (newValue) => firstName = newValue,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    labelText: 'اسم العائلة',
                                    validator: AppValidators.usernameValidator,
                                    onsaved: (newValue) => lastName = newValue,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    labelText: 'رقم الهاتف',
                                    keyboardType: TextInputType.phone,
                                    validator: AppValidators.phoneValidator,
                                    onsaved: (newValue) => phoneNumber = newValue,
                                  ),
                                  const SizedBox(height: 16),
                                  BirthDateField(
                                    initialDate: dateOfBirth,
                                    onChanged: (value) => dateOfBirth = value,
                                  ),
                                  const SizedBox(height: 16),
                                  RegisterUserType(
                                    onUserTypeSelected: (selectedType, child) {
                                      userType = selectedType;
                                      childUsername = child;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),

                            FadeInUp(
                              duration: const Duration(milliseconds: 1900),
                              child: submitButton(context),
                            ),
                            const SizedBox(height: 20),

                            FadeInUp(
                              duration: const Duration(milliseconds: 2000),
                              child: goToLoginView(context),
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
        if (isLoading) const LoadingIndicator(),
      ],
    );
  }

  Row goToLoginView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("هل لديك حساب؟", style: TextStyle(fontFamily: AppFonts.mainFont)),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          },
          child: const Text("تسجيل الدخول", style: TextStyle(fontFamily: AppFonts.mainFont)),
        ),
      ],
    );
  }

  ElevatedButton submitButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.primaryColor,
      ),
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          formkey.currentState!.save();

          final registerModel = RegisterModel(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            confirmPassword: _confirmController.text.trim(),
            firstname: firstName!,
            lastname: lastName!,
            phoneNumber: phoneNumber!,
            userType: userType!,
            dateOfBirth: dateOfBirth!,
          );

          setState(() => isLoading = true);

          try {
            final response = await RegisterService().register(registerModel);
            print("✅ Register response: $response");
            setState(() => isLoading = false);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Registration Successful")),
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ConfirmEmailView()),
            );
          } catch (e) {
            setState(() => isLoading = false);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
          }
        } else {
          setState(() => autovalidateMode = AutovalidateMode.always);
        }
      },
      child: const Text("تسجيل", style: TextStyle(color: Colors.white, fontFamily: AppFonts.mainFont)),
    );
  }
}
