import 'package:flutter/material.dart';
import 'package:evgeshayoga/ui/login.dart';

import 'home.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Йога с Женей",
      initialRoute: '/',
      home: new Home(),
      ));
}