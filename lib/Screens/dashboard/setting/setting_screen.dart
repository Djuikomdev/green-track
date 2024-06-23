import 'package:flutter/material.dart';
import 'package:greentrack/components/button.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool switched = false;
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paramètres',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('Langue'),
                trailing: DropdownButton<String>(
                  value: 'Français',
                  items: ['Français', 'Anglais', 'Espagnol']
                      .map((lang) => DropdownMenuItem<String>(
                    value: lang,
                    child: Text(lang),
                  ))
                      .toList(),
                  onChanged: (value) {
                    // Logique de changement de langue
                  },
                ),
              ),
              Divider(color: Colors.white,),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                trailing: Switch(
                  value: switched,
                  activeColor: Colors.red,
                  onChanged: (value) {
                    // Logique d'activation/désactivation des notifications
                    setState(() {
                      switched = !switched;
                    });
                  },
                ),
              ),
              Divider(color: Colors.white,),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Sécurité'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Naviguer vers la page de sécurité
                },
              ),
              Divider(color: Colors.white,),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('À propos'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Naviguer vers la page "À propos"
                },
              ),
              Divider(color: Colors.white,),
              SizedBox(height: 20),
              Row(
                children: [
                  Center(
                    child: CustomButon(onPress: () {  }, title: 'Autre', color: Colors.green,),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
