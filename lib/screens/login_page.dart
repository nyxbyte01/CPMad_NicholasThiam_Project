import 'package:flutter/material.dart';
import '/services/firebaseauth_service.dart';
import '/screens/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool signUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        automaticallyImplyLeading: false,
        title: const Text('Health tracker & advisor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (signUp) {
                  var newUser = await FirebaseAuthService().signUp(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  if (newUser != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign-up failed')),
                    );
                  }
                } else {
                  var regUser = await FirebaseAuthService().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  if (regUser != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign-in failed')),
                    );
                  }
                }
              },
              child: signUp ? const Text('Sign Up') : const Text('Sign In'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  signUp = !signUp;
                });
              },
              child: signUp
                  ? const Text('Have an account? Sign In')
                  : const Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
