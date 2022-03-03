import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kusangisha/model/projet_model.dart';
import 'package:kusangisha/screen/auth/register_screen.dart';
import 'package:kusangisha/services/db_helper_service.dart';
import 'package:kusangisha/services/http_service.dart';
import 'package:kusangisha/main/menu_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../globals.dart';

class LoginScreenPage extends StatefulWidget {
  @override
  _LoginScreenPageState createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {

  bool _isObscure =true;

  final _textPhone = TextEditingController();
  final _textPass = TextEditingController();


  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    await App.init();
    HttpService.getData().then((data){
      App.localStorage.setString('projects', jsonEncode(data.projets));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: body(),
    );
  }

  @override
  Widget body() {
    return SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(color: Colors.black87),
                height: MediaQuery.of(context).size.height * 0.3
            ),
            //Above card
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                elevation: 0,
                margin: EdgeInsets.only( top: 120.0),

                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Container(
                          child: Icon(Icons.lock, color: Colors.black54, size: 120.0,),
                        ),
                      ),

                      SizedBox(height: 20.0),

                      //TextField Here
                      Container(
                        width: MediaQuery.of(context).size.width/1.2,
                        height: 50.0  ,
                        padding: EdgeInsets.only(
                            top: 4.0,
                            right: 16.0,
                            left: 16.0,
                            bottom: 4.0
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20)
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              )
                            ]
                        ),
                        child: TextField(
                          controller: _textPhone,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'n° de téléphone / email',
                              icon: Icon(Icons.email_outlined,
                                  color: Colors.black38
                              ),
                              border: InputBorder.none,
                              counterText: ''
                          ),
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width/1.2,
                        height: 50.0,
                        margin: EdgeInsets.only(top: 20.0),
                        padding: EdgeInsets.only(
                            top: 4.0,
                            right: 16.0,
                            left: 16.0,
                            bottom: 4.0
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20)
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              )
                            ]
                        ),
                        child: TextField(
                          controller: _textPass,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                              hintText: 'Mot de passe',
                              icon: Icon(Icons.lock_outline,
                                color: Colors.black38,
                              ),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _isObscure ? Icons.visibility : Icons.visibility_off),color: Colors.black87,
                                onPressed: (){
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              )
                          ),
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
                          child: InkWell(
                            splashColor: Colors.lightGreenAccent,
                            borderRadius: BorderRadius.circular(20.0),
                            autofocus: true,
                            onTap: () async{
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              if(_textPhone.text == '' || _textPass.text ==''){
                                showErrorDialog1();
                              }
                              else{
                                EasyLoading.show(status: 'loading...');
                                HttpService.Login(_textPhone.text.trim(), _textPass.text).then((res) async{
                                  if(res['reponse']['status']=='success'){
                                    start();
                                    App.init();
                                    HttpService.findData(userId: res['reponse']['data_user']['user_account_id']).then((data){
                                      App.localStorage.setString('userProjects', jsonEncode(data.projets));
                                    });
                                    Iterable i = jsonDecode(App.localStorage.getString('projects'));
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context)=>HomeTabbedAppBar(
                                          projets: List<Projets>.from(i.map((model)=> Projets.fromJson(model))),
                                          username: res['reponse']['data_user']['fullname'],
                                        )
                                    ),
                                            (Route<dynamic> route) =>false);
                                    DBHelper.saveData(
                                        'data_user',
                                        res['reponse']['data_user']['user_account_id'],
                                        res['reponse']['data_user']['fullname']
                                    );
                                    EasyLoading.dismiss();
                                  }
                                  else{
                                    EasyLoading.dismiss();
                                    showErrorDialog();
                                  }
                                });
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black12,
                                      Colors.black,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 1),
                                    )
                                  ]
                              ),
                              child: Center(
                                child: Text(
                                  'Connecter'.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: "Netflix",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    color: Colors.white,
                                  ),
                                )
                              ),
                            ),
                          )
                      ),

                      SizedBox(height:MediaQuery.of(context).size.height/6),
                      InkWell(
                        splashColor: Colors.blueAccent,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                        },
                        child: Text.rich(
                          TextSpan(
                              text: 'vous n\'avez pas un compte ',
                              children: [
                                TextSpan(
                                  text: ' Créez un compte',
                                  style: TextStyle(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.w900
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
            // Positioned to take only AppBar size
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(        // Add AppBar here only
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                brightness: Brightness.dark,
                iconTheme: IconThemeData(
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget showErrorDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: new Text("Avertissement!",
              style: TextStyle(
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold
              ),
            ),
            content: new Text("vos identifiants sont incorrects !"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child:Text("OK".toUpperCase(),
                  style: TextStyle(
                      color: Colors.pinkAccent,
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
  }
  Widget showErrorDialog1(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: new Text("Avertissement!",
              style: TextStyle(
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold
              ),
            ),
            content: new Text("vous devez entrez vos identifiant pour vous connectez!"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child:Text("OK".toUpperCase(),
                  style: TextStyle(
                      color: Colors.pinkAccent,
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
  }
}
