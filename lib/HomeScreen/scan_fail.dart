import 'package:do_login/Widget/footer.dart';
import 'package:do_login/Widget/header.dart';
import 'package:do_login/Widget/menu.dart';
import 'package:flutter/material.dart';
import 'do_scan.dart';

class Fail extends StatefulWidget {
  const Fail({Key? key}) : super(key: key);

  @override
  _FailState createState() => _FailState();
}

class _FailState extends State<Fail> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: MenuBar(),
        appBar:  PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: HeaderApp(),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 130),
          alignment: Alignment.center,
          child: Column(
            children: [
              Image.asset("assets/images/scan_fail.png", width: 190),
              SizedBox(height: 10),
              Text(
                "Fail Submit Record",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 75),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff001CD1),
                  primary: Colors.white,
                  minimumSize: Size(200, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoScan()),
                  );
                },
                child: Text(
                  'Scan Again',
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
