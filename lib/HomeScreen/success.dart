import 'package:do_login/Widget/footer.dart';
import 'package:do_login/Widget/header.dart';
import 'package:do_login/Widget/menu.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'do_scan.dart';
import 'list_page.dart';
class Success extends StatefulWidget {
  const Success({Key? key}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  int selectedPage = 0;
  final _pageOptions = [
    HomePage(),
    ListPage(),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: MenuBar(),
    appBar:   PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: HeaderApp(),
    ),
    body: Container(
      margin: const EdgeInsets.only(top: 130),
      alignment: Alignment.center,
      child: Column(
        children: [
          Image.asset("assets/images/icon_success.png", width: 210),
          Text("Temperature",
            style: TextStyle(fontSize: 20, color: Colors.black45),
          ),
          Text("Record Submited",
            style: TextStyle(fontSize: 20,color: Colors.black45, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 75),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              primary: Colors.white,
              minimumSize: Size(200, 50),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoScan()),
              );
            },
            child: Text('New Scan',
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
