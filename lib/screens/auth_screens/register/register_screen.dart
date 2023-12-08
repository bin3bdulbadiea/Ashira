// ignore_for_file: depend_on_referenced_packages

import 'package:ashira/components/dropdown_menu.dart';
import 'package:ashira/components/elevated_button.dart';
import 'package:ashira/components/show_toast.dart';
import 'package:ashira/components/text_form_field.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/controllers/account_controller.dart';
import 'package:ashira/controllers/register_controller.dart';
import 'package:ashira/components/app_logo_out_side.dart';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final lastNameController = TextEditingController();

  final emailController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final dateFormat = DateFormat('dd - MMMM - yyyy');

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GetBuilder<RegisterController>(
      init: RegisterController(),
      builder: (controller) => GestureDetector(
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

                        // اسم المستخدم
                        customTextFormField(
                          context: context,
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          hintText: S.of(context).username,
                          autofocus: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return S.of(context).validatorField;
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: size.height * 0.015),

                        // اسم العائلة
                        customTextFormField(
                          context: context,
                          controller: lastNameController,
                          keyboardType: TextInputType.name,
                          hintText: S.of(context).lastname,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return S.of(context).validatorField;
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: size.height * 0.015),

                        // البريد الإلكتروني
                        customTextFormField(
                          context: context,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: S.of(context).email,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return S.of(context).validatorField;
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: size.height * 0.015),

                        // تاريخ الميلاد
                        dateOfBirth(context, controller),

                        SizedBox(height: size.height * 0.015),

                        // الجنس
                        gender(context, controller),

                        SizedBox(height: size.height * 0.015),

                        // كلمة السر
                        customTextFormField(
                          context: context,
                          controller:
                              Get.put(AccountController()).passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: '${S.of(context).password} (+6)',
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

                        SizedBox(height: size.height * 0.015),

                        // تأكيد كلمة السر
                        customTextFormField(
                          context: context,
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: '${S.of(context).confirmPassword} (+6)',
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

                        SizedBox(height: size.height * 0.04),

                        // إنشاء حساب جديد
                        createAccount(controller),

                        SizedBox(height: size.height * 0.02),

                        // تسجيل الدخول
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).haveAccount,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStatePropertyAll(
                                  Colors.grey[200],
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                S.of(context).login,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
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
      ),
    );
  }

  ConditionalBuilder createAccount(RegisterController controller) {
    return ConditionalBuilder(
      condition: !controller.isLoading,
      builder: (context) => customElevatedButton(
        context: context,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (Get.put(AccountController()).passwordController.text ==
                confirmPasswordController.text) {
              controller.userRegister(
                context: context,
                name: nameController.text,
                lastName: lastNameController.text,
                email: emailController.text,
                password: Get.put(AccountController()).passwordController.text,
              );
            } else {
              showToast(
                context: context,
                message: S.of(context).passwordNotMatch,
              );
            }
          }
        },
        text: S.of(context).createNewAccount,
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

  Widget gender(BuildContext context, RegisterController controller) {
    return customDropdownMenuItem(
      context: context,
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            value == S.maybeOf(context)?.gender) {
          return S.of(context).validatorFieldAndGender;
        }
        return null;
      },
      hintText: S.of(context).gender,
      value: <String>[
        S.of(context).gender,
        S.of(context).male,
        S.of(context).female,
      ].contains(controller.gender)
          ? controller.gender
          : S.of(context).gender,
      onChanged: (value) {
        controller.gender = value!;
      },
      items: <String>[
        S.of(context).gender,
        S.of(context).male,
        S.of(context).female,
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }

  InkWell dateOfBirth(BuildContext context, RegisterController controller) {
    return InkWell(
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (
            BuildContext context,
            Widget? child,
          ) {
            return child!;
          },
        ).then((selectedDate) {
          if (selectedDate != null) {
            controller.selectedDate = selectedDate;
            controller.dateController.text = dateFormat.format(
              controller.selectedDate!,
            );
          }
        });
      },
      child: AbsorbPointer(
        child: customTextFormField(
          context: context,
          controller: controller.dateController,
          keyboardType: TextInputType.datetime,
          hintText: S.of(context).birthdate,
          validator: (value) {
            if (value!.isEmpty) {
              return S.of(context).validatorField;
            }
            return null;
          },
        ),
      ),
    );
  }
}
