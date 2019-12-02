import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

Widget progressHUD() {
  return Container(
    child: ModalProgressHUD(
      color: Colors.transparent,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Style.pinkMain),
      ),
      inAsyncCall: true,
      child: Center(
        child: Text(
          "Загружается...",
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
