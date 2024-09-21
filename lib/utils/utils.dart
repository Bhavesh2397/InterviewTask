

import 'package:fluttertoast/fluttertoast.dart';
import 'package:interviewtask/utils/app_color.dart';

class Utils {

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor:  AppColors.clrGreen,
        textColor: AppColors.clrWhite,
        fontSize: 15.0);
  }
}
