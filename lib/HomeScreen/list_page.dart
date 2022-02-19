import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:do_login/Widget/footer.dart';
import 'package:do_login/Widget/header.dart';
import 'package:do_login/Widget/menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

class Data {
  final String locationDisplay;
  final String recordedDatetime;
  final int temperatureLevel;
  final String temperatureMeasurement;
  final int humidityLevel;
  final String humidityMeasurement;
  final String recordedBy;
  Data(
      this.locationDisplay,
      this.recordedBy,
      this.recordedDatetime,
      this.temperatureLevel,
      this.temperatureMeasurement,
      this.humidityLevel,
      this.humidityMeasurement);
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      json['locationDisplay'],
      json['recordedDatetime'],
      json['temperatureLevel'],
      json['temperatureMeasurement'],
      json['humidityLevel'],
      json['humidityMeasurement'],
      json['recordedBy'],
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String url_ref =
      "https://foauthtest.dynamic.com.kh/api/warehousetemperature/refreshToken";
  String? token;
  String? refreshToken;
  String? profileName;

  @override
  void initState() {
    super.initState();
  }

  checkRefreshToken() async {
    final refresh_response = await http.post(
      Uri.parse(url_ref),
      body:
          jsonEncode({"token": "${token}", "refreshToken": "${refreshToken}"}),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    if (refresh_response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String new_token =
          json.decode(refresh_response.body)['data']['token'];
      final String new_refreshToken =
          json.decode(refresh_response.body)['data']['refreshToken'];
      prefs.setString('token', new_token);
      prefs.setString('refreshToken', new_refreshToken);
    }
  }

  Future fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    refreshToken = prefs.getString('refreshToken');
    final response = await http.get(
        Uri.parse(
            'https://foauthtest.dynamic.com.kh/api/warehousetemperature/getlistrecoredtemperature?TypeRecord=today'),
        headers: {
          'Authorization': 'Bearer ${token}',
        });
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      checkRefreshToken();
    }
  }

  Future fetchDataYesterday() async {
    final response = await http.get(
        Uri.parse(
            'https://foauthtest.dynamic.com.kh/api/warehousetemperature/getlistrecoredtemperature?TypeRecord=yesterday'),
        headers: {
          'Authorization': 'Bearer ${token}',
        });
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      checkRefreshToken();
    }
  }

  Future fetchDataWeek() async {
    final response = await http.get(
        Uri.parse(
            'https://foauthtest.dynamic.com.kh/api/warehousetemperature/getlistrecoredtemperature?TypeRecord=30days'),
        headers: {
          'Authorization': 'Bearer ${token}',
        });
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      checkRefreshToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderApp(),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: <Widget>[
              SizedBox(height: 6),
              ButtonsTabBar(
                height: 37,
                backgroundColor: Color(0xff001CD1),
                unselectedBackgroundColor: Colors.grey[300],
                unselectedLabelStyle: TextStyle(color: Colors.black54),
                labelStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    icon: Icon(Icons.calendar_today, size: 16.0),
                    text: "Today",
                  ),
                  Tab(
                    icon: Icon(Icons.calendar_today_outlined, size: 16.0),
                    text: "Yesterday",
                  ),
                  Tab(
                    icon: Icon(Icons.calendar_view_month, size: 19.0),
                    text: "Week",
                  ),
                ],
              ),
              SizedBox(height: 5),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    Center(
                      child: FutureBuilder(
                        future: fetchData(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  final locationDisplay = snapshot.data[index]
                                          ['locationDisplay']
                                      .toString();
                                  final recordedDatetime = snapshot.data[index]
                                          ['recordedDatetime']
                                      .toString();
                                  final temperatureLevel = snapshot.data[index]
                                          ['temperatureLevel']
                                      .toString();
                                  final temperatureMeasurement = snapshot
                                      .data[index]['temperatureMeasurement']
                                      .toString();
                                  final humidityLevel = snapshot.data[index]
                                          ['humidityLevel']
                                      .toString();
                                  final humidityMeasurement = snapshot
                                      .data[index]['humidityMeasurement']
                                      .toString();
                                  final recordedBy = snapshot.data[index]
                                          ['recordedBy']
                                      .toString();
                                  return Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                            leading: Icon(
                                              Icons.qr_code_2_outlined,
                                              size: 43,
                                            ),
                                            title: Text(locationDisplay),
                                            subtitle: Text(recordedDatetime),
                                            trailing: Column(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5)),
                                                Text(
                                                    "T: $temperatureLevel $temperatureMeasurement",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    "H: $humidityLevel $humidityMeasurement",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            )),
                                      ],
                                    ),
                                  );
                                });
                          }
                          return Container();
                        },
                      ),
                    ),
                    Center(
                      child: FutureBuilder(
                        future: fetchDataYesterday(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  final locationDisplay = snapshot.data[index]
                                          ['locationDisplay']
                                      .toString();
                                  final recordedDatetime = snapshot.data[index]
                                          ['recordedDatetime']
                                      .toString();
                                  final temperatureLevel = snapshot.data[index]
                                          ['temperatureLevel']
                                      .toString();
                                  final temperatureMeasurement = snapshot
                                      .data[index]['temperatureMeasurement']
                                      .toString();
                                  final humidityLevel = snapshot.data[index]
                                          ['humidityLevel']
                                      .toString();
                                  final humidityMeasurement = snapshot
                                      .data[index]['humidityMeasurement']
                                      .toString();
                                  final recordedBy = snapshot.data[index]
                                          ['recordedBy']
                                      .toString();
                                  return Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                            leading: Icon(
                                              Icons.qr_code_2_outlined,
                                              size: 43,
                                            ),
                                            title: Text(locationDisplay),
                                            subtitle: Text(recordedDatetime),
                                            trailing: Column(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5)),
                                                Text(
                                                    "T: $temperatureLevel $temperatureMeasurement"),
                                                Text(
                                                    "H: $humidityLevel $humidityMeasurement"),
                                              ],
                                            )),
                                      ],
                                    ),
                                  );
                                });
                          }

                          return Container();
                        },
                      ),
                    ),
                    Center(
                      child: FutureBuilder(
                        future: fetchDataWeek(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  final locationDisplay = snapshot.data[index]
                                          ['locationDisplay']
                                      .toString();
                                  final recordedDatetime = snapshot.data[index]
                                          ['recordedDatetime']
                                      .toString();
                                  final temperatureLevel = snapshot.data[index]
                                          ['temperatureLevel']
                                      .toString();
                                  final temperatureMeasurement = snapshot
                                      .data[index]['temperatureMeasurement']
                                      .toString();
                                  final humidityLevel = snapshot.data[index]
                                          ['humidityLevel']
                                      .toString();
                                  final humidityMeasurement = snapshot
                                      .data[index]['humidityMeasurement']
                                      .toString();
                                  final recordedBy = snapshot.data[index]
                                          ['recordedBy']
                                      .toString();
                                  return Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                            leading: Icon(
                                              Icons.qr_code_2_outlined,
                                              size: 43,
                                            ),
                                            title: Text(locationDisplay),
                                            subtitle: Text(recordedDatetime),
                                            trailing: Column(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5)),
                                                Text(
                                                    "T: $temperatureLevel $temperatureMeasurement"),
                                                Text(
                                                    "H: $humidityLevel $humidityMeasurement"),
                                              ],
                                            )),
                                      ],
                                    ),
                                  );
                                });
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterApp(),
    );
  }
}
