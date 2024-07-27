import 'package:bejo_app/database.dart';
import 'package:bejo_app/user.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final dbHelper = DatabaseHelper();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController universitasController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
      emailController.text = user!.email;
      firstnameController.text = user!.firstname ?? '';
      lastnameController.text = user!.lastname ?? '';
      universitasController.text = user!.universitas ?? '';
      alamatController.text = user!.alamat ?? '';
      passwordController.text = user!.password ?? '';
    });
  }

  Future<void> _updateUser(int id) async {
    User updatedUser = User(
        id: id,
        email: emailController.text,
        firstname: firstnameController.text,
        lastname: lastnameController.text,
        universitas: universitasController.text,
        alamat: alamatController.text,
        password: passwordController.text);

    await dbHelper.updateUser(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: firstnameController,
                    decoration: const InputDecoration(labelText: 'Firstname'),
                  ),
                  TextField(
                    controller: lastnameController,
                    decoration: const InputDecoration(labelText: 'Lastname'),
                  ),
                  TextField(
                    controller: universitasController,
                    decoration: const InputDecoration(labelText: 'Universitas'),
                  ),
                  TextField(
                    controller: alamatController,
                    decoration: const InputDecoration(labelText: 'Alamat'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _updateUser(user!.id!);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
