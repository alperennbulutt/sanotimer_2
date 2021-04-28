//Single Alert Dialog
  import 'package:flutter/material.dart';

AlertDialog alertSingleDialog(BuildContext context,String title,String action1,[Widget routeScreen]) {
    return AlertDialog(
      title: Text(title),
      actions: [
        TextButton(
          child: Text(action1),
          onPressed: () {
             Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => routeScreen));
            
            
            
          },
        ),
      ],
    );
  }