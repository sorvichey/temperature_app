import 'package:do_login/Widget/footer.dart';
import 'package:do_login/Widget/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'do_scan.dart';
import 'list_page.dart';
import 'package:do_login/Widget/menu.dart';

class HomeScan extends StatefulWidget {
  const HomeScan({Key? key}) : super(key: key);

  @override
  _HomeScanState createState() => _HomeScanState();
}

class _HomeScanState extends State<HomeScan> {
  bool _isContainerVisible = true;
  int selectedPage = 0;
  final _pageOptions = [
    HomeScan(),
    ListPage(),
  ];

  String? profileName;
  String? token;
  String? refreshToken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileName = prefs.getString('username');
      token = prefs.getString('token');
      refreshToken = prefs.getString('refreshToken');
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
      body: Builder(
        builder: (BuildContext context) {
          return OfflineBuilder(
            connectivityBuilder: (BuildContext context,
                ConnectivityResult connectivity, Widget child) {
              final bool connected = connectivity != ConnectivityResult.none;

              return Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    height: 25.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                      child: connected
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Online",
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Offline",
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                SizedBox(
                                  width: 12.0,
                                  height: 10.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              );
            },
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 130),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Welcome to ${profileName}",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    Text(
                      "Temperature Redord",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    Image.asset("assets/images/qr.png", width: 210),
                    SizedBox(
                      height: 75,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xff001CD1),
                        primary: Colors.white,
                        minimumSize: Size(200, 50),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => DoScan()));
                      },
                      child: Text(
                        'Scan QR',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: FooterApp(),
    );
  }
}
