import 'package:ashira/components/circular_progress_indicator.dart';
import 'package:ashira/components/elevated_button.dart';
import 'package:ashira/components/text_form_field.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/controllers/login_controller.dart';
import 'package:ashira/components/app_logo_out_side.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

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
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // شعار التطبيق
                    const AppLogoOutSide(),

                    SizedBox(height: size.height * 0.02),

                    // قم بإدخال البريد الإلكتروني الذي قمت بالتسجيل به لتغيير كلمة السر
                    Text(
                      S.of(context).changePassword,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: size.height * 0.02),

                    // البريد الإلكتروني
                    customTextFormField(
                      context: context,
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: S.of(context).email,
                      autofocus: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return S.of(context).validatorField;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: size.height * 0.02),

                    Row(
                      children: [
                        // إرسال
                        Expanded(
                          child: ConditionalBuilder(
                            condition: !controller.isLoading,
                            builder: (context) => customElevatedButton(
                              context: context,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.forgetPassword(context: context);
                                }
                              },
                              text: S.of(context).send,
                            ),
                            fallback: (context) =>
                                customCircularProgressIndicator(context),
                          ),
                        ),

                        SizedBox(width: size.width * 0.02),

                        // إلغاء
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(S.of(context).back),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
