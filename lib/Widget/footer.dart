import 'package:do_login/HomeScreen/home_page.dart';
import 'package:do_login/HomeScreen/list_page.dart';
import 'package:flutter/material.dart';

class FooterApp extends StatefulWidget {
  const FooterApp({Key? key}) : super(key: key);

  @override
  _FooterAppState createState() => _FooterAppState();
}

class _FooterAppState extends State<FooterApp> {
  late int _selectedPage ;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedPage = 0;
  }
  void changeTab(int index) {
    setState(() {
      _selectedPage = 1;
    });
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_2_outlined),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'List',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xff001CD1),
      selectedItemColor: Colors.white,
      currentIndex: _selectedPage,
      unselectedItemColor: Colors.white,
      onTap: (index) {
        changeTab(index);
        _selectedPage = index;
        selectedPage: _selectedPage;

        if (_selectedPage == 1) {

          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ListPage()));
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScan()));
        }
      },

    );
  }
}

