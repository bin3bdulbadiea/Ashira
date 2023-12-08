import 'package:ashira/components/elevated_button.dart';
import 'package:ashira/components/text_form_field.dart';
import 'package:ashira/controllers/menu_drawer_controller.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/controllers/login_controller.dart';
import 'package:ashira/layouts/menu_drawer/languages_screen.dart';
import 'package:ashira/screens/auth_screens/login/forget_password.dart';
import 'package:ashira/screens/auth_screens/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // شعار التطبيق
                          const AppLogoOutSide(),

                          SizedBox(height: size.height * 0.05),

                          // البريد الإلكتروني
                          customTextFormField(
                            context: context,
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: S.of(context).email,
                            autofocus: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return S.of(context).validatorField;
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: size.height * 0.015),

                          // كلمة السر
                          customTextFormField(
                            context: context,
                            controller: controller.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            hintText: S.of(context).password,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return S.of(context).validatorField;
                              }
                              return null;
                            },
                            obscureText: controller.visibilityPassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.changePasswordVisibility();
                              },
                              icon: Icon(controller.suffix),
                            ),
                          ),

                          SizedBox(height: size.height * 0.04),

                          // تسجيل الدخول

                          // العملية بتشرح إذا كان المستخدم معطل حسابه وعايز يرجعه تاني فالعملية توديه لصفحة
                          // استعادة الحساب، انما لو هو مش معطل الحساب فيقوم مسجل الدخول بشكل طبيعي

                          ConditionalBuilder(
                            condition: !controller.isLoading,
                            builder: (context) => customElevatedButton(
                              context: context,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.userLogin(
                                    context: context,
                                    email: controller.emailController.text,
                                    password:
                                        controller.passwordController.text,
                                  );
                                }
                              },
                              text: S.of(context).login,
                            ),
                            fallback: (context) => Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.02),

                          // نسيت كلمة السر؟
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            ),
                            child: Text(S.of(context).forgotPassword),
                          ),

                          SizedBox(height: size.height * 0.02),

                          // إنشاء حساب جديد
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).notMember,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStatePropertyAll(
                                    Colors.grey[200],
                                  ),
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                ),
                                child: Text(
                                  S.of(context).createNewAccount,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // أيقونة تغيير المظهر
                              GetBuilder(
                                init: MenuDrawerController(),
                                builder: (controller) => IconButton(
                                  onPressed: () {
                                    controller.changeThemeMode();
                                  },
                                  icon: Icon(
                                    controller.isNight.value
                                        ? Icons.light_mode
                                        : Icons.mode_night,
                                  ),
                                ),
                              ),

                              // أيقونة تغيير اللغة
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LanguagesScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.language),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppLogoOutSide extends StatelessWidget {
  const AppLogoOutSide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'عشيرة',
          style: TextStyle(
            fontFamily: 'Ruwudu',
            fontSize: 50,
          ),
        ),
        Text(
          S.of(context).beta,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
