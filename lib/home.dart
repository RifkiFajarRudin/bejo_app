import 'package:bejo_app/database.dart';
import 'package:bejo_app/main.dart';
import 'package:bejo_app/master.dart';
import 'package:bejo_app/profile.dart';
import 'package:bejo_app/user.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home(
      {super.key,
      required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  void _profile(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ProfilePage(title: 'Profile')));
  }

  void _master(BuildContext context, User user) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EditProfilePage()));
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
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Text('Selamat datang ${user!.email}, id user: ${user!.id}')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          fixedSize:
                              WidgetStatePropertyAll(Size.fromHeight(72))),
                      onPressed: () {
                        _profile(context);
                      },
                      child: const Text('Profile')),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                      style: const ButtonStyle(
                          fixedSize:
                              WidgetStatePropertyAll(Size.fromHeight(72))),
                      onPressed: () {
                        _master(context, user!);
                      },
                      child: const Text('Edit Profile'))
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 48.0, right: 48.0, bottom: 48.0),
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(Colors.red)),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage(title: 'Bejo App')),
                      (route) => false, // Remove all routes from the stack
                    );
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
