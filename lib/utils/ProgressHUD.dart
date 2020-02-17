import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

Widget progressHUD(isInAsyncCall) {
  return Container(
    child: ModalProgressHUD(
      color: Colors.transparent,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Style.pinkMain),
      ),
      inAsyncCall: isInAsyncCall,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Text(
            "Загружается...",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}
