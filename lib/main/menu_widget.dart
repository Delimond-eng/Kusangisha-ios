import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kusangisha/constants.dart';
import 'package:kusangisha/globals.dart';
import 'package:kusangisha/model/projet_model.dart';
import 'package:kusangisha/pages/home_page.dart';
import 'package:kusangisha/pages/user_project_page.dart';
import 'package:kusangisha/pages/user_subscription_page.dart';
import 'package:kusangisha/pages/create_project_page.dart';
import 'package:kusangisha/screen/auth/login_screen_page.dart';
import 'package:kusangisha/screen/auth/profil_screen.dart';
import 'package:kusangisha/services/db_helper_service.dart';
import 'package:kusangisha/services/http_service.dart';
import 'package:kusangisha/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTabbedAppBar extends StatefulWidget {
  final List<Projets> projets;
  final String username;

  HomeTabbedAppBar({
    Key key, this.projets,
    this.username
  }) : super(key: key);
  @override
  _HomeTabbedAppBarState createState() => _HomeTabbedAppBarState();
}

class _HomeTabbedAppBarState extends State<HomeTabbedAppBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    DBHelper.findWhere('data_user').then((usr) {
      usr.forEach((r)=>loadData(usrId: r['VALUE']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('KUSANGISHA',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                  shadows: [
                                    Shadow(
                                        blurRadius: 2.0,
                                        color: Colors.black45,
                                        offset: Offset(3.0,3.0)
                                    )
                                  ]
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.lightBlue,
                            radius: 35,
                            child: Center(
                              child: Text(widget.username.toUpperCase().substring(0,1),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40.0,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 1.0,
                                      offset: Offset(0,3)
                                    )
                                  ]
                                ),
                              ),
                            )
                          ),
                          SizedBox(width: 5.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                  color: Colors.white
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Compte membre',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: ktColor,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.black87,),
                  title: Text('Profil',
                    style: TextStyle(
                      color: Colors.black87
                    ),
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context)=>
                            Profil()
                        ),
                            (Route<dynamic> route) =>true
                    );
                  },
                ),
                Divider(height: 0, color: Colors.black45),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.black87,),
                  title: Text('Deconnexion',
                    style: TextStyle(
                      color: Colors.black87
                    ),
                  ),
                  onTap: () {
                    DBHelper.findWhere('data_user').then((value) {
                      value.forEach((row){
                        print('value : ${row['ID']}');
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return CupertinoAlertDialog(
                                title: new Text("Avertissement !",
                                  style: TextStyle(
                                      color: Colors.red,
                                  ),
                                ),
                                content: new Text("Vous serez deconnectés de votre compte si vous appuyez sur OUI !",
                                  style: TextStyle(
                                      color: Colors.black
                                  ),
                                ),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    child:Text("Oui".toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    onPressed: (){
                                      DBHelper.deleteData(row['ID']);
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context)=>
                                              LoginScreenPage()
                                          ),
                                              (Route<dynamic> route) =>false
                                      );
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    child:Text("Non".toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            }
                        );
                      });

                    });
                  },
                ),
                Divider(height: 0, color: Colors.black45),
                ListTile(
                  leading: Icon(Icons.close_sharp, color: Colors.red),
                  title: Text('Quitter',
                    style: TextStyle(
                      color: Colors.red
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return CupertinoAlertDialog(
                            title: new Text("Avertissement !",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pinkAccent,
                                fontSize: 20.0
                              ),
                            ),
                            content: new Text("Etes-vous sûr de vouloir quitter l'application ?",
                              style: TextStyle(
                                  color: Colors.black
                              ),
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                child:Text("Oui".toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                onPressed: (){
                                  exit(0);
                                },
                              ),
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                child:Text("Non".toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        }
                    );
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.black87,
            title: const Text(
              'KUSANGISHA',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.help_center_sharp),
                color: Colors.white,
                onPressed: () {
                  StorageService.readSession('data_user').then((value) => print(value));
                  StorageService.exitSession('data_user');
                },
              ),
            ],
            centerTitle: true,
            brightness: Brightness.dark,
            bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.greenAccent,
                tabs: [
                  Tab(icon: Icon(Icons.home), text: "Accueil"),
                  Tab(
                    icon: Icon(Icons.add_to_photos_rounded),
                    text: "Créer projet",
                  ),
                  Tab(icon: Icon(Icons.account_balance), text: "Mes projets"),
                  Tab(
                      icon: Icon(Icons.account_balance_wallet_rounded),
                      text: "Souscription"),
                  Tab(icon: Icon(Icons.whatshot), text: "En vote"),
                ]),
          ),
          body: TabBarView(
            children: <Widget>[
              HomePage(projets: widget.projets),
              ProjectCreate(),
              OwnerProject(),
              OwnSubscription(),
              Center(child: FlatButton(
                child: Text('save data'),
                onPressed: (){

                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
