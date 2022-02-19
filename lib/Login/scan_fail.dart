import 'package:flutter/material.dart';

import 'do_login.dart';

class ScanFail extends StatelessWidget {
  const ScanFail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.lock_outline_rounded,
                      size: 190, color: Color(0xffff7675)),
                ],
              ),
            ),
            Text(
              'Please scan login again!',
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
            Container(
              padding: new EdgeInsets.only(top: 100.0),
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoLogin()),
                      );
                    },
                    child: const Text(
                      'Scan Again',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.only(
                              left: 30, right: 30, top: 14, bottom: 14)),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff001CD1)),
                      shadowColor: MaterialStateProperty.all(Color(0xff001CD1)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
