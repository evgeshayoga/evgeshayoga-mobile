import 'package:flutter/material.dart';

bool checkIsLandscape(BuildContext context){
  const int tabletBreakpoint = 600;
  var shortestSide = MediaQuery.of(context).size.shortestSide;
  var orientation = MediaQuery.of(context).orientation;
  var isLandscape = true;
  if (orientation == Orientation.portrait &&
      shortestSide < tabletBreakpoint) {
    isLandscape = false;
  }
  return isLandscape;
}

