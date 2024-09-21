import 'dart:async';
import 'package:flutter/material.dart';
import 'package:interviewtask/screen/login_screen.dart';

import '../custom/bottom_navigation.dart';
import '../utils/app_color.dart';
import '../utils/shar_pref.dart';
import 'home_screen.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nav();
  }

  nav() async {
 String?   userId = await Shared_Preferences.prefGetString(Shared_Preferences.keyUserId, "");
    Future.delayed(const Duration(seconds: 3)).then((value2) {
      if(userId!.isEmpty){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  LoginScreen(),
            ));
      }else{
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  BottomNavigationScreen(),
          ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.clrBlack,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(child: Image.asset('assets/images/logo.webp',width: MediaQuery.of(context).size.width/2.5)),
      ),
    );
  }
}
