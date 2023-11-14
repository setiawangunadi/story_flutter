import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/blocs/register/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterBloc registerBloc;
  final TextEditingController ctrlName = TextEditingController();
  final TextEditingController ctrlEmail = TextEditingController();
  final TextEditingController ctrlPassword = TextEditingController();

  @override
  void initState() {
    registerBloc = BlocProvider.of<RegisterBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is OnSuccessRegister) {
          ctrlName.clear();
          ctrlEmail.clear();
          ctrlPassword.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.data.message ?? ""),
                duration: const Duration(seconds: 4)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Register Account"),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              if (state is OnLoadingRegister)
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
                    TextFormField(
                      controller: ctrlName,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: ctrlEmail,
                      keyboardType: TextInputType.emailAddress,
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
                      keyboardType: TextInputType.text,
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
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: state is OnLoadingRegister
                          ? null
                          : () => registerBloc.add(
                                DoRegister(
                                  name: ctrlName.text,
                                  email: ctrlEmail.text,
                                  password: ctrlPassword.text,
                                ),
                              ),
                      child: const Text("Register"),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
