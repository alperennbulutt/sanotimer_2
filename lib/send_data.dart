import 'package:sanotimer2_5/local_storage.dart';

void sendData(String message) {
  LocalStorage localStorage = new LocalStorage();
  print("Local'e yollanan mesaj : {$message} ");
  localStorage.saveData(message);
}

Future<String> getData() {
  LocalStorage localStorage = new LocalStorage();

  var mesaj = localStorage.getData();
  return mesaj;
}
