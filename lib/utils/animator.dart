import 'package:evgeshayoga/ui/home_screen.dart';
import 'package:flutter/material.dart';
class HomeAnimator extends StatefulWidget {
  @override
  _HomeAnimatorState createState() => _HomeAnimatorState();
}

class _HomeAnimatorState extends State<HomeAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Home(controller: _controller);
  }
}