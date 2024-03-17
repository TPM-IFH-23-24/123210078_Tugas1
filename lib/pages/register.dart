import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:bma_travel/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isError = false;

  Future<void> registerUser() async {
    const url = "http://localhost:3002/v1/users/register";
    String msg = "";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _usernameController.text,
          'password': _passwordController.text
        }),
      );
      msg = jsonDecode(response.body)["message"];

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), duration: Durations.long2));

      if (response.statusCode != 201) {
        setState(() {
          isError = true;
        });
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Can't connect to server."),
          duration: Durations.long2));

      setState(() {
        isError = true;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/landing_bg_2.jpg'),
                  fit: BoxFit.cover)),
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(scrollDirection: Axis.vertical, children: [
            const SizedBox(height: 20),
            _heading(),
            _usernameField(),
            _passwordField(),
            _registerButton(context),
            const Divider(),
            _loginButton(context),
            const SizedBox(height: 20)
          ]),
        ),
      ),
    );
  }

  Widget _heading() {
    return Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1, bottom: 4),
        alignment: Alignment.centerLeft,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Register Page",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow),
            ),
            Text(
              "Please enter your credentials.",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }

  Widget _usernameField() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        enabled: true,
        controller: _usernameController,
        onChanged: (value) {
          setState(() {
            if (isError == true) isError = false;
          });
        },
        style: TextStyle(color: (!isError) ? Colors.white : Colors.red[200]),
        cursorColor: Colors.white,
        decoration: InputDecoration(
            hintText: 'Enter your username',
            hintStyle:
                const TextStyle(color: Color.fromARGB(150, 255, 255, 255)),
            prefixIcon: Icon(
              Icons.person,
              color: (!isError) ? Colors.white : Colors.red[200],
            ),
            filled: true,
            fillColor: const Color.fromARGB(48, 255, 255, 255),
            contentPadding: const EdgeInsets.all(12),
            border: InputBorder.none),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        enabled: true,
        controller: _passwordController,
        onChanged: (value) {
          setState(() {
            if (isError == true) isError = false;
          });
        },
        obscureText: true,
        style: TextStyle(color: (!isError) ? Colors.white : Colors.red[200]),
        cursorColor: Colors.white,
        decoration: InputDecoration(
            hintText: 'Enter you password',
            hintStyle:
                const TextStyle(color: Color.fromARGB(150, 255, 255, 255)),
            prefixIcon: Icon(
              Icons.key,
              color: (!isError) ? Colors.white : Colors.red[200],
            ),
            filled: true,
            fillColor: const Color.fromARGB(48, 255, 255, 255),
            contentPadding: const EdgeInsets.all(12),
            border: InputBorder.none),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        onPressed: registerUser,
        child: const Text('Register'),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Already have an account?",
              style: TextStyle(color: Colors.white)),
          Container(
            margin: const EdgeInsets.only(top: 6),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                            color: Color.fromARGB(84, 0, 0, 0), width: 1.5))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Login'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
