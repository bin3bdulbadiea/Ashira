import 'package:ashira/components/elevated_button.dart';
import 'package:ashira/components/show_toast.dart';
import 'package:ashira/components/text_form_field.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/controllers/account_controller.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GetBuilder(
      init: AccountController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: Text(S.of(context).changePasswordButton),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // كلمة السر القديمة
                  customTextFormField(
                    context: context,
                    controller: controller.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: S.of(context).oldPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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

                  SizedBox(height: size.height * 0.01),

                  // كلمة السر الجديدة
                  customTextFormField(
                    context: context,
                    controller: controller.newPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: S.of(context).newPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).validatorField;
                      }
                      return null;
                    },
                    obscureText: controller.confirmVisibilityPassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.changeConfirmPasswordVisibility();
                      },
                      icon: Icon(controller.confirmSuffix),
                    ),
                  ),

                  SizedBox(height: size.height * 0.01),

                  // تأكيد كلمة السر الجديدة
                  customTextFormField(
                    context: context,
                    controller: controller.confirmNewPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: S.of(context).confirmNewPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).validatorField;
                      }
                      return null;
                    },
                    obscureText: controller.confirmVisibilityPassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.changeConfirmPasswordVisibility();
                      },
                      icon: Icon(controller.confirmSuffix),
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  // تغيير كلمة السر
                  changePassword(controller),

                  SizedBox(height: size.height * 0.02),

                  // إلغاء
                  customElevatedButton(
                    context: context,
                    onPressed: () {
                      Get.back();
                      controller.passwordController.clear();
                      controller.newPasswordController.clear();
                      controller.confirmNewPasswordController.clear();
                    },
                    text: S.of(context).cancel,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ConditionalBuilder changePassword(AccountController controller) {
    return ConditionalBuilder(
      condition: !controller.isLoading,
      builder: (context) => customElevatedButton(
        context: context,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // بختبر إذا كلمة السر القديمة بتساوي الجديدة ولا لا
            if (controller.passwordController.text ==
                controller.newPasswordController.text) {
              // كلمة السر القديمة تطابق كلمة السر الجديدة.
              // من فضلك اختر كلمة سر أخرى!
              showToast(
                context: context,
                message:
                    '${S.of(context).newPasswordMatchOldPassword}\n${S.of(context).chooseAnotherPassword}',
              );
            } else if (controller.newPasswordController.text !=
                controller.confirmNewPasswordController.text) {
              // كلمة السر الجديدة غير متطابقة
              showToast(
                context: context,
                message: S.of(context).newPasswordNotMatch,
              );
            } else {
              controller.changePassword(
                context,
                currentPassword: controller.passwordController.text,
                newPassword: controller.newPasswordController.text,
              );
            }
          }
        },
        text: S.of(context).changePasswordButton,
      ),
      fallback: (context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(
            Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
