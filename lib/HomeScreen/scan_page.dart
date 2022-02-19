import 'package:do_login/Widget/footer.dart';
import 'package:do_login/Widget/header.dart';
import 'package:do_login/Widget/menu.dart';
import 'package:flutter/material.dart';

import 'do_scan.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String _scanBarcode = 'Unknown';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderApp(),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 130),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              "Company:",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Text(
              "Temperature Redord: ",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => DoScan()));
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
      bottomNavigationBar: FooterApp(),
    );
  }
}
