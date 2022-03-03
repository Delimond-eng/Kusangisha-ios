class ProjectsModel {
  List<Projets> projets;

  ProjectsModel({this.projets});

  ProjectsModel.fromJson(Map<String, dynamic> json) {
    if (json['projets'] != null) {
      projets = new List<Projets>();
      json['projets'].forEach((v) {
        projets.add(new Projets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projets != null) {
      data['projets'] = this.projets.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Projets {
  String projetId;
  String userAccountId;
  String titre;
  String montant;
  String devise;
  String description;
  String couvertureVisuel;
  String projetStatut;
  String dateCreation;

  Projets(
      {this.projetId,
        this.userAccountId,
        this.titre,
        this.montant,
        this.devise,
        this.description,
        this.couvertureVisuel,
        this.projetStatut,
        this.dateCreation});

  Projets.fromJson(Map<String, dynamic> json) {
    projetId = json['projet_id'];
    userAccountId = json['user_account_id'];
    titre = json['titre'];
    montant = json['montant'];
    devise = json['devise'];
    description = json['description'];
    couvertureVisuel = json['couverture_visuel'];
    projetStatut = json['projet_statut'];
    dateCreation = json['date_creation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projet_id'] = this.projetId;
    data['user_account_id'] = this.userAccountId;
    data['titre'] = this.titre;
    data['montant'] = this.montant;
    data['devise'] = this.devise;
    data['description'] = this.description;
    data['couverture_visuel'] = this.couvertureVisuel;
    data['projet_statut'] = this.projetStatut;
    data['date_creation'] = this.dateCreation;
    return data;
  }
}