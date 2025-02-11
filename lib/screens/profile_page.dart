import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();

  bool _isUpdating = false;
  String? _errorMessage;

  @override
  void dispose() {
    passwordController.dispose();
    currentPasswordController.dispose();
    super.dispose();
  }


  Future<void> _reauthenticateUser(String currentPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isUpdating = true;
        _errorMessage = null;
      });
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          if (passwordController.text.isNotEmpty) {
            if (currentPasswordController.text.isEmpty) {
              throw FirebaseAuthException(
                code: 'requires-recent-login',
                message: 'Please provide your current password to update your password.',
              );
            }
            await _reauthenticateUser(currentPasswordController.text);
            await user.updatePassword(passwordController.text);
          }
          await user.reload();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
      } finally {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                user?.photoURL != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user!.photoURL!),
                      )
                    : const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),
                const SizedBox(height: 20),
                Text(
                  user?.displayName ?? 'No Display Name',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Current Email: ${user?.email ?? 'N/A'}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: currentPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (passwordController.text.isNotEmpty &&
                        (value == null || value.isEmpty)) {
                      return 'Current password is required to update password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
                _isUpdating
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _updateProfile,
                        child: const Text('Update Profile'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
