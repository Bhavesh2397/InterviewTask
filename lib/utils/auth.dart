
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';
import 'app_string.dart';


class AuthService{
  UserModel? userDataModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  Future<UserModel?> fetchUserData() async {
    user = _auth.currentUser;
    try {
      DocumentSnapshot snapshot = await _firestore.collection(AppString.tableUsers).doc(user!.uid).get();
      if (snapshot.exists) {
        userDataModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>) ;
        print('User data: $userDataModel');
        return userDataModel;
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Failed to get user data: $e');
    }
  }

}