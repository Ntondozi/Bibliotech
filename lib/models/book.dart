class BookModel {
  String id;
  String titre;
  String classe;   // 🔥 Nouvelle propriété : classe à laquelle appartient le livre
  bool isAvailable;
  String? borrowedByUserId;
  String? borrowedByNom;
  String? borrowedByClasse;
  DateTime? borrowedAt;
  DateTime? dueAt;

  BookModel({
    required this.id,
    required this.titre,
    required this.classe,   // 🔥 obligatoire
    this.isAvailable = true,
    this.borrowedByUserId,
    this.borrowedByNom,
    this.borrowedByClasse,
    this.borrowedAt,
    this.dueAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'titre': titre,
        'classe': classe,
        'isAvailable': isAvailable,
        'borrowedByUserId': borrowedByUserId,
        'borrowedByNom': borrowedByNom,
        'borrowedByClasse': borrowedByClasse,
        'borrowedAt': borrowedAt?.millisecondsSinceEpoch,
        'dueAt': dueAt?.millisecondsSinceEpoch,
      };

  factory BookModel.fromMap(Map<String, dynamic> map) => BookModel(
        id: map['id'],
        titre: map['titre'],
        classe: map['classe'] ?? "",   // 🔥 fallback
        isAvailable: map['isAvailable'] ?? true,
        borrowedByUserId: map['borrowedByUserId'],
        borrowedByNom: map['borrowedByNom'],
        borrowedByClasse: map['borrowedByClasse'],
        borrowedAt: map['borrowedAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['borrowedAt'])
            : null,
        dueAt: map['dueAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['dueAt'])
            : null,
      );
}
