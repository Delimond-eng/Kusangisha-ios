import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kusangisha/model/projet_model.dart';
import 'package:kusangisha/screen/auth/login_screen_page.dart';
import 'package:kusangisha/services/db_helper_service.dart';
import 'package:kusangisha/services/http_service.dart';
import 'package:kusangisha/main/menu_widget.dart';

import '../../globals.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isObscure = true;

  //textEdit Controller
  final _textfullName = TextEditingController();
  final _textEmail = TextEditingController();
  final _textPhone = TextEditingController();
  final _textPass = TextEditingController();

  final Future<ProjectsModel> data = HttpService.getData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: subWidget(),
    );
  }

  Widget subWidget() {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(color: Colors.black87),
              height: MediaQuery.of(context).size.height * 0.3
          ),
          //Above card
          Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              elevation: 0,
              margin: EdgeInsets.only(top: 130.0),

              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        child: Icon(Icons.account_box, color: Colors.black87, size: 100.0,),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      height: 50.0,
                      padding: EdgeInsets.only(
                          top: 4.0,
                          right: 16.0,
                          left: 16.0,
                          bottom: 5.0
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
                        controller: _textfullName,
                        decoration: InputDecoration(
                          hintText: 'Nom complet',
                          icon: Icon(Icons.drive_file_rename_outline,
                            color: Colors.black38,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    //TextField Here
                    SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      height: 50.0,
                      padding: EdgeInsets.only(
                          top: 4.0,
                          right: 16.0,
                          left: 16.0,
                          bottom: 5.0
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
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: 'n° de téléphone(10 chiffre)',
                          icon: Icon(Icons.phone_iphone,
                            color: Colors.black38,
                          ),
                          counterText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),

                    Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      height: 50.0,
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
                        controller: _textEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Adresse email(optionnel)',
                          icon: Icon(Icons.email_outlined,
                            color: Colors.black38,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 15.0),

                    Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      height: 50.0,
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
                          suffixIcon: IconButton(
                            icon: Icon(
                                _isObscure ? Icons.visibility : Icons.visibility_off),color: Colors.black87,
                            onPressed: (){
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
                        child: InkWell(
                          splashColor: Colors.lightGreenAccent,
                          borderRadius: BorderRadius.circular(20.0),
                          autofocus: true,
                          onTap: (){
                            try{
                              if(_textfullName.text ==''){
                                EasyLoading.showToast('votre nom est réquis !');
                              }
                              else if(_textPhone.text==''){EasyLoading.showToast('votre n° de téléphone est réquis !');}
                              else if(_textPass.text==''){EasyLoading.showToast('vous devez entrer le mot de passe de mot !');}
                              else{
                                EasyLoading.show(status: 'loading...');
                                HttpService.createAccount(
                                    _textfullName.text,
                                    _textEmail.text,
                                    _textPhone.text,
                                    _textPass.text).then((response)
                                {
                                  if(response['reponse']['status']=='success'){
                                    EasyLoading.dismiss();
                                    showSuccessDialog();
                                    App.init();
                                    Iterable i = jsonDecode(App.localStorage.getString('projects'));
                                    Iterable x = jsonDecode(App.localStorage.getString('userProjects'));
                                    DBHelper.saveData(
                                        'data_user',
                                        response['reponse']['data_user']['user_account_id'],
                                        response['reponse']['data_user']['fullname']
                                    );
                                    MaterialPageRoute(builder: (context)=>HomeTabbedAppBar(
                                      projets: List<Projets>.from(i.map((model)=> Projets.fromJson(model))),
                                      username: response['reponse']['data_user']['fullname'],
                                    ));
                                  }
                                  else
                                  {
                                    EasyLoading.dismiss();
                                    showErrorDialog();
                                  }
                                });
                              }

                            }
                            catch(e){
                              print('error from : $e');
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
                                'créer un compte'.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: "Netflix",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                    ),

                    SizedBox(height:20.0),

                    InkWell(
                      splashColor: Colors.blueAccent,
                      onTap: (){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context)=>LoginScreenPage()),
                                (Route<dynamic> route) =>false
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                            text: 'vous avez un compte ',
                            children: [
                              TextSpan(
                                text: ' Connectez vous !',
                                style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold
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

  Widget showSuccessDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: new Text("Succès!",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold
              ),
            ),
            content: new Text("votre enregistrement a reussi ! validez pour vous connectez "),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child:Text("OK".toUpperCase(),
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
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
            content: new Text("ce n° de téléphone est déja utilisé pour un autre compte!"),
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
