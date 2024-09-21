import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interviewtask/screen/home_screen.dart';

import '../screen/chart_screen.dart';
import '../screen/workout_list_screen.dart';
import '../utils/app_color.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    WorkoutListPage(),
    ChartPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            _onBackPressed();
            return false;
          },
          child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
       backgroundColor: AppColors.clrDeepPurple,
        selectedItemColor: AppColors.clrWhite,
        unselectedItemColor: AppColors.clrBlack,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Chart',
          ),
        ],
      ),
    );
  }

  Future<bool?> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Do you want to exit the App'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () async {
                if (Platform.isAndroid) {
                  await SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop');
                } else {
                  exit(0);
                }
              },
            )
          ],
        );
      },
    );
  }
}