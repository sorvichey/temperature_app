import 'package:flutter/material.dart';

class HeaderApp extends StatelessWidget {
  const HeaderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          width: 120,
        ),
        backgroundColor: Color(0xff001CD1),
        leading: Builder(
          builder: (context) => IconButton(
            alignment: Alignment.center,
            icon: new Icon(Icons.menu), // add custom icons also
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
    );
  }
}
