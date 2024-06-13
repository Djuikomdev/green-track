import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greentrack/Screens/main/main_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/button.dart';
import '../../../constants.dart';
import '../../../services/auth_service.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Déclarez votre clé de formulaire en tant que variable globale
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoad = false;

  //script de validation d'adresse email ............
  bool isValidEmail(String email) {
    // Expression régulière pour vérifier la validité de l'adresse email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: 370,
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est obligatoire';
                }
                if (!isValidEmail(value)) {
                  return 'Adresse email non valide';
                }
                return null;
              },
              onSaved: (email) {},
              decoration: const InputDecoration(
                label: Text("Adresse email"),
                border: OutlineInputBorder(),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Container(
            width: 370,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  return null;
                },
                obscureText: true,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  label: Text("Mot de passe"),
                  border: OutlineInputBorder(),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          isLoad?Center(child: CircularProgressIndicator(),):CustomButon(
            onPress: ()async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoad = true;
                });

                var result = await FirebaseServices().signInWithEmailAndPassword(emailController.text, passwordController.text);
                if(result==0){
                  MainScreen().launch(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connexion reussie")));
                }else if(result==2){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("mot de passe incorrect")));
                }else if(result==1){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("utilisateur inexistant")));
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Une erreur est survenue.")));

                }
                setState(() {
                  isLoad = false;
                });
                // MainScreen().launch(context);

              }
            }, title: 'Connexion', color: kPrimaryColor,
          ),

          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
