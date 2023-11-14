import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final Function(bool) onTappedRegister;
  final Function(bool) onTappedLogin;

  const LoginScreen({
    super.key,
    required this.onTappedRegister,
    required this.onTappedLogin,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController ctrlEmail = TextEditingController();
  final TextEditingController ctrlPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Welcome To\nStory App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              TextFormField(
                controller: ctrlEmail,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ctrlPassword,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => widget.onTappedRegister(true),
                child: RichText(
                  text: const TextSpan(
                      text: "Doesn't Have an Account? ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                            text: "Register Here!",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ))
                      ]),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => widget.onTappedLogin(true),
                child: const Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
