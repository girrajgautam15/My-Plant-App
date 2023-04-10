// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:micro/navigationDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class home2 extends StatefulWidget {
  @override
  State<home2> createState() => _home2State();
}

class _home2State extends State<home2> {
  final _store = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> database;

  Future getdata() async {
    var data = _store.collection('ESP').orderBy('time');
  }

  @override
  void initState() {
    super.initState();
    database = _store.collection('ESP').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("Collected Database"),
        ),
        drawer: NavigationDrawer(),
        body: SafeArea(
          child: StreamBuilder(
            stream: database,
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
              final messages = snapshot.data!.docs;
              List<messageBubble> messageList = [];
              for (var i in messages) {
                final temp = i.get('temp');
                final messageTime = i.get('time');
                final humid = i.get('humid');
                final moist = i.get('moisture');
                final message = messageBubble(
                  temp: temp,
                  time: messageTime,
                  humid: humid,
                  moist: moist,
                );
                messageList.add(message);
                messageList.sort((a, b) => b.time.compareTo(a.time));
              }
              return Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  children: messageList,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class messageBubble extends StatelessWidget {
  const messageBubble({
    required this.temp,
    required this.time,
    required this.humid,
    required this.moist,
  });
  final Timestamp time;
  final temp;
  final humid;
  final moist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            color: Color(0xFFeff1fe),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: Container(
                      height: 75,
                      width: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                        color: Color(0xff1a73e9),
                      ),
                      child: Text(''),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '          ${time.toDate()}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2071ed),
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Temprature : $temp',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Humidity     : $humid',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Moisture     : $moist',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
