import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interviewtask/custom/bottom_navigation.dart';
import 'package:interviewtask/screen/register_screen.dart';
import 'package:interviewtask/utils/app_color.dart';

import '../utils/app_string.dart';
import '../utils/auth.dart';
import '../utils/shar_pref.dart';
import '../utils/utils.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Function to handle login
  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loader
      });

      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailCon.text.trim(),
          password: passwordCon.text.trim(),
        );
       await  AuthService().fetchUserData().then((val){
         Shared_Preferences.prefSetString(Shared_Preferences.keyUserId, val!.id.toString());
       });
        Utils().showToast(AppString.strLoginSuccessful);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigationScreen(),
            ));

      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = AppString.strNoUserFoundForThatEmail;
            break;
          case 'wrong-password':
            errorMessage = AppString.strWrongPasswordProvided;
            break;
          default:
            errorMessage = e.message ?? AppString.strPleaseTryAgain;
        }
        Utils().showToast(errorMessage.toString());
      } finally {
        setState(() {
          _isLoading = false; // Hide loader
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.clrBlack,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.13),
            const Text(
             AppString.strWelcome,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: AppColors.clrWhite,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
             AppString.strLoginSubtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              decoration: BoxDecoration(color: Colors.grey[900],borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailCon,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: AppString.strEmail,
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      prefixIcon: const Icon(Icons.email, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) =>
                    value!.isEmpty ? AppString.strPleaseEnterYourEmail : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: AppString.strPassword,
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon:  Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                          });
                          // Add logic to show/hide password
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: _isPasswordVisible,
                    validator: (value) =>
                    value!.isEmpty ? AppString.strPleaseEnterYourPassword : null,
                    controller: passwordCon,
                    style: const TextStyle(color: Colors.white),
                  ),

                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: const Text(
                      AppString.strForgot,
                      style: TextStyle(
                          color: AppColors.clrWhite,fontSize: 16
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator()) // Display loader while logging in
                      : InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: loginUser,
                        child: Container(
                          height: 55,
                          decoration:  BoxDecoration(color: AppColors.clrDeepPurple.withOpacity(0.5),borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              Expanded(
                                child: Container(
                                  height: 55,
                                  decoration: const BoxDecoration(color:AppColors.clrDeepPurple,borderRadius: BorderRadius.all(Radius.circular(10))),
                                  child:  const Center(
                                    child: Text(
                                      AppString.strLogin,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ),


                  // ButtonWidget(
                  //     title: 'Login',
                  //     onTap: loginUser),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width *0.15),
            const Text(AppString.strDontHaveAnAccount,style: TextStyle(color:  Colors.grey,fontSize: 16)),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ));
                },
                child: const Text(AppString.strCreateAccount,style: TextStyle(color:  AppColors.clrWhite,fontSize: 16))),
                     // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
