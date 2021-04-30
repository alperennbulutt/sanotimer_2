import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sanotimer2_5/widgets/buttons/arrowBack.dart';

class BluetoothAppMin extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothAppMin> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection minConn;

  bool isDisconnecting = false;

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => minConn != null && minConn.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  // ignore: unused_field
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      minConn.dispose();
      minConn = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
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
            padding: const EdgeInsets.only(top: 20),
            child: ArrowBack(),
          ),
          Container(
            padding: EdgeInsets.only(top: 150),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Cihaz :',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  DropdownButton(
                    underline: Container(
                      height: 2,
                      color: Colors.blue.shade300,
                    ),
                    isExpanded: false,
                    items: _getDeviceItems(),
                    onChanged: (value) => setState(() => _device = value),
                    value: _devicesList.isNotEmpty ? _device : null,
                  ),
                  // SizedBox(
                  //   width: 40,
                  //   height: 40,
                  ElevatedButton.icon(
                    onPressed: _connected ? disconnect : connect,
                    icon: (_connected
                        ? Icon(Icons.bluetooth_connected)
                        : Icon(Icons.bluetooth_disabled)),
                    label: Text(''), //sadece bağlan ikonu için veya tersi
                    // label: Text(
                    //   _connected ? 'Bağlantıyı Kes' : 'Bağlan',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     color: (_connected
                    //         ? Colors.lightGreenAccent.shade400
                    //         : Colors.white),
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    style: ElevatedButton.styleFrom(
                      primary: (_connected
                          ? Colors.blue.shade300
                          : Colors.red.shade400),
                      onPrimary: (_connected
                          ? Colors.lightGreenAccent.shade400
                          : Colors.white),
                    ),
                  ),
                ]),
          ),
        ],
      ),
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
      ////show('!!! Cihaz Seçilmedi !!!');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Cihaz Bağlandı!');
          minConn = _connection;
          setState(() {
            _connected = true;
          });
          //show('Cihaz Bağlandı!');
          minConn.input.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {
                _connected = false;
              });
              //show('Cihaz Bağlantısı Kesildi !'); //bağlanılan cihazdan
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
    await minConn.close();
    //show('Uygulama Bağlantısı Kesildi !'); //bt kapatılınca
    if (!minConn.isConnected) {
      setState(() {
        _connected = false;
      });
    }
  }

  void sendOnMessageToBluetooth() async {
    minConn.output.add(utf8.encode("{t}" + "\r\n"));
    await minConn.output.allSent;
    //show('$data');
    // setState(() {
    //   _deviceState = 1; // device on
    // });
  }
}
