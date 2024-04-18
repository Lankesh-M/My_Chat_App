import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/widget/InputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onTap});
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  final void Function()? onTap;
  void _register() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Lets create an Account for you!",
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 25,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _confirmPassController,
                hintText: "Confirm Password",
                isPasswordField: true,
              ),
              SizedBox(height: 30),

              //Button
              GestureDetector(
                onTap: _register,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an Account, ",
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    // onTap: () {
                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => LoginPage(),
                    //     ),
                    //   );
                    // },
                    onTap: onTap,
                    child: Text(
                      "Login now",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
