class UserModel {
  String id;
  String nom;
  String classe; // 🔥 champ pour savoir dans quelle classe il est

  UserModel({
    required this.id,
    required this.nom,
    required this.classe,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      nom: map['nom'] ?? '',
      classe: map['classe'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'classe': classe,
    };
  }
}
