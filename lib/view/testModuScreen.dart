import 'package:flutter/material.dart';
import 'package:sanotimer2_5/core/BluetoothAppMin.dart';
import 'package:sanotimer2_5/core/localDeneme/localStorage.dart';
import 'package:sanotimer2_5/core/localDeneme/sendData.dart';
import 'package:sanotimer2_5/main.dart';
import 'package:sanotimer2_5/widgets/buttons/arrowBack.dart';

class TestModuScreen extends StatefulWidget {
  @override
  _TestModuScreenState createState() => _TestModuScreenState();
}

class _TestModuScreenState extends State<TestModuScreen> {
  final myController = TextEditingController();
  LocalStorage localStorage = new LocalStorage();
  MyApp myApp = MyApp();
  String mesaj;
  String getMesaj;
  bool loading = false;

  @override
  void initState() {
    testModuDegerAl();

    super.initState();
  }

  void testModuDegerAl() async {
    getMesaj = await localStorage.getData();
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    //kaydedilen mesajı get ettiğimiz yer

    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFFFAF6F2),
          body: loading
              ? Column(
                  children: [
                    //Geri tuşu
                    ArrowBack(),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 90.0, left: 50, right: 50),
                      child: TextFormField(
                        controller: myController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Süre:$getMesaj",
                          labelStyle:
                              TextStyle(fontSize: 20.0, color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //textfileddan gelen veriyi sendData metotuna yollanması
                                  String textFieldGet = myController.text;
                                  mesaj = "{o,$textFieldGet}";

                                  sendData(mesaj);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      color: Colors.red),
                                  height: _size.height * 0.08,
                                  width: _size.width * 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Center(
                                        child: Text(
                                      'Kaydet ve Gönder',
                                      style: TextStyle(
                                        fontSize: _size.width * 0.09,
                                      ),
                                    )),
                                  ),
                                ),
                              ),

                              //2. buton
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BluetoothAppMin()));

                                  //textfileddan gelen veriyi sendData metotuna yollanması
                                  String textFieldGet = myController.text;
                                  mesaj = "{o,$textFieldGet}";

                                  sendData(mesaj);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      color: Colors.red),
                                  height: _size.height * 0.08,
                                  width: _size.width * 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Center(
                                        child: Text(
                                      'BT Bağlan',
                                      style: TextStyle(
                                        fontSize: _size.width * 0.09,
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator())),
    );
  }
}
