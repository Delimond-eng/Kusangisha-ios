import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kusangisha/model/project_model.dart';
import 'package:kusangisha/model/projet_model.dart';
import 'package:kusangisha/screen/auth/login_screen_page.dart';
import 'package:kusangisha/services/db_helper_service.dart';
import 'package:kusangisha/services/http_service.dart';
import 'package:kusangisha/main/menu_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  StreamSubscription<DataConnectionStatus> listener;

  final Future<ProjectsModel> data = HttpService.getData();

  @override
  void initState(){
    super.initState();
    checkConnection(context);
  }

  void loadData({String usrId}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpService.getData().then((data){
      prefs.setString('projects', jsonEncode(data.projets));
    });

    HttpService.findData(userId: usrId).then((userData){
      prefs.setString('userProjects', jsonEncode(userData.projets));
    });
  }

  checkConnection(BuildContext context) async{

    listener = DataConnectionChecker().onStatusChange.listen((status) {
      if(status == DataConnectionStatus.disconnected){
        SweetAlert.show(context,
            title: "",
            subtitle: 'Please check your data connection',
            confirmButtonColor: Colors.deepOrange,
            confirmButtonText: 'cancel',
            onPress: (bool confirm){
              if(confirm){
                exit(0);
              }
              return false;
            },
            style: SweetAlertStyle.confirm);
      }
      else{
        DBHelper.findWhere('data_user').then((value){
          print(value);
          value.forEach((r)=>loadData(usrId: r['VALUE']));
          if(value.isEmpty){
            Timer(Duration(seconds: 10), ()=>Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context)=>LoginScreenPage()),
              (Route<dynamic> route) =>false));
          }
          else{
            value.forEach((row){
              print(row['VALUE']);
              Timer(Duration(seconds: 10), ()=>Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context)=>HomeTabbedAppBar(
                  )),
                      (Route<dynamic> route) =>false));
            });
          }
        });

      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  @override
  void dispose(){
    listener.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffffffff),
                  Color(0xffffffff)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              )
            ),
          ) ,

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(blurRadius: 15, color:Color(0xff063970).withOpacity(0.1), spreadRadius: 1)],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius:70.0,
                  child: Image.asset('assets/images/logo.png',
                    fit: BoxFit.fill,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
              ),
              SizedBox(height: 30.0),

              SpinKitThreeBounce(color: Colors.black)
            ],
          )
        ],
      ),
    );
  }
}
