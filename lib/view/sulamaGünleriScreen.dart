import 'package:flutter/material.dart';
import 'package:sanotimer2_5/widgets/buttons/arrowBack.dart';
import 'package:sanotimer2_5/widgets/buttons/gunlerButton.dart';

class SulamaGunleriScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFAF6F2),
      body: Center(
        child: Column(
          children: [
            Expanded(child: ArrowBack()),
            gunlerButonu("Pazartesi"),
            gunlerButonu("Salı"),
            gunlerButonu("Çarşamba"),
            gunlerButonu("Perşembe"),
            gunlerButonu("Cuma"),
            gunlerButonu("Cumartesi"),
            gunlerButonu("Pazar"),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: _size.width * 0.8,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      color: Colors.red),
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
            )
          ],
        ),
      ),
    );
  }
}
