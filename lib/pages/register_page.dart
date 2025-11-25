import 'package:flutter/material.dart';
import 'package:twitter_clone_app/components/my_button.dart';
import 'package:twitter_clone_app/components/my_loading_circle.dart';
import 'package:twitter_clone_app/components/my_text_field.dart';
import 'package:twitter_clone_app/Services/Auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Acces auth service
  final _auth = AuthService();
  //Text Editing Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  //Register button tap
  void register() async {
    //passwor match confirm -> create user
    if (pwController.text == confirmPwController.text) {
      showLoadingCircle(context);

      try{
        await _auth.registerEmailPassword(
          emailController.text,
          pwController.text,
        );

        if(mounted) hideLoadingCircle(context);
      }
      catch(e){
        if(mounted){
          hideLoadingCircle(context);

          if(mounted){
            showDialog(context: context, builder: (context)=> AlertDialog(
              title: Text(e.toString()),
            ));
          }
        }
      }
    }

    //password don´t match -> show error
    else{
      showDialog(context: context, builder: (context)=> const AlertDialog(
        title: Text("Passwords don´t Match"),
      ),
      );
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
          
            //Create an account message
            Text('Let\'s create an account for you!', 
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

              const SizedBox(height: 25),
          
            //Name textfield
            MyTextField(controller: nameController,
              hintText: 'Enter name..',
              obscureText: false,
              ),


            //Password textfield
            MyTextField(controller: pwController,
              hintText: 'Enter password..',
              obscureText: true,
            ),
            const SizedBox(height: 10),

            //Confirm password textfield
            MyTextField(controller: confirmPwController,
              hintText: 'Confirm password..',
              obscureText: true,
            ),
            const SizedBox(height: 10),

            //sign up button
            MyButton(text: "Register",
              onTap: register,
              ),
              const SizedBox(height: 50),

              //Already a member? sign in now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text( 'Already a member? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),),

                  const SizedBox(width: 5),

                  //User can tap to go to login page
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text('Log In Now',
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