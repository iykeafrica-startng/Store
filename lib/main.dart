import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fetching Data Online',
      theme: new ThemeData(
        primarySwatch: Colors.teal[400],
      ),
      home: new MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async {
    var data = await http.get("https://jsonplaceholder.typicode.com/users");

    var jsonData = json.decode(data.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user =
          User(u["id"], u["name"], u["email"], u["phone"], u["website"]);

      users.add(user);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
            future: _getUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: Center(
                  child: Text("loading..."),
                ));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Image.asset(
                            "assets/avatar.png",
                          ),
                        ),
                        title: Text(snapshot.data[index].name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Text(snapshot.data[index].email, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        onTap: (){
                          Navigator.push(context, 
                            new MaterialPageRoute(builder: (context) => DetailsPage(snapshot.data[index]))
                          );
                        },
                      );
                    });
              }
            }),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {

 final User user;

 DetailsPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
    );
  }
}


class User {
  int id;
  String name;
  String email;
  String phone;
  String website;

  User(int id, String name, String email, String phone, String website) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.phone = phone;
    this.website = website;
  }
}
