import 'package:firebase_auth/firebase_auth.dart'as Auth;
import 'package:flutter/material.dart';
import 'package:greentrack/services/user_service.dart';

import '../../components/button.dart';
import '../../models/user_model.dart';


class profilScreen extends StatefulWidget {
  const profilScreen({super.key});

  @override
  State<profilScreen> createState() => _profilScreenState();
}

class _profilScreenState extends State<profilScreen> {

  User? _user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init()async{
    final user = Auth.FirebaseAuth.instance.currentUser;
    var user_data = await UserService().getUserById(user!.uid);
    setState(() {
      _user = user_data;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        child: _user==null ?
            Center(child: CircularProgressIndicator(),)
            :Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                _user!.username,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                _user!.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(" role : "+_user!.role),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.cake, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(" Identifiant : "+_user!.id),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(" Téléphone : "+_user!.phone),
                ],
              ),

              Divider(),
              SizedBox(height: 20),
              CustomButon(onPress: () {  }, title: 'Modifier le profil', color: Colors.deepOrange,),

            ],
          ),
        ),
      ),
    );
    ;
  }
}
