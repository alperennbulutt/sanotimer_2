import 'package:sanotimer2_5/local_storage.dart';

class Bluetooth {
  String data;
  bool connection;

  Bluetooth(bool connection, String data) {
    this.connection = connection;
    this.data = data;
  }

  //BT connection controller
  bool connectionMethod() {
    connection = true; //data için true kabul ettim
    //bağlantının durumunu return edecek
    return connection;
  }

  //this method sends data from sendData() to embedded system
  String sendDataEmbeddedSystem() {
    var localData = sendData(data);
    return localData;
  }

  //this method sends any data
  String sendData(String data) {
    LocalStorage localStorage = new LocalStorage();

    bool btConnection = connectionMethod();
    if (btConnection == true) {
      // print("veriniz yollandı,yollanan veri :  " + data);
      localStorage.saveData(data);
    } else
      print("veriniz yollanamadı");

    //when bt connection is true this send data
    return data;
  }

  Future<String> getData() {
    LocalStorage localStorage = new LocalStorage();

    var mesaj = localStorage.getData();
    return mesaj;
  }
}
