import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';

Widget HeaderTextBlack(String value){
  return Text(
    value,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    style: headTextStyle(
        fontSize: dimen20,
        color: Colors.black),
  );
}

Widget HeaderTextWhite(String value){
  return Text(
    value,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    style: headTextStyle(
        fontSize: dimen20,
        color: Colors.white),
  );
}

Widget HeaderTextThemePrimary(String value){
  return Text(
    value,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    style: headTextStyle(
        fontSize: dimen20,
        color: AppColors.textPrimary),
  );
}

Widget HeaderTextThemeSecondary(String value){
  return Text(
    value,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    style: headTextStyle(
        fontSize: dimen20,
        color: AppColors.textSecondary),
  );
}