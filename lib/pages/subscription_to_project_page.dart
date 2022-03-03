import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kusangisha/constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:sweetalert/sweetalert.dart';

class SubscribeToProject extends StatefulWidget {
  final String pId;
  final String titre;
  final String description;
  final Image visual;
  final String montant;
  SubscribeToProject({
      Key key, @required this.pId,
      @required this.titre,
      @required this.description,
      this.visual,
      this.montant
  }) : super(key: key);
  @override
  _SubscribeToProjectState createState() => _SubscribeToProjectState();
}

class _SubscribeToProjectState extends State<SubscribeToProject> {

  //variables
  bool isChecked = false;
  String dropdownValue = 'Hebdomadaire';
  String freq="Répétitif";

  final _textAmount= TextEditingController();
  @override
  String percent(double nbre){
    double _percent = nbre * 100;
    return _percent.toString();
  }


  @override
  void initState() {
    super.initState();
  }

  void onCheckBoxChanged(bool newValue) => setState(() {
    isChecked = newValue;
    if (isChecked) {
      openDialog();
    }
  });

  Image imageFromBase64String(String base64String) {
    try{
      return Image.memory(
        base64Decode(base64String),
        fit: BoxFit.fill,
      );
    }catch(e){
      return Image(
        image: AssetImage('assets/images/placeholder.jpg'),
        fit: BoxFit.fill,
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: subWidget(),
    );
  }

  Widget subWidget() {
    if(widget.titre==null){
      return Container(
        color: Colors.white,
        child: Center(
          child: SpinKitFadingCube(color: ktColor),
        ),
      );
    }
    else
    return SingleChildScrollView(
      child: Stack(children: <Widget>[
        // Background with gradient
        Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:widget.visual.image,
                fit: BoxFit.fill
              )
            ),
            height: MediaQuery.of(context).size.height * 0.3,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black87,
                  Colors.black12
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              )
            ),
          ),
        ),
        //Above card
        Card(
          color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            elevation: 0,
            margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 160.0),

            child: Column(
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.only(top: 20.0, left: 20.0, right: 18.0, bottom: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                              child: Text('${widget.titre}'.toUpperCase(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15.0,
                                    shadows: [
                                      Shadow(
                                          blurRadius: 2.0,
                                          color: Colors.black26,
                                          offset: Offset(0,2)
                                      )
                                    ]
                                ),
                              ),
                            ),
                            Divider(height: 5.0,color: Colors.white,),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('${widget.description}',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Divider(height: 10.0, color: ktColor),
                            ),
                            SizedBox(height: 10.0,),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                                  child: CircularPercentIndicator(
                                    circularStrokeCap: CircularStrokeCap.round,
                                    center: Text('${percent(0.05)} %',
                                      style: TextStyle(
                                          color: ktColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    radius: 100.0,
                                    percent: 0.05,
                                    progressColor:Colors.pink,
                                    lineWidth: 10.0,
                                    curve: Curves.easeInCirc,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5.0),
                                    child: Text('200USD / ${widget.montant}USD',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 15.0,
                                          color: ktColor
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, right: 20.0, top: 10.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Souscrire',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15.0,
                                      color: ktColor
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children:<Widget> [
                                    Expanded(
                                      child: TextField(
                                        controller: _textAmount,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            suffixIcon: Icon(
                                              Icons.monetization_on_rounded,
                                            ),
                                            hintText: 'montant...',
                                            labelText: 'Montant',
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: ktColor,
                                              fontSize: 12.0,
                                            ),
                                            border: new OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(
                                                  const Radius.circular(20.0),
                                                ),
                                                borderSide: BorderSide(color: ktColor)
                                            )
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                            activeColor:ktColor ,
                                            checkColor: Colors.white,
                                            value: isChecked,
                                            onChanged:onCheckBoxChanged
                                        ),
                                        Text('$freq'),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 40.0),

                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              if(_textAmount.text==''){
                                EasyLoading.showToast('Vous devez entrer le montant que vous voulez souscrire !');
                              }
                              else if(isChecked==false){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.black,
                                        content: Text("Veuillez sélectionner la frequence de paiement !",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                    )
                                );
                              }
                              else{
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black45,
                                      ktColor,
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
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
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
                  ),
                ]

            )),
        // Positioned to take only AppBar size
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(        // Add AppBar here only
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            brightness: Brightness.dark,
            actions: <Widget>[
              FlatButton.icon(
                label: Text('voter'.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: Colors.white
                  ),
                ),
                icon: Icon(Icons.whatshot, size: 15, color: Colors.white,),
                onPressed: (){
                  voteDialog();
                },
              )
            ],
          ),
        ),

      ]),
    );
  }

  Widget voteDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: new Text("Votez"),
            content: new Text("Etes-vous sûr de vouloir voter ?"),
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
                  Navigator.pop(context);
                  SweetAlert.show(
                    context,
                    subtitle: 'vote effectuée !',
                    style: SweetAlertStyle.success,
                    confirmButtonColor: Colors.green
                  );
                },
              ),
              CupertinoDialogAction(
                child: Text("Non".toUpperCase(),
                  style: TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  Widget openDialog(){

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children:<Widget> [
                Container(
                  height: 40.0,
                  width: 225.0,
                  color:  ktColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.calendar_today, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13.0, left: 10.0),
                        child: Text('Choisir la fréquence'.toUpperCase(),
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 60.0, right: 8.0, left: 8.0, bottom: 8.0),
                      child: new DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue,
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                        items: <String>['Hebdomadaire', 'Mensuelle','Trimestrielle', 'Annuelle'].map((String nvalue) {
                          return new DropdownMenuItem<String>(
                            value: nvalue,
                            child: new Text(nvalue,
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: ktColor
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            freq = newValue;
                            Navigator.pop(context);
                          });
                        },
                      )
                    ),
                  ]
                ),
              ],
            ),
          );
        }
    );
  }
}