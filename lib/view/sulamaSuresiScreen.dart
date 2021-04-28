import 'package:flutter/material.dart';
import 'package:sanotimer2_5/widgets/buttons/arrowBack.dart';

class SulamaSuresiScreen extends StatefulWidget {
  @override
  _SulamaSuresiScreenState createState() => _SulamaSuresiScreenState();
}

class _SulamaSuresiScreenState extends State<SulamaSuresiScreen> {
  //kullanıcının programı
  int value = 10;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFAF6F2),
        body: Stack(
          children: [
            ArrowBack(),
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 70),
                height: _size.height * 0.65,
                width: _size.width * 0.95,
                child: ListView.builder(
                  itemCount: value,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Program :SS:DD',
                            labelStyle:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 100, left: 50, right: 50),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: Colors.red),
                    height: _size.height * 0.12,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Center(
                          child: Text(
                        'GÖNDER',
                        style: TextStyle(
                          fontSize: _size.width * 0.09,
                        ),
                      )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
