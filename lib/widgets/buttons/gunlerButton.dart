//gunler butonları
  import 'package:flutter/material.dart';

Expanded gunlerButonu(gun) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
              onPressed: () {},
              child: Text(
                gun,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              textColor: Colors.black,
              highlightColor: Colors.redAccent,
              minWidth: 200,
              height: 40,
              shape: Border.all(width: 2.0, color: Colors.black)),
        ],
      ),
    );
  }