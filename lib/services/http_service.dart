import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:kusangisha/model/project_model.dart';
import 'package:kusangisha/model/projet_model.dart';

class HttpService{

  static final baseUrl='https://demo-kusangisha.rosepay.org/';

  //Affichage de tous les projets
  @override
  static Future<ProjectsModel> getData() async{
    http.Response res = await http.get(
        Uri.parse('${baseUrl}/projet/voirProjet'),
        headers: {"Accept": "application/json"}
    );
    /*Map<String, dynamic> map = json.decode(res.body);
    List<dynamic> data = map["projets"];

    List<Projects> datas = [];

    for(var p in data){
      Projects projects = Projects(
          p['projet_id'],
          p['user_account_id'],
          p['titre'],
          p['montant'],
          p['devise'],
          p['description'],
          p['couverture_visuel'],
          p['projet_statut']
      );
      datas.add(projects);
    }
    return datas;*/
    return ProjectsModel.fromJson(jsonDecode(res.body));
  }

  //affichage de tous les projets créés par un utilisateur
  @override
  static Future<ProjectsModel> findData({String userId}) async{
    http.Response res = await http.post(
        Uri.parse('${baseUrl}/projet/recuperationProjetUsers'),
        headers: {"Accept": "application/json"},
      body: jsonEncode(<String, String>{
        'user_account_id' : userId
      })
    );
    return ProjectsModel.fromJson(jsonDecode(res.body));
    /*Map<String, dynamic> map = json.decode(res.body);
    List<dynamic> data = map["projets"];

    List<Projects> datas = [];

    for(var p in data){
      Projects projects = Projects(
          p['projet_id'],
          p['user_account_id'],
          p['titre'],
          p['montant'],
          p['devise'],
          p['description'],
          p['couverture_visuel'],
          p['projet_statut']
      );
      datas.add(projects);
    }
    return datas;*/
  }

  //recuperation des projets souscrits par le User
  @override
  static Future<List<Projects>> findSubscrite(String userId) async{
    http.Response res = await http.post(
        Uri.parse('${baseUrl}/projet/recuperationContributionUsers'),
        headers: {"Accept": "application/json"},
        body: jsonEncode(<String, String>{
          'user_account_id' : userId
        })
    );
    Map<String, dynamic> map = json.decode(res.body);
    List<dynamic> data = map["projets"];

    List<Projects> datas = [];

    for(var p in data){
      Projects projects = Projects(
          p['projet_id'],
          p['user_account_id'],
          p['titre'],
          p['montant'],
          p['devise'],
          p['description'],
          p['couverture_visuel'],
          p['projet_statut']
      );
      datas.add(projects);
    }
    return datas;
  }

  //Connexion User
  @override
  static Future Login(String phone, String pwd) async{
    final response = await http.post(
      Uri.parse('${baseUrl}/connexion/connexionusers'),
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': phone,
        'pass': pwd,
      }),
    );
    if(response.statusCode ==200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception('your post isn\'t sending');
    }
  }

  //Enregistrement User
  @override
  static Future createAccount(String fullname, String email, String phone, String pass) async{
    final response = await http.post(
      Uri.parse('${baseUrl}/connexion/creationusers'),
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fullname':fullname,
        'email':email,
        'phone': phone,
        'pass': pass,
      }),
    );
    if(response.statusCode ==200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception('your post isn\'t sending');
    }
  }

  //Creation du projet
  @override
  static Future createAProject(String userId, String titre, String montant, String description, String b64str) async{
    final response = await http.post(
      Uri.parse('${baseUrl}/projet/creationProjet'),
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_account_id': userId,
        'titre': titre,
        'montant':montant,
        'devise':'USD',
        'description': description,
        'couverture_visuel': b64str,
      }),
    );
    if(response.statusCode ==200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception('your post isn\'t sending');
    }
  }

}