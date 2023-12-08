// import 'package:ashira/components/outlined_button.dart';
// import 'package:ashira/generated/l10n.dart';
// import 'package:ashira/layouts/home/home_layout.dart';
// import 'package:ashira/screens/auth_screens/login/login_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ReactiveAccount extends StatelessWidget {
//   const ReactiveAccount({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(S.of(context).accountRecovery),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'عشيرة',
//               style: TextStyle(
//                 fontFamily: 'Ruwudu',
//                 fontSize: 50,
//               ),
//             ),

//             SizedBox(height: size.height * 0.02),

//             // لقد قمت مؤخراً بتعطيل حسابك
//             Text(
//               S.of(context).accountDisable,
//             ),
//             SizedBox(height: size.height * 0.02),

//             // إذا كنت تريد استعادة حسابك قم بالضغط على استعادة الحساب
//             Text(
//               S.of(context).restoreAccount,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),

//             SizedBox(height: size.height * 0.02),

//             Row(
//               children: [
//                 // استعاد الحساب
//                 Expanded(
//                   child: customOutlinedButton(
//                     context,
//                     onPressed: () {
//                       FirebaseFirestore.instance
//                           .collection('users')
//                           .doc(FirebaseAuth.instance.currentUser?.uid)
//                           .update({
//                         'account-disabled': false,
//                         'account-disable-date': null,
//                       });
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const HomeLayout(),
//                         ),
//                         (route) => false,
//                       );
//                     },
//                     text: S.of(context).accountRecovery,
//                   ),
//                 ),

//                 SizedBox(width: size.width * 0.02),

//                 // تسجيل الخروج
//                 Expanded(
//                   child: customOutlinedButton(
//                     context,
//                     onPressed: () {
//                       FirebaseAuth.instance.signOut();
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => LoginScreen(),
//                         ),
//                         (route) => false,
//                       );
//                     },
//                     text: S.of(context).signout,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
