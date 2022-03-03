import 'dart:async';
import 'dart:convert';

import 'package:blockquote/blockquote.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kusangisha/constants.dart';
import 'package:kusangisha/model/projet_model.dart';
import 'package:kusangisha/pages/subscription_to_project_page.dart';
import 'package:kusangisha/services/db_helper_service.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

class HomePage extends StatefulWidget {
  List<Projets> projets=[];
  HomePage({Key key, this.projets}) : super(key :key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  GlobalKey<RefreshIndicatorState> refreshKey;
  

  void getData() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonData = prefs.getString('projects');
      try{
        Iterable i = jsonDecode(jsonData);

        setState(() {
          widget.projets = List<Projets>.from(i.map((model)=> Projets.fromJson(model)));
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
    getData();
    EasyLoading.dismiss();
    return null;
  }
  @override
  void initState() {
    super.initState();
    DBHelper.findWhere('data_user').then((usr) {
      usr.forEach((r)=>loadData(usrId: r['VALUE']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        thickness: 5,radius: Radius.circular(10),
        showTrackOnHover: true,
        child: RefreshIndicator(
          color: ktColor,
          key: refreshKey,
          onRefresh: () async{
            await refresh();
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 200,
                              child: Carousel(
                                boxFit: BoxFit.fill,
                                images: [
                                  AssetImage('assets/images/img1.jpg'),
                                  AssetImage('assets/images/img2.jpg'),
                                  AssetImage('assets/images/img3.jpeg'),
                                  AssetImage('assets/images/img4.jpg'),
                                ],
                                autoplay:false,
                                //animationDuration: Duration(milliseconds: 500),
                                indicatorBgPadding: 10.0,
                                dotColor: Colors.white,
                                dotBgColor: Colors.black45,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Text(
                                'Nos réalisations',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    letterSpacing: 1.6,
                                    shadows: [
                                      Shadow(
                                          blurRadius: 2.0,
                                          color: Colors.black,
                                          offset: Offset(0,2)
                                      )
                                    ]
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 10.0),
                        Column(
                          children: <Widget>[
                            BlockQuote(
                              blockColor: ktColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    'Qui sommes-nous',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13.0,
                                      color: ktColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Kusangisha est une plateforme sociale, un système solidaire, un programme innovant qui utilise la loi des grands nombres. Il est une place de marché où les projets sélectionnés rencontrent des financements participatifs. Kusangisha est une initiative citoyenne initiée pour changer des vies et démontrer que IMPOSSIBLE n\'est pas humain. Le système consiste à mobiliser des citoyens en grands nombre de manière durable pour participer avec des paiements indolores à des projets d\'envergures.',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            BlockQuote(
                              blockColor: ktColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    'Ce que nous faisons',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13.0,
                                      color: ktColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Nous apportons l\'innovation au coeur de la société. Là où les gens se sont habitués à des pratiques rudimentaires, Kusangisha sème l\'ambition, l\'efficacité et la beauté pour relever la dignité des habitants. Les secteurs d\'intervention de l\'habitat décent, aux écoles et centres de santé modernes. Le travail sera modérnisé grâce à l\'energie et des machines modernes. L\'eau de qualité sera assurée et les habitants apprendront de nouvelles choses.',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Container(
                              height: 2.5,
                              width: 50,
                              color: ktColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'souscrire à un projet'.toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          shadows: [
                                            Shadow(
                                                blurRadius: 2,
                                                color: Colors.black12,
                                                offset: Offset(0,3)
                                            )
                                          ]
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: widget.projets.length,
                                    itemBuilder: (context, int index){
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context)=>
                                                  SubscribeToProject(
                                                      pId:widget.projets[index].projetId,
                                                      titre:widget.projets[index].titre,
                                                      description:widget.projets[index].description,
                                                      visual:_imageFromBase64String(widget.projets[index].couvertureVisuel),
                                                      montant:widget.projets[index].montant
                                                  )
                                              ),
                                                  (Route<dynamic> route) =>true
                                          );
                                        },
                                        child: Card(
                                          margin: EdgeInsets.only(bottom: 20.0),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(20),
                                                  bottomRight: Radius.circular(20),
                                                  topLeft:  Radius.circular(20),
                                                  topRight:  Radius.circular(20)
                                              )
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                  alignment: Alignment.center,
                                                  child:  ClipRRect(
                                                      borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(20),
                                                          topLeft: Radius.circular(20)
                                                      ),
                                                      child: _imageFromBase64String(widget.projets[index].couvertureVisuel)
                                                  )
                                              ),

                                              ButtonTheme(
                                                  child:  ButtonBar(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Align(
                                                          child: Text(widget.projets[index].titre,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          alignment: Alignment.topLeft,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10.0,),
                                                      LinearPercentIndicator(
                                                          width: MediaQuery.of(context).size.width - 50,
                                                          animation: true,
                                                          lineHeight: 5.0,
                                                          animationDuration: 2000,
                                                          percent: 0.2,
                                                          linearStrokeCap: LinearStrokeCap.roundAll,
                                                          progressColor: ktColor
                                                      ),
                                                      SizedBox(height: 10.0),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Column(
                                                            mainAxisAlignment:  MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              Icon(Icons.people_alt_rounded, color: ktColor,),
                                                              Text('05')
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:  MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              Icon(Icons.show_chart, color: ktColor,),
                                                              Text('250USD')
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:  MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              Icon(Icons.monetization_on_rounded, color: ktColor,),
                                                              Text('${widget.projets[index].montant}USD')
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                  /*FutureBuilder(
                                      future:widget.data,
                                      builder: (BuildContext context, AsyncSnapshot snapshot){
                                        if(snapshot.data == null){
                                          EasyLoading.show(status: 'loading...');
                                          return Container();
                                        }
                                        else{
                                          EasyLoading.dismiss();
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics: ScrollPhysics(),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, int index){
                                              return GestureDetector(
                                                onTap: (){
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(builder: (context)=>
                                                          SubscribeToProject(
                                                              pId:snapshot.data[index].projetId,
                                                              titre:snapshot.data[index].titre,
                                                              description:snapshot.data[index].description,
                                                              visual:_imageFromBase64String(snapshot.data[index].couvertureVisuel),
                                                              montant:snapshot.data[index].montant
                                                          )
                                                      ),
                                                          (Route<dynamic> route) =>true
                                                  );
                                                },
                                                child: Card(
                                                  margin: EdgeInsets.only(bottom: 20.0),
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(20),
                                                          bottomRight: Radius.circular(20),
                                                          topLeft:  Radius.circular(20),
                                                          topRight:  Radius.circular(20)
                                                      )
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Container(
                                                          alignment: Alignment.center,
                                                          child:  ClipRRect(
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius.circular(20),
                                                                  topLeft: Radius.circular(20)
                                                              ),
                                                              child: _imageFromBase64String(snapshot.data[index].couvertureVisuel)
                                                          )
                                                      ),

                                                      ButtonTheme(
                                                          child:  ButtonBar(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Align(
                                                                  child: Text(snapshot.data[index].titre,
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  alignment: Alignment.topLeft,
                                                                ),
                                                              ),
                                                              SizedBox(height: 10.0,),
                                                              LinearPercentIndicator(
                                                                  width: MediaQuery.of(context).size.width - 50,
                                                                  animation: true,
                                                                  lineHeight: 5.0,
                                                                  animationDuration: 2000,
                                                                  percent: 0.2,
                                                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                                                  progressColor: ktColor
                                                              ),
                                                              SizedBox(height: 10.0),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Column(
                                                                    mainAxisAlignment:  MainAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      Icon(Icons.people_alt_rounded, color: ktColor,),
                                                                      Text('05')
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:  MainAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      Icon(Icons.show_chart, color: ktColor,),
                                                                      Text('250USD')
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:  MainAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      Icon(Icons.monetization_on_rounded, color: ktColor,),
                                                                      Text('${snapshot.data[index].montant}USD')
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }
                                  )*/
                                ],
                              ),
                            )
                          ],
                        ),
                      ]),
                ),
              )
            ],
          ),
        )
    );
  }


  Image _imageFromBase64String(String base64String) {

    try{
      return Image.memory(
        base64Decode(base64String),
        fit: BoxFit.fitWidth,
      );
    }catch(e){
      return Image(
        image: AssetImage('assets/images/placeholder.jpg'),
        fit: BoxFit.fill,
      );
    }

  }
}
