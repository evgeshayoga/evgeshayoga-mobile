import 'package:flutter/material.dart';

class HomeAnimation {
  HomeAnimation(this.controller)
  : bgdropOpacity = Tween(begin: 0.5, end: 1.000).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.0, 1.0, curve: Curves.linear))),
  titleOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.100, 1.000, curve: Curves.linear))),
  titleSize = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.100, 1.000, curve: Curves.linear)));

  final AnimationController controller;
  final Animation<double> bgdropOpacity;
  final Animation<double> titleOpacity;
  final Animation<double> titleSize;

}