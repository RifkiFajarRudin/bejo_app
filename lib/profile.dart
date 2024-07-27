import 'package:bejo_app/database.dart';
import 'package:bejo_app/user.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final dbHelper = DatabaseHelper();
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    User loadedUser = await dbHelper.getUserById(0);
    setState(() {
      user = loadedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user!.email}'),
                        Text('Firstname: ${user!.firstname}'),
                        Text('Lastname: ${user!.lastname}'),
                        Text('Universitas: ${user!.universitas}'),
                        Text('Alamat: ${user!.alamat}')
                      ]))
            ]),
    );
  }
}
