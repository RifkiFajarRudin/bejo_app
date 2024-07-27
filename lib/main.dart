import 'package:bejo_app/database.dart';
import 'package:bejo_app/home.dart';
import 'package:bejo_app/user.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bejo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(title: 'Bejo App'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dbHelper = DatabaseHelper();
  User? user;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      User loadedUser = await dbHelper.getUserById(0);
      setState(() {
        user = loadedUser;
      });
    } catch (e) {
      // Handle the error (e.g., show an error message)
    }
  }

  void _reset() {
    setState(() {
      _emailController.text = '';
      _passwordController.text = '';
    });
  }

  void _login(BuildContext context) {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data not available.')),
      );
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;

    if (email != user!.email || password != user!.password) {
      _reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password.')),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            title: widget.title,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.jpeg',
                width: 100.0,
                height: 100.0,
              ),
              const SizedBox(height: 42),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Ensure user data is loaded before attempting login
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User data not loaded.')),
                    );
                  } else {
                    _login(context);
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
