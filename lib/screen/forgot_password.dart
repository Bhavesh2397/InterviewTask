import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interviewtask/utils/app_color.dart';
import 'package:interviewtask/utils/app_string.dart';

import '../utils/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();

  // Function to handle password reset
  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.sendPasswordResetEmail(email: email.text.trim());
        Utils().showToast(AppString.strPasswordResetEmailSent);
      } catch (e) {
        Utils().showToast(AppString.strErrorResetEmail);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.clrBlack,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios_new, color: AppColors.clrWhite,size: 30)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.10),
              const Text(
                AppString.strForgotPassword,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: AppColors.clrWhite,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                AppString.strForgotPasswordSubText,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.08),
              TextFormField(
                style: const TextStyle(color: AppColors.clrWhite),
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
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppString.strPleaseEnterYourEmail;
                  }
                  // Simple email validation regex
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return AppString.strPleaseEnterAValidEmail;
                  }
                  return null;
                },
              controller: email,
              ),
              SizedBox(height:MediaQuery.of(context).size.width * 0.15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: SizedBox()
                  ),
                  Flexible(
                    flex: 2,
                    child:  InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _resetPassword,
                      child: Container(
                        height: 55,
                        decoration:  BoxDecoration(color: AppColors.clrDeepPurple.withOpacity(0.5),borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Expanded(
                              child: Container(
                                height: 55,
                                padding: const EdgeInsets.symmetric(horizontal: 08),
                                decoration: const BoxDecoration(color: AppColors.clrDeepPurple,borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: const Center(
                                  child: Text(
                                    AppString.strResetPassword,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
