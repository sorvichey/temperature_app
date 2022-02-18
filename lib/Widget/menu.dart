import 'package:do_login/HomeScreen/home_page.dart';
import 'package:do_login/HomeScreen/list_page.dart';
import 'package:do_login/Login/do_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  late String profileName;
  late String token;
  late String refreshToken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileName = prefs.getString('username')!;
      token = prefs.getString('token')!;
      refreshToken = prefs.getString('refreshToken')!;
    });
  }

  bool _on_info = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: ListView(
              children: [
                Container(
                  child: Text(
                    "${profileName}",
                    style: TextStyle(color: Colors.white),
                  ),
                  margin: const EdgeInsets.all(50.0),
                  alignment: Alignment.center,
                ),
              ],
            ),
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScan()),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('List'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListPage()),
              ),
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DoLogin()));
            },
          ),
        ],
      ),
    );
  }
}
