import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screen/auth/login_cubit/login_cubit.dart';
import 'package:todo_app/screen/auth/register_screen.dart';
import 'package:todo_app/utils/string_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(StringUtils.logIn),),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if(state is LoginFailure){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage),
                        backgroundColor: Colors.red,
                      )
                    );
                  }
                  if( state is LoginSuccess){}
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: StringUtils
                            .email),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: StringUtils.password),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      state is LoginLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: (){
                          context.read<LoginCubit>().login(_emailController.text, _passwordController.text);
                        },
                        child: Text(StringUtils.logIn),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Text(StringUtils.signUp),
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