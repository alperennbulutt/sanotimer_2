import 'package:flutter/material.dart';
import 'package:sanotimer2_5/widgets/buttons/arrowBack.dart';

class ManuelAyarlamaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFAF6F2),
      body: Column(
        children: [
          ArrowBack(),
          manuelTextField("Vana no:"),
          manuelTextField("Süre:"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(45.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(10),
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
    );
  }

  Expanded manuelTextField(text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: TextFormField(
          keyboardType: TextInputType.number,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            labelText: text,
            labelStyle: TextStyle(fontSize: 20.0, color: Colors.black),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
