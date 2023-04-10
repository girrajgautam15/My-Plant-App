// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:micro/home2.dart';
import 'package:micro/main.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String? name = user.displayName ?? "wait";
    return Container(
        width: 255,
        color: Colors.white,
        child: Drawer(
            child: ListView(
          children: [
            SizedBox(
              height: 150,
              child: DrawerHeader(
                child: Row(
                  children: [
                    Image.asset(
                      "images/user_icon.png",
                      width: 65,
                      height: 65,
                    ),
                    SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              fontFamily: "brand-semibold", fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 1,
            ),
            SizedBox(height: 5),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Live Value", style: TextStyle(fontSize: 15)),
              onTap: (() => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => home()))),
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.storage),
              title: Text("Database", style: TextStyle(fontSize: 15)),
              onTap: (() => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => home2()))),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                "Made by AR_G",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        )));
  }
}
