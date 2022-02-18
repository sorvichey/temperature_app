import 'dart:convert';
import 'dart:io';
import 'package:do_login/HomeScreen/scan_fail.dart';
import 'package:do_login/HomeScreen/success.dart';
import 'package:do_login/Widget/footer.dart';
import 'package:do_login/Widget/header.dart';
import 'package:do_login/Widget/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class DoScan extends StatefulWidget {
  const DoScan({Key? key}) : super(key: key);
  @override
  _DoScanState createState() => _DoScanState();
}

class _DoScanState extends State<DoScan> {
  var url =
      "https://foauthtest.dynamic.com.kh/api/warehousetemperature/saverecordtemperature";
  late SharedPreferences logindata;
  late String? username;
  late String? token;
  late String? refreshToken;
  TextEditingController temperature = TextEditingController();
  TextEditingController humidity = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectToken();
    scanQR();
  }

   connectToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
      token = prefs.getString('token');
      refreshToken = prefs.getString('refreshToken');
    });
  }

  String _scanBarcode = 'Unknown';
  String _scanDate = DateFormat('d-MM-yyyy kk:mm').format(DateTime.now());
  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderApp(),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: ListTile(
                leading: Icon(Icons.qr_code_2_outlined, size: 62),
                contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                title: Text('${_scanBarcode}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w700)),
                subtitle: Text("Date: ${_scanDate}",
                    style: TextStyle(color: Colors.black45)),
              ),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 50),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: temperature,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Temperature',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: humidity,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Humidity',
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
                child: Column(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xff001CD1),
                    primary: Colors.white,
                    minimumSize: Size(200, 50),
                  ),
                  onPressed: () {
                    createData();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      )),
      bottomNavigationBar: FooterApp(),
    );
  }

  createData() async {
    var LocationCode = "${_scanBarcode}";
    var TemperatureLevel = double.parse(temperature.text);
    var HumidityLevel = double.parse(humidity.text);
    var data = json.encode({
      "LocationCode": LocationCode,
      "TemperatureLevel": TemperatureLevel,
      "HumidityLevel": HumidityLevel,
    });
    var response = await http.post(Uri.parse(url), body: data, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer ${token}',
    });
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == 200) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Success()));
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          headerAnimationLoop: false,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Invaild QR code',
          desc: 'Please try again!',
          buttonsTextStyle: TextStyle(color: Colors.black),
          showCloseIcon: true,
          btnCancelOnPress: () {},
          btnOkOnPress: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DoScan()));
          },
        )..show();
      }
    }
  }
}
