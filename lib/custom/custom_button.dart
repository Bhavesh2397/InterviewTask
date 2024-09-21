
import 'package:flutter/material.dart';
import 'package:interviewtask/utils/app_color.dart';

class ButtonWidget extends StatelessWidget {
  String? title;
  double? height;
  double? width;
  Color? bgColor;
  GestureTapCallback? onTap;
  double? borderRadius;

   ButtonWidget({this.title,this.height,this.bgColor,this.onTap,this.borderRadius,this.width,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        height: height ?? MediaQuery.of(context).size.width*0.15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            color: bgColor ?? AppColors.clrDeepPurple),
        child:  Center(
          child: Text(
            title.toString(),
            style:  const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.clrWhite),
          ),
        ),
      ),
    );
  }
}
