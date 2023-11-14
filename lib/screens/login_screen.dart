import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/blocs/login/login_bloc.dart';

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
  late LoginBloc loginBloc;
  final TextEditingController ctrlEmail =
      TextEditingController(text: "segud@mail.com");
  final TextEditingController ctrlPassword =
      TextEditingController(text: "12345678");

  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    loginBloc.add(DoCheckLoggedIn());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is OnSuccessLogin) {
          widget.onTappedLogin(true);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                if (state is OnLoadingLogin)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                Padding(
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
                        onPressed: state is OnLoadingLogin
                            ? null
                            : () => loginBloc.add(
                                  DoLogin(
                                    email: ctrlEmail.text,
                                    password: ctrlPassword.text,
                                  ),
                                ),
                        child: const Text("Login"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
