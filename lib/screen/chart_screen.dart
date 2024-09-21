import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../custom/custom_appbar.dart';
import '../model/user_model.dart';
import '../utils/app_color.dart';
import '../utils/app_string.dart';
import '../utils/shar_pref.dart';


class ChartPage extends StatefulWidget {

  ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List workouts = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkouts();
  }

  Future<void> _fetchWorkouts() async {
    String?   userId = await Shared_Preferences.prefGetString(Shared_Preferences.keyUserId, "");
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(AppString.tableUsers)
        .doc(userId.toString())
        .collection(AppString.tableWorkouts)
        .get();

    setState(() {
      workouts = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.clrBlack,
      appBar:customAppbar(AppString.strWorkoutChart,context),
      body: Center(
        child: Container(
          height: 300,
          child: workouts.isNotEmpty ? _buildBarChart() : const Text(AppString.strNoWorkoutsAvailable),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: workouts.map((doc) {
        var workout = doc.data();
        double height = (workout['score'] / 100) * 200;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(workout['workoutName'],style: const TextStyle(color: AppColors.clrWhite)),
            Container(
              width: 40,
              height: height,
              color: Colors.blue,
            ),
            Text('${workout['score']}',style: const TextStyle(color: AppColors.clrWhite),),
          ],
        );
      }).toList(),
    );
  }
}
