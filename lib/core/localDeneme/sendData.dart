import 'package:sanotimer2_5/core/localDeneme/localStorage.dart';

import 'btHaberlesme.dart';

void sendData(String message) {
  BtHaberlesme btHaberlesme = new BtHaberlesme();
  LocalStorage localStorage = new LocalStorage();
  print("yollanan mesaj : " + message);

  btHaberlesme.btHaberlesme(message);
  localStorage.saveData(message);
}

Future<String> getData() {
  LocalStorage localStorage = new LocalStorage();

  var mesaj = localStorage.getData();
  return mesaj;
}
