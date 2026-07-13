import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/database/firebase_auth.dart';
import 'package:todo_app/screen/auth/register_cubit/register_cubit.dart';
import 'package:todo_app/utils/string_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // void _login() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     await _authService.registerWithEmailAndPassword(
  //       _emailController.text.trim(),
  //       _passwordController.text.trim(),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
  //     );
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(StringUtils.register)),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocConsumer<RegisterCubit, RegisterState>(
                listener: (context, state) {
                  if(state is RegisterFailure){
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                           content: Text(state.errorMessage),
                           backgroundColor: Colors.red
                       ),
                    );
                  }
                  if (state is RegisterSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(StringUtils.registerSucess),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: StringUtils.email),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: StringUtils.password),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                            labelText: StringUtils.confirmPassword),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      state is RegisterLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: () {
                          context.read<RegisterCubit>().register(
                              _emailController.text,
                              _passwordController.text,
                              _confirmPasswordController.text
                          );
                        },
                        child: Text(StringUtils.register),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(StringUtils.popLogin),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}