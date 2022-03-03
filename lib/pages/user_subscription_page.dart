import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kusangisha/services/db_helper_service.dart';

class OwnSubscription extends StatefulWidget {
  @override
  _OwnSubscriptionState createState() => _OwnSubscriptionState();
}

class _OwnSubscriptionState extends State<OwnSubscription> {

  Future<dynamic> data;

  @override
  void initState() {
    super.initState();

    setState(() {
      data = DBHelper.getAllData();
    });
  }

  void refreshData(){
    setState(() {
      data = DBHelper.getAllData();
    });
  }
  @override
  Widget build(BuildContext context) {
    /*return FutureBuilder(
        future: data,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null){
            return Center(
              child: SpinKitCircle(color: Colors.black38),
            );
          }
          else{
            return Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int i){
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(snapshot.data[i]['KEY']),
                        subtitle: Text(snapshot.data[i]['VALUE']),
                        trailing: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: (){
                            DBHelper.deleteData(snapshot.data[i]['ID']);
                            refreshData();
                          },
                        ),
                      ),
                    );
                  }
              ),
            );
          }
        }
    );*/
    return Center(
      child: Text('souscription'),
    );
  }
}
