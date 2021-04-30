import 'package:sanotimer2_5/core/localDeneme/localStorage.dart';

void sendData(String message) {
  LocalStorage localStorage = new LocalStorage();

  localStorage.saveData(message);
}

Future<String> getData() {
  LocalStorage localStorage = new LocalStorage();

  var mesaj = localStorage.getData();
  return mesaj;
}
