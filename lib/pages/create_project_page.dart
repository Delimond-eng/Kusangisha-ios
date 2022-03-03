
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kusangisha/constants.dart';
import 'package:kusangisha/services/db_helper_service.dart';
import 'package:kusangisha/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectCreate extends StatefulWidget {
  @override
  _ProjectCreateState createState() => _ProjectCreateState();
}

class _ProjectCreateState extends State<ProjectCreate> {

  //var
  PickedFile _imageFile1;
  PickedFile _imageFile2;
  PickedFile _imageFile3;
  final ImagePicker _picker = ImagePicker();
  String userId='';

  final _textName = TextEditingController();
  final _textAmount = TextEditingController();
  final _textDescription = TextEditingController();


  void refreshData(String usrId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpService.findData(userId: usrId).then((userData){
      prefs.setString('userProjects', jsonEncode(userData.projets));
    });

    HttpService.getData().then((data){
      prefs.setString('projects', jsonEncode(data.projets));
    });
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          gradient:LinearGradient(
              colors: [
                Color.fromRGBO(253, 252, 252, 252),
                Color.fromARGB(253, 252, 252, 252),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:10.0,left: 10.0, right: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 15.0,),
                    TextField(
                      keyboardType: TextInputType.text,
                      controller: _textName,
                      decoration: InputDecoration(
                          hintText: 'Entrez le nom du projet',
                          labelText: 'Nom du projet',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ktColor,
                            fontSize: 15.0,
                          ),
                          border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(20),
                              ),
                              borderSide: BorderSide(color: ktColor)
                          ),
                          prefixIcon: Icon(Icons.drive_file_rename_outline)
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _textAmount,
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.monetization_on_rounded,
                          ),
                          hintText: 'Entrez le montant cible du projet',
                          labelText: 'Montant cible',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ktColor,
                            fontSize: 15.0,
                          ),
                          border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(20),
                              ),
                              borderSide: BorderSide(color: Color(0xff063970))
                          ),
                        prefixIcon: Icon(Icons.money)
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    TextField(
                      controller: _textDescription,
                      minLines: 3,
                      maxLines: 10,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'Entrez la description du projet',
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ktColor,
                            fontSize: 15.0,
                          ),
                          border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(20),
                              ),
                              borderSide: BorderSide(color: ktColor)
                          )
                      ),
                    ),

                    SizedBox(height: 15.0,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Insérez les visuels'.toUpperCase(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: OutlineButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.black26,
                                      width: 1,
                                    ),
                                    onPressed: (){
                                      takePhoto(ImageSource.gallery,1);
                                    },
                                    child: _imageFile1==null
                                        ? Padding(
                                          padding: EdgeInsets.fromLTRB(14, 70, 14, 70),
                                          child: Icon(Icons.add, color: Colors.grey),
                                        )
                                        :
                                        Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Image(
                                                  image: FileImage(File(_imageFile1.path)),
                                                  fit: BoxFit.fill, width: double.infinity,),
                                              ),
                                            ),
                                            Positioned(
                                                child: Center(
                                                  child: IconButton(
                                                    icon: Icon(Icons.delete_forever, color: Colors.grey,),
                                                    onPressed: (){
                                                      setState(() {
                                                        this._imageFile1 = null;
                                                      });
                                                    },
                                                  ),
                                                )
                                            )
                                          ],
                                        )
                                  ),
                                )
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: GestureDetector(
                        onTap: (){
                          try{
                            if(_textName.text ==''){
                              EasyLoading.showToast('le nom du projet est réquis pour effectuer cette opération !');
                            }
                            else if(_textAmount.text ==''){
                              EasyLoading.showToast('vous devez entrer votre montant cible !');
                            }
                            else if(this._imageFile1==null){
                              EasyLoading.showToast('vous devez entrer un visuel du projet !');
                            }
                            else{
                              final imgByte = File(_imageFile1.path).readAsBytesSync();
                              String base64Str = base64Encode(imgByte);
                              DBHelper.findWhere('data_user').then((value) {
                                value.forEach((row){
                                  EasyLoading.show(status: 'loading...');
                                  HttpService.createAProject(
                                      row['VALUE'],
                                      _textName.text,
                                      _textAmount.text,
                                      _textDescription.text,
                                      base64Str).then((res){
                                    if(res['reponse']=='oui'){
                                      EasyLoading.dismiss();
                                      setState(() {
                                        this._textName.text='';
                                        this._textAmount.text='';
                                        this._textDescription.text='';
                                        this._imageFile1 = null;
                                      });
                                      showSuccessDialog();
                                      refreshData(row['VALUE']);
                                    }
                                  });
                                });
                              });
                            }
                          }
                          catch(ex){
                            print(ex);
                          }

                        },
                        child: Container(
                          height: 60,
                          margin: EdgeInsets.only(top: 20.0,bottom: 40.0),
                          decoration:  BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black26,
                                  Colors.black87,
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
                                  offset: Offset(0, 5),
                                )
                              ]
                          ),
                          child: Center(
                            child: Text(
                              'souscrire'.toUpperCase(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Netflix",
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  Widget showSuccessDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: new Text("Succès !",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            content: new Text("votre projet a été créé avec succès !",
              style: TextStyle(
                color: Colors.black
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child:Text("Oui".toUpperCase(),
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop("Oui");
                },
              )
            ],
          );
        }
    );
  }
  //take picture
  void takePhoto(ImageSource source, int imageNumber) async{
    final pickedFile = await _picker.getImage(
        source: source
    );
    switch(imageNumber){
      case 1: setState((){
        _imageFile1=pickedFile;
      });
      break;
      case 2: setState((){
        _imageFile2=pickedFile;
      });
      break;
      case 3: setState((){
        _imageFile3=pickedFile;
      });
    }
  }
}
