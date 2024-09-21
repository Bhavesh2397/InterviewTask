import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../custom/custom_appbar.dart';
import '../custom/custom_button.dart';
import '../model/user_model.dart';
import '../utils/app_color.dart';
import '../utils/app_string.dart';
import '../utils/shar_pref.dart';

class WorkoutListPage extends StatefulWidget {
  WorkoutListPage({Key? key}) : super(key: key);

  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  String selectedDate = '';
  List workouts = [];
  bool isLoader = false;
  bool isDataFound = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWorkouts();
  }

  Future<void> _fetchWorkouts({String? date}) async {
    setState(() {
      isLoader = true;
    });
    String? userId = await Shared_Preferences.prefGetString(
        Shared_Preferences.keyUserId, "");
    Query query = FirebaseFirestore.instance
        .collection(AppString.tableUsers)
        .doc(userId.toString())
        .collection(AppString.tableWorkouts);

    if (date != null && date.isNotEmpty) {
      DateTime selectedDate = DateTime.parse(date);
      // Get the start and end of the day
      DateTime startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
      DateTime endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

      // Create Timestamp objects for the start and end of the day
      Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
      Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

      // Query for workouts that fall within this range
      query = query.where('date', isGreaterThanOrEqualTo: startTimestamp)
          .where('date', isLessThanOrEqualTo: endTimestamp);
    }
    QuerySnapshot snapshot = await query.get();
    setState(() {
      workouts = snapshot.docs;
      isLoader = false;
      isDataFound = workouts.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.clrBlack,
      appBar: customAppbar(AppString.strWorkoutList, context),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedDate = '';
              });
              _fetchWorkouts();
            },
            child: const Text(AppString.strShowAllWorkouts, style: const TextStyle(fontSize: 18, color: Colors.green)),
          ),
          TextButton(
            onPressed: () async {
              String date = await _selectDate();
              setState(() {
                selectedDate = date;
              });
              await _fetchWorkouts(date: selectedDate);
            },
            child: Text(
              '${AppString.strFilterByDate}: ${selectedDate.isEmpty ? '' : DateFormat('yyyy-MM-dd – hh:mm a').format(DateTime.parse(selectedDate))}',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
          ),
          /**/
          Expanded(
            child: isLoader
                ? const Center(
                    child: CircularProgressIndicator(
                    color: AppColors.clrDeepPurple,
                  ))
                : (!isDataFound)
                    ? const Center(
                        child: Text(
                        AppString.strNoWorkoutsAvailable,
                        style:
                            TextStyle(color: AppColors.clrWhite, fontSize: 15),
                      ))
                    : ListView.builder(
                        itemCount: workouts.length,
                        itemBuilder: (context, index) {
                          var workout = workouts[index].data();
                          return ListTile(
                            title: Text(
                              workout['workoutName'],
                              style: const TextStyle(
                                  color: AppColors.clrDeepPurple, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date: ${DateFormat('yyyy-MM-dd – hh:mm a').format(workout['date'].toDate())}',
                                  style: const TextStyle(
                                      color: AppColors.clrWhite, fontSize: 15),
                                ),
                                Text('Score: ${workout['score']}',
                                    style: const TextStyle(
                                        color: AppColors.clrWhite,
                                        fontSize: 15)),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Future<String> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      return pickedDate.toString();
    }
    return '';
  }
}
