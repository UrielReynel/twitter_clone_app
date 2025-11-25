import 'package:flutter/material.dart';
import 'package:twitter_clone_app/Services/Auth/auth_service.dart';
import 'package:twitter_clone_app/components/my_button.dart';
import 'package:twitter_clone_app/components/my_loading_circle.dart';
import 'package:twitter_clone_app/components/my_text_field.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Auth Service instance
  final _auth = AuthService();

  //Text Editing Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  //logIn method
  void logIn() async {
    showLoadingCircle(context);
    //Show loading circle
    try{
      await _auth.login(emailController.text, pwController.text);
      //Pop loading circle
      if (mounted) hideLoadingCircle(context);
    }
    catch(e){
      
      //Pop loading circle
      if(mounted){
        hideLoadingCircle(context);

        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text(e.toString()),
        ));
      }
      
    }
  }
  //Build UI
  @override
  Widget build(BuildContext context) {
    //Scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      //body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
          
            //Logo
            Icon(Icons.lock_open_rounded,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
          
            //Welcome back message
            Text('Welcome Back, you\'ve been missed!', 
            style:TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
          
            //Email textfield
            MyTextField(controller: emailController,
              hintText: 'Enter email..',
              obscureText: false,
              ),
            //Password textfield
            MyTextField(controller: pwController,
              hintText: 'Enter password..',
              obscureText: true,
            ),
            const SizedBox(height: 10),

            //Forgot password text
            Align(
              alignment: Alignment.centerRight,
              child: Text('Forgot Password?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                ),
              ),
            ),  
            const SizedBox(height: 25),

            //sign in button
            MyButton(text: "LogIn",
              onTap: logIn,
              ),
              const SizedBox(height: 50),
              //Not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text( 'Not a member? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),),

                  const SizedBox(width: 5),

                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text('Register Now',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),),
                  )
                ],
              )
              
          ],
            ),
          ),
        ),
      ),
    );
  }
}