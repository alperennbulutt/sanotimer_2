import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
//import 'package:sanotimer2/local_storage.dart';
import 'package:sanotimer2_5/bt_connection.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sanotimer2_5/local_storage.dart';
import 'package:sanotimer2_5/send_data.dart';
import 'bt_connection.dart';

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

class _MyAppState extends State<MyApp> {
  String data;
  String getMesaj;

  Bluetooth bluetooth =
      new Bluetooth(false, ""); //false da olsa true, true da olsa true mu?
  // LocalStorage localStorage = new LocalStorage();
  final textController = TextEditingController();
  LocalStorage localStorage = new LocalStorage();

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
  // bool _isButtonUnavailable = false;

  void degerAl() async {
    getMesaj = await localStorage.getData();
    setState(() {});
  }

  @override
  void initState() {
    degerAl();
    super.initState();
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
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Cihaz Seç >>',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton(
                  items: _getDeviceItems(),
                  onChanged: (value) => setState(() => _device = value),
                  value: _devicesList.isNotEmpty ? _device : null,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _connected ? disconnect : connect,
                    icon: (_connected
                        ? Icon(Icons.bluetooth_connected)
                        : Icon(Icons.bluetooth_disabled)),
                    label: Text(
                      _connected ? 'Bağlantıyı Kes' : 'Bağlan',
                      style: TextStyle(
                        fontSize: 20,
                        color: (_connected
                            ? Colors.lightGreenAccent.shade400
                            : Colors.white),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: (_connected
                          ? Colors.blue.shade300
                          : Colors.red.shade400),
                      onPrimary: (_connected
                          ? Colors.lightGreenAccent.shade400
                          : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Dakika:$getMesaj',
              ),
            ),
          ),
          Row(
            children: [
              //Veri yolla button
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        data = textController.text;
                        sendData(data);
                        show("Veriniz kaydedildi");
                      },
                      child: Text("Kaydet")),
                ),
              ),
              //Bt gönder button
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (isConnected == true) {
                          _sendOnMessageToBluetooth(getMesaj);
                          show("Cihaza $getMesaj yollandı");
                          print("gömülü sisteme mevcut mesaj yollandı");
                        } else {
                          //print(getMesaj);
                          show("BT bağlantısını kontrol ediniz.");
                        }
                      },
                      //yada null veya connect fonksiyonu
                      child: Text(
                          "BT Gönder")), //bağlıysa gönder değilse önce bağlan 2.ye gönder
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('Cihaz YOK'),
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
      show('!!! Cihaz Seçilmedi !!! - Uygulamayı Tekrar Açınız!');
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
              show('Cihaz Bağlantısı Kayboldu !'); //bağlanılan cihazdan
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
    show('Uygulama Bağlantısı Kesildi !'); //bt kapatılınca
    if (!blueConn.isConnected) {
      setState(() {
        _connected = false;
      });
    }
  }

  void dataSend() async {
    data = textController.text;
    bluetooth.sendData("{o,$data}");
    show("veriniz yollandı,yollanan veri : " + '$data');
  }

  void alert() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bağlı Değilsiniz!'),
          content: Text(
              'Göndermek istenilen "$data", Karakter Sayısı = ${data.characters.length}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  void _sendOnMessageToBluetooth(String data) async {
    var connection;
    connection.output.add(data);

    await connection.output.allSent;
    //show('Kanal 1 - AÇIK');
    // setState(() {
    //   _deviceState = 1; // device on
    // });
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
