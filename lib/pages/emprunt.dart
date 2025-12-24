import 'package:kshieldauth/models/book.dart';
import 'package:kshieldauth/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';
import '../controllers/user_controller.dart';

class BorrowBookPage extends StatelessWidget {
  final BookController bookController = Get.put(BookController());
  final UserController userController = Get.put(UserController());
  final TextEditingController searchController = TextEditingController();
  var blue = Color(0xFF125695);

  BorrowBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      appBar: AppBar(
        backgroundColor: blue,
        title: Text('Emprunter un livre',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// 🔍 Barre de recherche
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 242, 236, 236),
                hintText: 'Rechercher par titre ou classe',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => bookController.filterBooks(searchController.text),
            ),
        
            /// 👇 Titre
            Row(
              children: [
                Text('Livres : ',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
        
            /// 👇 Liste des livres filtrés par titre et classe
            Expanded(
              child: Obx(() {
                // Extraire les classes à partir des livres filtrés
                var classes = bookController.filteredBooks
                    .map((b) => b.classe)
                    .toSet()
                    .toList();
        
                if (classes.isEmpty) {
                  return Center(
                      child: Text("Aucun livre trouvé",
                          style: TextStyle(color: Colors.white)));
                }
        
                return ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (_, i) {
                    String classe = classes[i];
                    var booksInClasse = bookController.filteredBooks
                        .where((b) => b.classe == classe)
                        .toList();
        
                    return ExpansionTile(
                      collapsedBackgroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                      title: Text("Classe : $classe",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      children: [
                        ...booksInClasse.map((book) => Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: book.isAvailable
                                    ? const Color.fromARGB(255, 244, 238, 238)
                                    : const Color.fromARGB(255, 236, 203, 203),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: Icon(Icons.book,
                                    color: book.isAvailable ? Colors.green : Colors.red),
                                title: Text(book.titre),
                                trailing: Text(
                                  book.isAvailable ? 'Disponible' : 'Emprunté',
                                  style: TextStyle(
                                      color: book.isAvailable ? Colors.green : Colors.red),
                                ),
                                onTap: book.isAvailable
                                    ? () => selectUserAndBorrow(context, book)
                                    : null,
                              ),
                            )),
                      ],
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

  void selectUserAndBorrow(BuildContext context, BookModel book) {
    showDialog(
      context: context,
      builder: (_) {
        String? selectedClasse;
        String? selectedUserId;
        var usersInClasse = <UserModel>[];
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Sélectionner l\'emprunteur'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  hint: Text('Choisir la classe'),
                  value: selectedClasse,
                  items: userController.users
                      .map((u) => u.classe)
                      .toSet()
                      .map((c) => DropdownMenuItem(
                            child: Text(c),
                            value: c,
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedClasse = val;
                      usersInClasse = userController.users
                          .where((u) => u.classe == val)
                          .toList();
                      selectedUserId = null;
                    });
                  },
                ),
                DropdownButton<String>(
                  hint: Text('Choisir l\'élève'),
                  value: selectedUserId,
                  items: usersInClasse
                      .map((u) => DropdownMenuItem(
                            value: u.id,
                            child: Text(u.nom),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() => selectedUserId = val);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler')),
              ElevatedButton(
                onPressed: selectedUserId != null
                    ? () {
                        var user = userController.users
                            .firstWhere((u) => u.id == selectedUserId);
                        bookController.borrowBook(book, user);
                        Navigator.pop(context);
                      }
                    : null,
                child: Text('Emprunter'),
              )
            ],
          );
        });
      },
    );
  }
}
