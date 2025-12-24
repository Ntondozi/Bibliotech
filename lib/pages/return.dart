import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kshieldauth/models/book.dart';
import '../controllers/book_controller.dart';
import '../controllers/user_controller.dart';

class ReturnBookPage extends StatelessWidget {
  final BookController bookController = Get.find();
  final UserController userController = Get.find();
  final Color blue = Color(0xFF125695);
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      appBar: AppBar(
        backgroundColor: blue,
        title: Text("Retourner un livre",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 242, 236, 236),
                  filled: true,
                  hintText: 'Rechercher un livre',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => bookController.fetchBooks(),
              ),
            ),
            Expanded(
              child: Obx(() {
                // 🔹 Filtrer les livres empruntés
                var borrowedBooks = bookController.books
                    .where((b) => !b.isAvailable)
                    .where((b) => b.titre.toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .toList();
        
                // 🔹 Extraire toutes les classes
                var classes = borrowedBooks.map((b) => b.classe).toSet().toList();
        
                if (classes.isEmpty) {
                  return Center(
                    child: Text(
                      "Aucun livre emprunté trouvé",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
        
                return ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (_, i) {
                    String classe = classes[i];
                    var booksInClasse = borrowedBooks
                        .where((b) => b.classe == classe)
                        .toList();
        
                    return ExpansionTile(
                      collapsedBackgroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                      title: Text("Classe : $classe",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      children: booksInClasse.map((book) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 244, 238, 238),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.book, color: Colors.red),
                            title: Text(
                              book.titre,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Emprunté par ${book.borrowedByNom ?? 'Inconnu'} "
                              "(${book.borrowedByClasse ?? ''}) "
                              "- Le : ${book.borrowedAt?.toLocal().toString().split(' ')[0]}",
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                bookController.returnBook(book);
                                Get.snackbar("Succès", "Livre retourné !");
                              },
                              child: Text("Retourner"),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
