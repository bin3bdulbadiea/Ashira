// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:async';

import 'package:ashira/components/change_image_dialog.dart';
import 'package:ashira/components/circular_progress_indicator.dart';
import 'package:ashira/components/dropdown_menu.dart';
import 'package:ashira/components/elevated_button.dart';
import 'package:ashira/components/outlined_button.dart';
import 'package:ashira/components/outlined_button_to_verify_account.dart';
import 'package:ashira/components/show_toast.dart';
import 'package:ashira/components/text_form_field.dart';
import 'package:ashira/generated/l10n.dart';
import 'package:ashira/screens/account_screen/change_password/change_password.dart';
import 'package:ashira/controllers/account_controller.dart';
import 'package:ashira/screens/auth_screens/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChangeAccount extends StatelessWidget {
  ChangeAccount({super.key, required this.data});

  final dynamic data;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final dateFormat = DateFormat('dd - MMMM - yyyy');

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GetBuilder<AccountController>(
        init: AccountController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).colorScheme.background,
              ),
              title: Text(S.of(context).accountSettings),
              actions: [
                // أيقونة حفظ التعديلات
                iconForSaveChanges(context, controller),
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where(
                        'id',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return customCircularProgressIndicator(context);
                    }

                    var data = snapshot.data?.docs;

                    return Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // الصورة الشخصية
                          personaLImage(context, data, controller),

                          SizedBox(height: size.height * 0.02),

                          // البيانات الشخصية
                          Text(
                            S.of(context).personalData,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),

                          SizedBox(height: size.height * 0.02),

                          // البريد الإلكتروني
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  data?[0]['email'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),

                              SizedBox(width: size.width * 0.02),

                              // البريد مؤكد
                              if (FirebaseAuth
                                      .instance.currentUser?.emailVerified ==
                                  true)
                                GestureDetector(
                                  onTap: () => showToast(
                                    context: context,
                                    message: S.of(context).doneVerified,
                                  ),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                ),

                              // البريد غير مؤكد
                              if (FirebaseAuth
                                      .instance.currentUser?.emailVerified ==
                                  false)
                                didnotVerifyEmail(context, size),
                            ],
                          ),

                          SizedBox(height: size.height * 0.02),

                          // اسم المستخدم
                          customTextFormField(
                            context: context,
                            controller: controller.nameController,
                            keyboardType: TextInputType.name,
                            hintText:
                                '${S.of(context).forExpample}: ${data?[0]['name']}',
                            labelText: S.of(context).username,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return S.of(context).validatorField;
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: size.height * 0.02),

                          // اسم العائلة
                          customTextFormField(
                            context: context,
                            controller: controller.lastNameController,
                            keyboardType: TextInputType.name,
                            hintText:
                                '${S.of(context).forExpample}: ${data?[0]['last-name']}',
                            labelText: S.of(context).lastname,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return S.of(context).validatorField;
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: size.height * 0.02),

                          // الكُنية / اللقب
                          customTextFormField(
                            context: context,
                            controller: controller.nickNameController,
                            keyboardType: TextInputType.name,
                            hintText:
                                '${S.of(context).callYou}${S.of(context).comma} ${data?[0]['name']}${S.of(context).question}',
                            labelText: S.of(context).nickName,
                          ),

                          SizedBox(height: size.height * 0.02),

                          // نبذة عنك
                          customTextFormField(
                            context: context,
                            controller: controller.bioController,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            hintText:
                                '${S.of(context).aboutYourself}${S.of(context).comma} ${data?[0]['name']}..',
                            labelText: S.of(context).bio,
                            maxLength: 300,
                            maxLines: 5,
                          ),

                          SizedBox(height: size.height * 0.02),

                          // الجنس
                          gender(context, controller),

                          SizedBox(height: size.height * 0.02),

                          // الحالة الاجتماعية
                          maritalStatus(context, controller),

                          SizedBox(height: size.height * 0.02),

                          // تاريخ الميلاد
                          dateOfBirth(context, controller, dateFormat),

                          SizedBox(height: size.height * 0.02),

                          // تغيير كلمة السر & توثيق / إلغاء توثيق الحساب
                          Row(
                            children: [
                              // تغيير كلمة السر
                              Expanded(
                                child: customOutlinedButton(
                                  context,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangePassword(),
                                      ),
                                    );
                                  },
                                  text: S.of(context).changePasswordButton,
                                ),
                              ),

                              SizedBox(width: size.width * 0.01),

                              // توثيق / إلغاء توثيق الحساب
                              // دي لتوثيق الحساب، لكن مش هخليها على الحال ده
                              // لازم اظبطها بحيث اللي عايز يوثق حسابه لازم يبعت
                              // صورة بطاقته واضحه والبيانات المطلوبه ويتعهد بدفع سعر التوثيق شهريا
                              verifyAccount(snapshot, context, size),
                            ],
                          ),

                          // تعطيل الحساب
                          Row(
                            children: [
                              Expanded(
                                child: disableAccount(context, data),
                              ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.01),

                          // تاريخ انضمام المستخدم
                          Text(
                            '${S.of(context).dateJoin}: ${DateFormat(
                              'EEE${S.of(context).comma} dd - MMMM - yyyy${S.of(context).comma} hh:mm a',
                            ).format(
                              DateTime.parse(
                                data![0]['account-created'].toDate().toString(),
                              ),
                            )}',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  GestureDetector didnotVerifyEmail(
    BuildContext context,
    Size size,
  ) =>
      GestureDetector(
        onTap: () => showModalBottomSheet(
          isDismissible: true,
          showDragHandle: true,
          context: context,
          builder: (context) => SizedBox(
            height: size.height * 0.22,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: Column(
                children: [
                  // لم نتأكد بعد من بريدك الإلكتروني
                  Text(
                    S.of(context).notVerifiedEmail,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // إن كنت قد قمت بهذه الخطوة قبل ذلك تجاهل تنفيذ هذا الإجراء، حيث يستغرق الأمر بعض الوقت حتى تكتمل عملية التأكيد
                  Text(
                    S.of(context).doneVerifyStep,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  // تأكيد
                  customOutlinedButton(
                    context,
                    onPressed: () async {
                      await FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();

                      Navigator.pop(context);

                      showToast(
                        context: context,
                        message: S.of(context).verifyEmailAddress,
                      );
                    },
                    text: S.of(context).verifyEmail,
                  ),
                ],
              ),
            ),
          ),
        ),
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
      );

  OutlinedButton disableAccount(
    BuildContext context,
    List<QueryDocumentSnapshot<Object?>>? data,
  ) =>
      customOutlinedButton(
        context,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(S.of(context).disableAccount),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // هل أنت متأكد أنك تريد حذف حسابك؟
                Text(S.of(context).confirmDisableAccount),

                // بعد 60 يوم سيتم تعطيل الحساب
                Text(
                  S.of(context).after60Days,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .update({
                    'account-disabled': true,
                    'account-disable-date': DateTime.now(),
                  }).then(
                    (value) => Timer(
                      const Duration(days: 60),
                      () async {
                        if (data?[0]['account-disabled'] &&
                            data?[0]['account-disable-date'] != null) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .delete();
                          await FirebaseAuth.instance.currentUser?.delete();
                        }
                      },
                    ),
                  );

                  FirebaseAuth.instance.signOut().then(
                        (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        ),
                      );

                  // تم تعطيل الحساب
                  showToast(
                    context: context,
                    message: S.of(context).disableAccountDone,
                  );
                },
                child: Text(S.of(context).disableAccount),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
            ],
          ),
        ),
        text: S.of(context).disableAccount,
      );

  Expanded verifyAccount(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
    BuildContext context,
    Size size,
  ) =>
      Expanded(
        child: snapshot.data!.docs.first.get('account-verified')
            ? outlinedButtonToVerifyAccount(
                context,
                size,
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(
                        FirebaseAuth.instance.currentUser?.uid,
                      )
                      .update(
                    {
                      'account-verified': false,
                    },
                  );
                },
                iconColor: Colors.red.shade700,
                text: S.of(context).cancelAccountVerification,
              )
            : outlinedButtonToVerifyAccount(
                context,
                size,
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(
                        FirebaseAuth.instance.currentUser?.uid,
                      )
                      .update(
                    {
                      'account-verified': true,
                    },
                  );
                },
                iconColor: Colors.green.shade700,
                text: S.of(context).accountVerification,
              ),
      );

