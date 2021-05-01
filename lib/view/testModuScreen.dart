import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sanotimer2_5/core/BluetoothAppMin.dart';
import 'package:sanotimer2_5/core/localDeneme/localStorage.dart';
import 'package:sanotimer2_5/core/localDeneme/sendData.dart';
import 'package:sanotimer2_5/main.dart';
import 'package:sanotimer2_5/widgets/buttons/arrowBack.dart';

import '../core/BluetoothAppMin.dart';
import '../receive_data.dart';

class TestModuScreen extends StatefulWidget {
  @override
  _TestModuScreenState createState() => _TestModuScreenState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _TestModuScreenState extends State<TestModuScreen> {
  final myController = TextEditingController();
  LocalStorage localStorage = new LocalStorage();
  MyApp myApp = MyApp();
  String mesaj;
  String getMesaj;
  bool loading = false;
  BackData backData = new BackData();
  List<_Message> messages = <_Message>[];
  //String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // LocalStorage localStorage = new LocalStorage();
  final textController = TextEditingController();

  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection blueConn;

  bool isDisconnecting = false;
  // To track whether the device is still connected to Bluetooth
  bool get isConnected => blueConn != null && blueConn.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;

  bool _connected = false;

  void testModuDegerAl() async {
    getMesaj = await localStorage.getData();
    setState(() {
      loading = true;
    });
  }

  @override
  void initState() {
    testModuDegerAl();
    super.initState();
    //onDataReceived();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    enableBluetooth();
    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          // _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      blueConn.dispose();
      blueConn = null;
    }
    super.dispose();
  }

  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Beklenmeyen Hata!");
    }
    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }
    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
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
                                onTap: () async {
                                  //textfileddan gelen veriyi sendData metotuna yollanması
                                  String textFieldGet = myController.text;
                                  mesaj = "{o,$textFieldGet}";

                                  sendData(mesaj);
                                  await _sendOnMessageToBluetooth();
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

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('CİHAZ YOK / BT KAPALI !'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void connect() async {
    if (_device == null) {
      show('!!! Cihaz Seçilmedi !!!');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Cihaz Bağlandı!');
          blueConn = _connection;
          setState(() {
            _connected = true;
          });
          show('Cihaz Bağlandı!');
          blueConn.input.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {
                _connected = false;
              });
              show('Cihaz Bağlantısı Kesildi !'); //bağlanılan cihazdan
            }
          });
        }).catchError((error) {
          print('Beklenmeyen Hata!');
          print(error);
        });
        //show('Cihaz Bağlandı!');
      }
    } // bağlantı durumu
  } //null durumda buton pasif

  // Method to disconnect bluetooth
  void disconnect() async {
    await blueConn.close();
    //show('Uygulama Bağlantısı Kesildi !'); //bt kapatılınca
    if (!blueConn.isConnected) {
      setState(() {
        _connected = false;
      });
    }
  }

  _sendOnMessageToBluetooth() async {
    var msj = await localStorage.getData();
    print("sendOnMEssageToBluetooth'a giden veri: " + msj);
    blueConn.output.add(utf8.encode("{$msj}" + "\r\n"));
    await blueConn.output.allSent;
    //show('$data');
    // setState(() {
    //   _deviceState = 1; // device on
    // });
  }

  // ignore: unused_element
  void _dataReceiver(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => BackData()));
  }

//veri alma
  void onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
