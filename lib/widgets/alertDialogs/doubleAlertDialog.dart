//doble alert dialog
import 'package:flutter/material.dart';
import 'package:sanotimer2_5/widgets/alertDialogs/singleAlertDialog.dart';

import '../../local_storage.dart';

AlertDialog alertDobleSingle(BuildContext context, String title, String content,
    String action1, String action2,
    [Widget routeScreen]) {
  LocalStorage localStorage = new LocalStorage();
  return AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      TextButton(
        child: Text(action1),
        onPressed: () {
          localStorage.removeData();

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => alertSingleDialog(
                  context,
                  'Tüm Verileriniz Sıfırlandı',
                  'Tamam',
                ),
              ));
        },
      ),
      TextButton(
        child: Text(action2),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => routeScreen));
        },
      ),
    ],
  );
}
