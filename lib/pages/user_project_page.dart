import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:kusangisha/constants.dart';
import 'package:kusangisha/model/project_model.dart';
import 'package:kusangisha/model/projet_model.dart';
import 'package:kusangisha/services/db_helper_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerProject extends StatefulWidget {
  @override
  _OwnerProjectState createState() => _OwnerProjectState();
}

class _OwnerProjectState extends State<OwnerProject> {

  GlobalKey<RefreshIndicatorState> refreshKey;

  List<Projets> userProjects=[];

  Future<List<Projets>> getUserProjects() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString('userProjects');
    Iterable i = jsonDecode(jsonData);
    return List<Projets>.from(i.map((model)=> Projets.fromJson(model)));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonData = prefs.getString('userProjects');
      try{
        Iterable i = jsonDecode(jsonData);

        setState(() {
          userProjects = List<Projets>.from(i.map((model)=> Projets.fromJson(model)));
        });

      }
      catch(e){
        print(e);
      }
    }
    catch(ex){
      print(ex);
    }
  }

  Future<Null> refresh() async{
    EasyLoading.show(status: 'Chargement...');
    await Future.delayed(Duration(seconds: 1));
    getUserProjects();
    EasyLoading.dismiss();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        thickness: 5, radius: Radius.circular(10),
        showTrackOnHover: true,
        child: RefreshIndicator(
            color: Colors.black87,
            key: refreshKey,
            onRefresh: () async {
              await refresh();
            },
            child: FutureBuilder(
              future: getUserProjects(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.data == null){
                  EasyLoading.show(status: 'Chargement...');
                  return Center();
                }
                else{
                  EasyLoading.dismiss();
                  return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: snapshot.data.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                              childAspectRatio: 0.75
                          ),
                          itemBuilder: (context, int index) {
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(0))
                              ),
                              shadowColor: Colors.black26,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                          child: _imageFromBase64String(
                                              snapshot.data[index].couvertureVisuel)
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 5.0),
                                    child: Text('${snapshot.data[index].titre}',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: <Widget>[
                                        Icon(Icons.show_chart, color: Colors.grey,),
                                        Expanded(
                                          child: Text('${snapshot.data[index]
                                              .montant}USD / 1500USD',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w900
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          Container(
                                            color: ktColor,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            height: 20.0,
                                            child: Center(
                                              child: Text(
                                                '${snapshot.data[index].projetStatut}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                      )
                  );
                }
              }
            )
        )
    );
  }

  Image _imageFromBase64String(String base64String) {

    try{
      return Image.memory(
        base64Decode(base64String),
        fit: BoxFit.fitWidth,
        height: 100,
        width: MediaQuery.of(context).size.width,
      );
    }catch(e){
      return Image(
        image: AssetImage('assets/images/placeholder.jpg'),
        fit: BoxFit.fitWidth,
        height: 100,
        width: 200,
      );
    }

  }
}
