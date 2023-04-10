// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:micro/dashboard.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'navigationDrawer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late DatabaseReference _dbref;
  final _store = FirebaseFirestore.instance;
  int temp = 0;
  int humid = 0;
  int moist = 0;
  var LED;
  var PUMP;
  var FAN;
  var triggerLed;
  var triggerFan;
  var triggerPump;

  late Timer timer;

  _database() {
    _store.collection('ESP').add({
      'temp': temp,
      'time': DateTime.now(),
      'humid': humid,
      'moisture': moist,
    });
  }

  _realdb_once() async {
    _dbref.child('ESP').onValue.listen((event) {
      print(event.snapshot.value.toString());
      if (event.snapshot.exists) {
        Map data = event.snapshot.value as Map;
        data.forEach((key, value) {
          setState(() {
            temp = data['temprature'];
            moist = data['moisture'];
            humid = data['humidity'];
            LED = data['LED'];
            PUMP = data['PUMP'];
            FAN = data['FAN'];
            triggerLed = data['triggerLed'];
            triggerFan = data['triggerFan'];
            triggerPump = data['triggerPump'];
          });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => _database());
    _dbref = FirebaseDatabase.instance.ref();
    _realdb_once();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SMART GREENHOUSE"),
        backgroundColor: Colors.green,
      ),
      drawer: NavigationDrawer(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 7,
                color: Color.fromARGB(255, 249, 238, 207),
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 5.0,
                        percent: (temp / 50.0).toDouble(),
                        center: Icon(
                          Icons.thermostat_rounded,
                          size: 50.0,
                          color: Color.fromARGB(255, 238, 160, 154),
                        ),
                        backgroundColor: Colors.grey,
                        progressColor:
                            (temp / 50) < 0.7 ? Colors.blue : Colors.red,
                      ),
                      SizedBox(width: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Temprature: $temp C',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              Text(
                                'LED :',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Switch(
                                value: LED,
                                activeColor: Colors.green,
                                inactiveTrackColor: Colors.red,
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                          Text(
                            "Trigger: $triggerLed C  ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Slider(
                            value: triggerLed.toDouble(),
                            label:
                                "Trigger Value: ${triggerLed.round().toString()}",
                            onChanged: ((value) {
                              setState(() {
                                triggerLed = value.round();
                                _dbref
                                    .child("ESP")
                                    .update({"triggerLed": triggerLed});
                              });
                            }),
                            max: 100,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 7,
                color: Color.fromARGB(255, 227, 249, 207),
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Humidity: $humid g/m^3',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              Text(
                                'FAN :',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Switch(
                                value: FAN,
                                activeColor: Colors.green,
                                inactiveTrackColor: Colors.red,
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                          Text(
                            "Trigger: $triggerFan g/m^3  ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Slider(
                            value: triggerFan.toDouble(),
                            label:
                                "Trigger Value: ${triggerFan.round().toString()}",
                            onChanged: ((value) {
                              setState(() {
                                triggerFan = value.round();
                                _dbref
                                    .child("ESP")
                                    .update({"triggerFan": triggerFan});
                              });
                            }),
                            max: 100,
                          )
                        ],
                      ),
                      SizedBox(width: 30),
                      CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 5.0,
                        percent: (0.5).toDouble(),
                        center: Icon(
                          Icons.water_drop,
                          size: 50.0,
                          color: Color.fromARGB(255, 86, 173, 245),
                        ),
                        backgroundColor: Colors.grey,
                        progressColor:
                            (humid / 50) < 0.7 ? Colors.blue : Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 7,
                color: Color.fromARGB(255, 223, 200, 244),
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 5.0,
                        percent: (moist / 50.0).toDouble(),
                        center: Icon(
                          Icons.eco,
                          size: 50.0,
                          color: Color.fromARGB(255, 143, 187, 117),
                        ),
                        backgroundColor: Colors.grey,
                        progressColor:
                            (moist / 50) < 0.7 ? Colors.blue : Colors.red,
                      ),
                      SizedBox(width: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Moisture: $moist %',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              Text(
                                'Pump :',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Switch(
                                value: PUMP,
                                activeColor: Colors.green,
                                inactiveTrackColor: Colors.red,
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                          Text(
                            "Trigger: $triggerPump %  ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Slider(
                            value: triggerPump.toDouble(),
                            label:
                                "Trigger Value: ${triggerPump.round().toString()}",
                            onChanged: ((value) {
                              setState(() {
                                triggerPump = value.round();
                                _dbref
                                    .child('ESP')
                                    .update({"triggerPump": triggerPump});
                              });
                            }),
                            max: 100,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
