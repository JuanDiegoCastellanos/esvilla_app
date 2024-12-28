import 'package:esvilla_app/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            controller.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      controller.login(
                        emailController.text,
                        passwordController.text,
                      );
                      if(controller.token != '') {
                        Navigator.pushNamed(context, '/home');
                      }
                    },
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}