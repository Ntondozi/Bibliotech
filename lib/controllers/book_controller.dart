import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kshieldauth/models/book.dart';
import 'package:kshieldauth/models/user.dart';

class BookController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var books = <BookModel>[].obs;         // Tous les livres
  var filteredBooks = <BookModel>[].obs; // Livres filtrés pour la recherche

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  /// 🔹 Récupérer tous les livres depuis Firebase
  void fetchBooks() {
    firestore.collection('books').snapshots().listen((snapshot) {
      books.value = snapshot.docs.map((e) => BookModel.fromMap(e.data())).toList();
      filteredBooks.value = books; // par défaut, tous les livres
    });
  }

  /// 🔹 Filtrer les livres selon le texte de recherche
  void filterBooks(String query) {
    if (query.isEmpty) {
      filteredBooks.value = books; // reset si vide
    } else {
      filteredBooks.value = books
          .where((b) => b.titre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  /// 🔹 Ajouter un livre
  void addBook(BookModel book) {
    firestore.collection('books').doc(book.id).set(book.toMap());
  }

  /// 🔹 Supprimer un livre
  void deleteBook(String id) {
    firestore.collection('books').doc(id).delete();
  }

  /// 🔹 Mettre à jour le titre d'un livre
  void updateBook(String id, String nouveauTitre) {
    firestore.collection('books').doc(id).update({'titre': nouveauTitre});
  }

  /// 🔹 Emprunter un livre
  void borrowBook(BookModel book, UserModel user) {
    book.isAvailable = false;
    book.borrowedByUserId = user.id;
    book.borrowedByNom = user.nom;
    book.borrowedByClasse = user.classe;
    book.borrowedAt = DateTime.now();
    book.dueAt = DateTime.now().add(Duration(days: 2));

    firestore.collection('books').doc(book.id).update(book.toMap());
  }

  /// 🔹 Retourner un livre
  void returnBook(BookModel book) {
    book.isAvailable = true;
    book.borrowedByUserId = null;
    book.borrowedByNom = null;
    book.borrowedByClasse = null;
    book.borrowedAt = null;
    book.dueAt = null;

    firestore.collection('books').doc(book.id).update(book.toMap());
  }
}
