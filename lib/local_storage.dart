import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final String gelenMesaj = "";
  final int deger = 0;

  //veri kaydetme
  Future<bool> saveData(
    String mesaj,
  ) async {
    //int gelenDeger;
    final pref = await SharedPreferences.getInstance();

    var message = pref.setString(gelenMesaj, mesaj);
    // var deger = pref.setInt('degerim', gelenDeger);

    print("Save edilen mesaj : {$mesaj}");
    return message;
  }

  //veri kaydetme int
  Future<void> saveDataInt(
    int deger,
  ) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt('key', deger);
  }

//verileri alma
  Future<String> getData() async {
    final pref = await SharedPreferences.getInstance();
    String mesaj = pref.getString(gelenMesaj);

    if (mesaj == null) {
      return '';
    }
    print("get edilen mesaj degeri : {$mesaj}");

    return mesaj;
  }

//verileri alma int
  Future<int> getDataInt() async {
    final pref = await SharedPreferences.getInstance();
    int deger = pref.getInt('key');
    if (deger == null) {
      deger = 0;
    }

    return deger;
  }

  //verileri silme
  Future<void> removeData() async {
    final pref = await SharedPreferences.getInstance();
    //pref.remove(gelenMesaj);
    pref.clear();
    print("veriler silindi");
  }
}
