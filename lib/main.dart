import 'dart:convert';
// ignore: unused_import
import 'dart:typed_data';
import 'package:sanotimer2_5/receive_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
//import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sanotimer2_5/local_storage.dart';
import 'package:sanotimer2_5/view/baslamaZamaniScreen.dart';
import 'package:sanotimer2_5/view/manuelAyarlamaScreen.dart';
import 'package:sanotimer2_5/view/sulamaG%C3%BCnleriScreen.dart';
import 'package:sanotimer2_5/view/sulamaSuresiScreen.dart';
import 'package:sanotimer2_5/view/tarihZamanSceen.dart';
import 'package:sanotimer2_5/view/testModuScreen.dart';
import 'package:sanotimer2_5/widgets/alertDialogs/doubleAlertDialog.dart';
import 'package:sanotimer2_5/widgets/alertDialogs/singleAlertDialog.dart';
import 'package:sanotimer2_5/widgets/buttons/homeScreenButton.dart';
import 'package:sanotimer2_5/widgets/buttons/testModuButton.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFAF6F2),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xFFEDD3C1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        title: Text(
          "SanoTimer",
          style: TextStyle(color: Colors.black, fontSize: _size.width * 0.1),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //aç kapa butonu
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => alertSingleDialog(
                                    context,
                                    'Aç/Kapa işlemi gerçekleşti',
                                    'Tamam',
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          color: Colors.red),
                      height: _size.height * 0.12,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Center(
                            child: Text(
                          'Aç/Kapa',
                          style: TextStyle(
                            fontSize: _size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //Manuel Ayarlama butonu
            Row(
              children: [
                homeScreenButton(
                    context, _size, "Manuel Ayarlama", ManuelAyarlamaScreen()),
              ],
            ),
            //Tarih/Zaman ve Sulama günleri Butonları
            Row(
              children: [
                //Tarih/zaman butonu
                homeScreenButton(
                    context, _size, "Tarih/Zaman", TarihZamanScreen()),
                //Sulama Günleri
                homeScreenButton(
                    context, _size, "Sulama Günleri", SulamaGunleriScreen()),
              ],
            ),
            //Sulama süresi ve Başlama zamanı süresi butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Sulama Süresi butonu
                homeScreenButton(
                    context, _size, "Sulama Süresi", SulamaSuresiScreen()),
                //Başlama zamanı butonu
                homeScreenButton(
                    context, _size, "Başlama Zamanı", BaslamaZamaniScreen()),
              ],
            ),
            //Sıfırla ve test modu butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Sıfırla butonu
                homeScreenButton(
                    context,
                    _size,
                    "Sıfırla",
                    alertDobleSingle(
                      context,
                      'Tüm Verileriniz Sıfırlanacaktır.',
                      'Sıfırlama işleminden emin misiniz?',
                      'Evet',
                      'Hayır',
                    )),
                //Test modu butonu
                homeScreenButton(
                  context,
                  _size,
                  "Test Modu",
                  TestModuScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
