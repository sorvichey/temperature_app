import 'dart:convert';
import 'dart:io';
import 'package:do_login/HomeScreen/home_page.dart';
import 'package:do_login/Login/scan_fail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class DoLogin extends StatefulWidget {
  const DoLogin({Key? key}) : super(key: key);

  @override
  _DoLoginState createState() => _DoLoginState();
}

class _DoLoginState extends State<DoLogin> {
  String url = "https://foauthtest.dynamic.com.kh/api/warehousetemperature/authuser";
  String _scanBarcode = '';
   String? token ;
   String? refreshToken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  void load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    refreshToken = prefs.getString('refreshToken');
    if(prefs.get("refreshToken") != null && prefs.get("token") != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScan()),
      );
    } else {
      scanBarcodeNormal();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }

  Future<void> scanBarcodeNormal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
        _scanBarcode = barcodeScanRes;
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "key":"${_scanBarcode}"
        }),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
      if(response.statusCode==200) {
        if(json.decode(response.body)['status']==200) {
          final String profileName = json.decode(response.body)['data']['profileName'];
          final String token = json.decode(response.body)['data']['token'];
          final String refreshToken = json.decode(response.body)['data']['refreshToken'];
          prefs.setString('username', profileName);
          prefs.setString('token', token);
          prefs.setString('refreshToken', refreshToken);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScan()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanFail()),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScanFail()),
        );
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
}



