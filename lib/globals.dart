import 'dart:convert';

import 'package:kusangisha/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class App {
  static SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
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