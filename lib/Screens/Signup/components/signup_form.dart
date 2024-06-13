import 'package:flutter/material.dart';
import 'package:greentrack/Screens/main/main_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/button.dart';
import '../../../constants.dart';
import '../../../services/auth_service.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isLoad = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernaeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
              controller: usernaeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est obligatoire';
                }
                return null;
              },
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                label: Text("Nom et prenom"),
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
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est obligatoire';
                }
                if (!isValidEmail(value)) {
                  return 'Adresse email non valide';
                }
                return null;
              },
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                label: Text("Adresse email"),
                border: OutlineInputBorder(),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
                ),
              ),
            ),
          ),
          Container(
            width: 370,
            child: TextFormField(
              controller: phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est obligatoire';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                label: Text("Telephone"),
                border: OutlineInputBorder(),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.phone),
                ),
              ),
            ),
          ),
          Container(
            width: 370,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  return null;
                },
                controller: passwordController,
                textInputAction: TextInputAction.done,
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
          const SizedBox(height: defaultPadding / 2),

          isLoad? Center(
            child: CircularProgressIndicator(),
          ):
          CustomButon(
            onPress: ()async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isLoad = true;
        });

        var result = await FirebaseServices().registerWithEmailAndPassword(
            emailController.text,
            passwordController.text,
            {
              "id": "",
              "username": usernaeController.text,
              "email": emailController.text,
              "phone": phoneController.text,
              "role": "user",
              "created_at": DateTime.now()
            });
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
            }}, title: 'S\'inscrire', color: kPrimaryColor,
          ),

          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
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