import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interviewtask/utils/app_color.dart';

import '../screen/login_screen.dart';
import '../utils/shar_pref.dart';

AppBar customAppbar(String title,BuildContext context){
  return AppBar(
    backgroundColor: AppColors.clrDeepPurple,
    title:  Text(title,style: const TextStyle(color: AppColors.clrWhite),),centerTitle: true,
      leading: const SizedBox(),actions: [
        IconButton(onPressed: (){
          _logout(context);
        }, icon: const Icon(Icons.logout,color: AppColors.clrWhite))

    ],);
}

Future<void> _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Shared_Preferences.clearAllPref();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error logging out. Please try again.")),
    );
  }
}