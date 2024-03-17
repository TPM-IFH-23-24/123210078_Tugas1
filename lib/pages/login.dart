import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:bma_travel/pages/home.dart';
import 'package:bma_travel/pages/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authStorage = GetStorage('auth');
  String username = "";
  String password = "";
  bool isError = false;

  Future<void> loginUser() async {
    const url = "http://localhost:3002/v1/users/login";
    String msg = "";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}),
      );
      msg = jsonDecode(response.body)["message"];

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), duration: Durations.long2));

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            // Ganti val di local storage
            authStorage.write('username', username);
            authStorage.write('isLogged', true);

            return HomePage(username: username);
          }),
        );
      } else {
        setState(() {
          isError = true;
        });
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
            _loginButton(context),
            const Divider(),
            _registerButton(context),
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
              "Welcome Back 👋🏻",
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
        onChanged: (value) {
          username = value;
          setState(() {
            if (isError) isError = false;
          });
        },
        style: TextStyle(color: (!isError) ? Colors.white : Colors.red[200]),
        cursorColor: Colors.white,
        decoration: InputDecoration(
            hintText: 'Username',
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
        onChanged: (value) {
          password = value;
          setState(() {
            if (isError) isError = false;
          });
        },
        style: TextStyle(color: (!isError) ? Colors.white : Colors.red[200]),
        cursorColor: Colors.white,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Password',
            hintStyle:
                const TextStyle(color: Color.fromARGB(150, 255, 255, 255)),
            prefixIcon: Icon(
              Icons.key,
              color: (!isError) ? Colors.white : Colors.red.shade200,
            ),
            filled: true,
            fillColor: const Color.fromARGB(48, 255, 255, 255),
            contentPadding: const EdgeInsets.all(12),
            border: InputBorder.none),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        onPressed: loginUser,
        child: const Text('Login'),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Don't have an account?",
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
                        borderRadius: BorderRadius.circular(4))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text('Register'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
