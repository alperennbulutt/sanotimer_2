  //homescreen's buttons
  import 'package:flutter/material.dart';

Expanded homeScreenButton(BuildContext context, Size _size, String text,
      [Widget routeScreen]) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => routeScreen));
        },
        child: Container(
          alignment: Alignment.center,
          
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF8EC5FC)),
          height: _size.height * 0.13,
          width: _size.width * 0.8,
          child:  Text(
              text,
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            )
          
        ),
      ),
    );
  }