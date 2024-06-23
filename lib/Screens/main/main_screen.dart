import 'package:greentrack/Screens/Login/login_screen.dart';
import 'package:greentrack/Screens/dashboard/racks/rack_screen.dart';
import 'package:greentrack/Screens/dashboard/retours/retour_screen.dart';
import 'package:greentrack/Screens/profil/profil_screen.dart';
import 'package:greentrack/controllers/MenuAppController.dart';
import 'package:greentrack/responsive.dart';
import 'package:greentrack/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart' as nb_util;
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/bottle_service.dart';
import '../dashboard/bottles/bottle_screen.dart';
import '../dashboard/clients/client_screen.dart';
import '../dashboard/components/header.dart';
import '../dashboard/production/production_screen.dart';
import '../dashboard/setting/setting_screen.dart';
import '../dashboard/users/user_screen.dart';
import '../dashboard/ventes/ventes_screen.dart';
import 'components/side_menu.dart';


class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var page = 0;
  var screens = [
    DashboardScreen(),
    profilScreen(),
    userScreen(),
    ClientScreen(),
    BottleScreen(),
    VentesScreen(),
    ProductionScreen(),
    RetourScreen(),
    RackScreen(),
    SettingScreen()];


  init() async {
    var data = await BouteilleService().getBottles();
    setState(() {
      initPage = true;
      bottleList = data;
      bottleList2 = data;
    });
  }
  bool initPage = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(bottleList!.isEmpty){
    //   init();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                child: Image.asset("assets/images/logo.jpg"),
              ),
              ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (_,index){
                    return  Container(
                      color: page == index ? Colors.deepOrange:null,
                      child: DrawerListTile(
                        title: data[index]["title"].toString(),
                        svgSrc: data[index]["icon"].toString(),
                        press: () {
                          setState(() {
                            page = index;
                          });
                        },
                      ),
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
                              onPressed: () async{
                                // Logique de déconnexion ici
                                await FirebaseServices().signOut();
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
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
              )
            ],
          ),
        ),
      ),
      body: initPage==false?
          Center(
            child: CircularProgressIndicator(),
          ):SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: Drawer(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DrawerHeader(
                          child: Image.asset("assets/images/logo.jpg"),
                        ),
                        ListView.builder(
                            itemCount: data.length,
                            shrinkWrap: true,
                            itemBuilder: (_,index){
                              return  Container(
                                color: page == index ? Colors.deepOrange:null,
                                child: DrawerListTile(
                                  title: data[index]["title"].toString(),
                                  svgSrc: data[index]["icon"].toString(),
                                  press: () {
                                    setState(() {
                                      page = index;
                                    });
                                  },
                                ),
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
                                        onPressed: () async{
                                          // Logique de déconnexion ici
                                          await FirebaseServices().signOut();
                                          Navigator.of(context).pop();
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child:  page == 0 ? screens[page]
                  : Container(
                child: Center(
                  child: Column(
                    children: [
                      Header(),
                      screens[page]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
