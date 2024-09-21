import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interviewtask/utils/app_string.dart';

import '../custom/custom_appbar.dart';
import '../custom/custom_button.dart';
import '../model/user_model.dart';
import '../utils/app_color.dart';
import '../utils/shar_pref.dart';
import '../utils/utils.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> workouts = ["Pushups", "Squats", "Lunges", "Plank"];
  final List<TextEditingController> scoreControllers = [];

  @override
  void initState() {
    super.initState();
    scoreControllers.addAll(workouts.map((_) => TextEditingController()));
  }

  Future<void> _markAsDone(int index) async {

    String?   userId = await Shared_Preferences.prefGetString(Shared_Preferences.keyUserId, "");
    String workoutName = workouts[index];
    int score = int.tryParse(scoreControllers[index].text) ?? 0;
    if (score < 0 || score > 100) {
      Utils().showToast(AppString.strNumberVail);
    }else{
      Utils().showToast('${workoutName.toString()} successful Done');
      FirebaseFirestore.instance
          .collection(AppString.tableUsers)
          .doc(userId.toString())
          .collection(AppString.tableWorkouts)
          .add({
        'workoutName': workoutName,
        'score': score,
        'date': Timestamp.now(),
        'isDone': true,
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.clrBlack,
      appBar: customAppbar(AppString.strHomeWorkouts,context),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(workouts[index],style: const TextStyle(color: AppColors.clrWhite),),
            subtitle: TextFormField(
              style: const TextStyle(color: AppColors.clrWhite),
              controller: scoreControllers[index],
              decoration: const InputDecoration(labelText: AppString.strScore),
              keyboardType: TextInputType.number,
            ),
            trailing:ButtonWidget(
               width: 70,
                height: 40,
                title: AppString.strDone,
                onTap: () => _markAsDone(index)),
          );
        },
      ),
    );
  }
}
