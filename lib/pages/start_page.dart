import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  // このクライアントオブジェクトを使用することで、アプリからSupabaseの各種サービス（認証、ストレージ、リアルタイムなど）にアクセスできる。
  final SupabaseClient supabase = Supabase.instance.client;
  bool _signInLoading = false;
  bool _signUpLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Sign up Functionality
  // syntax : supabase.auth.signup(email: "", password:"");

  @override
  void dispose() {
    supabase.dispose();
    // メモリリークを無くす
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    "https://seeklogo.com/images/S/supabase-logo-DCC676FFE2-seeklogo.com.png",
                    height: 150,
                  ),
                  const SizedBox(height: 25),
                  // Email Field
                  TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return "Field is required";
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: Text("Email"),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  // Password Field
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                      label: Text("Password"),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Sign In"),
                  ),
                  const Divider(),
                  _signInLoading
                      ? const Center(child: CircularProgressIndicator())
                      : OutlinedButton(
                          onPressed: () async {
                            final isValid = _formKey?.currentState?.validate();
                            if (isValid != true) {
                              return;
                            }
                            setState(() {
                              _signUpLoading = true;
                            });
                            try {
                              await supabase.auth.signUp(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Success ! Confirmation Email sent"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              setState(
                                () {
                                  _signUpLoading = false;
                                },
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Sign up failed"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              setState(
                                () {
                                  _signUpLoading = false;
                                },
                              );
                            }
                          },
                          child: Text("Sign up"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
