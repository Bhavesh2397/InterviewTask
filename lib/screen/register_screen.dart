import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interviewtask/custom/bottom_navigation.dart';
import 'package:interviewtask/utils/app_color.dart';
import 'package:interviewtask/utils/app_string.dart';
import '../utils/auth.dart';
import '../utils/shar_pref.dart';
import '../utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  TextEditingController firstNameCon = TextEditingController();
  TextEditingController lastNameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController confirmPasswordCon = TextEditingController();
  TextEditingController contactNoCon = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  String gender = 'Male';
  DateTime? dateOfBirth;
  bool _isPasswordVisible = false;
  bool _isConPasswordVisible = false;

  bool _isLoading = false; // State to handle loader

  // Function to handle registration
  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailCon.text.trim(),
          password: passwordCon.text.trim(),
        );
        // Add user details to Firestore
        await FirebaseFirestore.instance
            .collection(AppString.tableUsers)
            .doc(userCredential.user!.uid)
            .set({
          'id': userCredential.user!.uid,
          'firstName': firstNameCon.text.trim(),
          'lastName': lastNameCon.text.trim(),
          'email': emailCon.text.trim(),
          'gender': gender,
          'dateOfBirth': dateOfBirth,
          'contactNo': contactNoCon.text.trim(),
          'create_date': DateTime.now().toString(),
          'profileImageUrl': '',
        });
        Utils().showToast(AppString.strRegistrationSuccessful);
        await AuthService().fetchUserData().then((val) {
          Shared_Preferences.prefSetString(
              Shared_Preferences.keyUserId, val!.id.toString());
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavigationScreen()));
      } on FirebaseAuthException catch (e) {
        Utils().showToast("Error: ${e.message}");
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
      backgroundColor: AppColors.clrBlack,
      appBar: AppBar(
        backgroundColor: AppColors.clrBlack,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new,
                color: AppColors.clrWhite, size: 30)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            const Text(
              AppString.strCreateAccount,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: AppColors.clrWhite,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              AppString.strRegistrationSubtitle,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextFormField(
                    style: const TextStyle(color: AppColors.clrWhite),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.grey),
                      hintText: AppString.strFirstName,
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value!.isEmpty
                        ? AppString.strPleaseEnterYourFirstName
                        : null,
                    controller: firstNameCon,
                  ),
                  TextFormField(
                    style: const TextStyle(color: AppColors.clrWhite),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.grey),
                      hintText: AppString.strLastName,
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value!.isEmpty
                        ? AppString.strPleaseEnterYourLastName
                        : null,
                    controller: lastNameCon,
                  ),
                  TextFormField(
                    style: const TextStyle(color: AppColors.clrWhite),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email, color: Colors.grey),
                      hintText: AppString.strEmail,
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      const emailRegex =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      if (value == null || value.isEmpty) {
                        return AppString.strPleaseEnterYourEmail;
                      }
                      if (!RegExp(emailRegex).hasMatch(value)) {
                        return AppString.strPleaseEnterAValidEmail;
                      }
                      return null;
                    },
                    controller: emailCon,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    style: const TextStyle(color: AppColors.clrWhite),
                    decoration: InputDecoration(
                      hintText: AppString.strPassword,
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle password visibility
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) => value!.isEmpty
                        ? AppString.strPleaseEnterYourPassword
                        : null,
                    controller: passwordCon,
                  ),
                  TextFormField(
                    controller: confirmPasswordCon,
                    style: const TextStyle(color: AppColors.clrWhite),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      hintText: AppString.strConfirmPassword,
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConPasswordVisible =
                                !_isConPasswordVisible; // Toggle password visibility
                          });
                        },
                      ),
                    ),
                    obscureText: !_isConPasswordVisible,
                    validator: (value) {
                      if (value != passwordCon.text.trim()) {
                        return AppString.strPasswordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 08),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        const Text(
                          AppString.strGender,
                          style: TextStyle(color: AppColors.clrWhite),
                        ),
                        Radio<String>(
                          value: AppString.strMale,
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        const Text(AppString.strMale,
                            style: TextStyle(color: AppColors.clrWhite)),
                        Radio<String>(
                          value: AppString.strFemale,
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        const Text(AppString.strFemale,
                            style: TextStyle(color: AppColors.clrWhite)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 08),
                  TextFormField(
                    style: const TextStyle(color: AppColors.clrWhite),
                    decoration: InputDecoration(
                        hintText: AppString.strContactNo,
                        prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        )),
                    validator: (value) {
                      String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                      RegExp regExp = new RegExp(patttern);
                      if (value!.length == 0) {
                        return AppString.strPleaseEnterMobileNumber;
                      } else if (!regExp.hasMatch(value)) {
                        return AppString.strPleaseEnterValidMobileNumber;
                      }
                      return null;
                    },
                    controller: contactNoCon,
                    keyboardType: TextInputType.phone,
                  ),
                  TextFormField(
                    style: const TextStyle(color: AppColors.clrWhite),
                    decoration: InputDecoration(
                        hintText: AppString.strDateOfBirth,
                        prefixIcon:
                            const Icon(Icons.date_range, color: Colors.grey),
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        )),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          dateOfBirth = pickedDate;
                        });
                      }
                    },
                    validator: (value) => dateOfBirth == null
                        ? AppString.strPleaseSelectYourDateOfBirth
                        : null,
                    readOnly: true,
                    controller: TextEditingController(
                      text: dateOfBirth == null
                          ? ''
                          : "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}",
                    ),
                  ),
                  const SizedBox(height: 08),
                ],
              ),
            ),

            const SizedBox(height: 30),
            _isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Display loader while logging in
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Expanded(
                        child: _isLoading
                            ? const Center(
                                child:
                                    CircularProgressIndicator()) // Display loader while logging in
                            : InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: registerUser,
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: AppColors.clrDeepPurple
                                          .withOpacity(0.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 55,
                                          decoration: const BoxDecoration(
                                              color: AppColors.clrDeepPurple,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: const Center(
                                            child: Text(
                                              AppString.strCreate,
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
            SizedBox(height: MediaQuery.of(context).size.width * 0.10),
            const Text(AppString.strAlreadyHaveAnAccount,
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(AppString.strLogin,
                    style: TextStyle(color: AppColors.clrWhite, fontSize: 16))),
            // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
