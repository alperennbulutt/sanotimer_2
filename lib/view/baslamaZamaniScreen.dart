import 'package:flutter/material.dart';
import 'package:sanotimer2_5/core/localDeneme/localStorage.dart';
import 'package:sanotimer2_5/widgets/buttons/arrowBack.dart';

class BaslamaZamaniScreen extends StatefulWidget {
  @override
  _BaslamaZamaniScreenState createState() => _BaslamaZamaniScreenState();
}

class _BaslamaZamaniScreenState extends State<BaslamaZamaniScreen> {
  LocalStorage localStorage = new LocalStorage();
  int counter = 0;
  bool loading = false;

  void incrementCounter() {
    setState(() {
      counter++;
      if (counter > 8) {
        counter = 8;
      }
    });
  }

  void counterGet() async {
    counter = await localStorage.getDataInt();
    print("counter : " + counter.toString());
    setState(() {
      loading = true;
    });
  }

  @override
  void initState() {
    print("buraya" + counter.toString());
    counterGet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xFFFAF6F2),
      body: loading
          ? Stack(
              children: [
                ArrowBack(),
                Row(
                  children: [
                    Expanded(
                      child: SafeArea(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              FloatingActionButton(
                                backgroundColor: Colors.black,
                                child: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    incrementCounter();
                                    localStorage.saveDataInt(counter);
                                  });
                                },
                              ),
                              Text(
                                'Program Ekle',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: _size.height * 0.65,
                  margin: EdgeInsets.only(top: 120),
                  child: ListView.builder(
                    itemCount: counter.clamp(counter == null ? 0 : counter, 8),
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
                              labelStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.black),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              color: Colors.red),
                          height: _size.height * 0.12,
                          width: _size.width * 0.8,
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
                  ],
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    ));
  }
}