// عايز أحط 3 مستطيلات جنب بعض لليوم والشهر والسنة أفضل من الطريقة المتبعة حاليا
  InkWell dateOfBirth(
    BuildContext context,
    AccountController controller,
    DateFormat dateFormat,
  ) =>
      InkWell(
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
            labelText: S.of(context).birthdate,
            validator: (value) {
              if (value!.isEmpty) {
                return S.of(context).validatorField;
              }
              return null;
            },
          ),
        ),
      );

  Widget maritalStatus(
    BuildContext context,
    AccountController controller,
  ) =>
      customDropdownMenuItem(
        context: context,
        hintText: S.of(context).maritalStatus,
        labelText: S.of(context).maritalStatus,
        value: <String>[
          S.of(context).maritalStatus,
          S.of(context).single,
          S.of(context).engaged,
          S.of(context).married,
          S.of(context).absolute,
          S.of(context).widower,
        ].contains(controller.maritalStatus)
            ? controller.maritalStatus
            : S.of(context).maritalStatus,
        onChanged: (value) {
          controller.maritalStatus = value!;
        },
        items: <String>[
          S.of(context).maritalStatus,
          S.of(context).single,
          S.of(context).engaged,
          S.of(context).married,
          S.of(context).absolute,
          S.of(context).widower,
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          );
        }).toList(),
      );

  Widget gender(
    BuildContext context,
    AccountController controller,
  ) =>
      customDropdownMenuItem(
        context: context,
        validator: (value) {
          if (value == null || value.isEmpty || value == S.of(context).gender) {
            return S.of(context).validatorFieldAndGender;
          }
          return null;
        },
        hintText: S.of(context).gender,
        labelText: S.of(context).gender,
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          );
        }).toList(),
      );

  Stack personaLImage(
    BuildContext context,
    List<QueryDocumentSnapshot<Object?>>? data,
    AccountController controller,
  ) =>
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: data?[0]['photoURL'] == ''
                  ? Container(
                      color: Colors.grey,
                      child: const Icon(Icons.person, size: 100),
                    )
                  : Image.network(data?[0]['photoURL'], fit: BoxFit.fill),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: IconButton(
              onPressed: () {
                changeImageDialog(
                  context,
                  data,
                  title: S.of(context).changePersonalImage,
                  content: controller.selectedPersonalImage != null
                      ? Image.file(controller.selectedPersonalImage!)
                      : data?[0]['photoURL'] == ''
                          ? const SizedBox.shrink()
                          : Image.network(data?[0]['photoURL']),
                  galleryOnPressed: () {
                    Navigator.pop(context);
                    controller.selectPersonalImage();
                  },
                );
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      );

  Padding iconForSaveChanges(
    BuildContext context,
    AccountController controller,
  ) =>
      Padding(
        padding: const EdgeInsets.all(7),
        child: customElevatedButton(
          context: context,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              controller.updateUserData(
                name: controller.nameController.text,
                lastName: controller.lastNameController.text,
                nickName: controller.nickNameController.text,
                bio: controller.bioController.text,
                gender: controller.gender,
                maritalStatus: controller.maritalStatus,
                birthdate: controller.selectedDate!,
              );
              if (controller.isLoading) {
                showToast(
                  context: context,
                  message: S.of(context).loadingModifications,
                );
              }
              Navigator.pop(context);
              showToast(
                context: context,
                message: S.of(context).saveModifications,
              );
            }
          },
          text: S.of(context).save,
        ),
      );
}
