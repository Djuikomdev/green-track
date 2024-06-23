import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main_screen.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.jpg"),
          ),
          ListView.builder(
            itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (_,index){
            return  DrawerListTile(
              title: data[index]["title"].toString(),
              svgSrc: data[index]["icon"].toString(),
              press: () async{
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  prefs.setInt("page", index);
                });
              },
            );
          }),
          DrawerListTile(
            title: "Deconnexion",
            svgSrc: "assets/icons/signup.svg",
            press: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Se déconnecter"),
                    content: Text("Voulez-vous vraiment vous déconnecter ?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Logique de déconnexion ici
                          Navigator.of(context).pop();
                        },
                        child: Text("Oui"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Non"),
                      ),
                    ],
                  );
                },
              );
            }
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,color: Colors.white,
        // colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
var data = [
  {
    "title":"Accueil",
    ""
        "icon":"assets/icons/menu_dashboard.svg"
  },
  {
    "title":"Profile",
    "icon": "assets/icons/menu_profile.svg",
  },
  {
    "title":"Utilisateurs",
    "icon":"assets/icons/menu_tran.svg",
  },
  {
    "title":"Clients",
    "icon":"assets/icons/menu_tran.svg",
  },
  {
    "title":"Bouteilles",
    "icon":"assets/icons/menu_task.svg",
  },
  {
    "title":"Ventes",
    "icon":"assets/icons/menu_doc.svg",
  },
  {
    "title":"Production",
    "icon":"assets/icons/menu_doc.svg",
  },
  {
    "title":"Retours",
    "icon":"assets/icons/menu_doc.svg",
  },
  {
    "title":"Racks",
    "icon":"assets/icons/menu_doc.svg",
  },


  {
    "title":"Parametre",
    "icon": "assets/icons/menu_setting.svg",
  },
];
