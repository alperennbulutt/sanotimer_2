import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaglanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Boyut değiştirirken kulanılan değişken _size
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
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Ekrandaki mesaj
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Cihaza bağlanmak için BAĞLAN düğmesine tıklayınız',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _size.width * 0.035,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
