import 'package:bussafe/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:bussafe/driverloginpage.dart';
import 'package:bussafe/map_page.dart';
import 'package:bussafe/Notifications.dart';
import 'package:bussafe/ProfilePage.dart';

class firstpage extends StatefulWidget {
  firstpage({super.key});

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  int _selectedindex = 0;

  void _navigationBar(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus_Safe"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notifications()));
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, minimumSize: Size(350, 70)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("login as a student/parent"),
            ),
            SizedBox(height: 50),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, minimumSize: Size(350, 70)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Driverloginpage()),
                  );
                },
                child: Text("login as a administration or staff")),
            SizedBox(height: 50),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, minimumSize: Size(350, 70)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage()),
                  );
                },
                child:
                    Text("click here for general navigational map or routes")),
          ],
        ),
      ),
    );
  }
}
