import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kshieldauth/models/book.dart';
import '../controllers/book_controller.dart';
import '../controllers/user_controller.dart';

class StockManagementPage extends StatelessWidget {
  final BookController bookController = Get.find();
  final UserController userController = Get.find();
  final Color blue = Color(0xFF125695);
  final TextEditingController searchController = TextEditingController();

  StockManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      appBar: AppBar(
        backgroundColor: blue,
        title: Text("Gestion du Stock",
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
                  labelText: "Rechercher un livre",
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                onChanged: (value) => bookController.filterBooks(value),
              ),
            ),
            Expanded(
              child: Obx(() {
                var classes = bookController.filteredBooks
                    .map((b) => b.classe)
                    .toSet()
                    .toList();
        
                if (classes.isEmpty) {
                  return Center(
                    child: Text("Aucun livre trouvé", style: TextStyle(color: Colors.white)),
                  );
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
                        ...booksInClasse.map((book) => ListTile(
                              leading: Icon(Icons.book, color: Colors.blue),
                              title: Text(book.titre),
                              subtitle: Text(book.isAvailable
                                  ? "Disponible"
                                  : "Emprunté par ${book.borrowedByNom ?? ''}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () => _showEditBookDialog(context, book),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => bookController.deleteBook(book.id),
                                  ),
                                ],
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddBookWithClassDialog(context),
      ),
    );
  }

  /// 🔹 Ajouter un livre avec sélection de classe ou création d'une nouvelle
  void _showAddBookWithClassDialog(BuildContext context) {
    TextEditingController titreCtrl = TextEditingController();
    TextEditingController classeCtrl = TextEditingController();
    String? selectedClasse;

    List<String> existingClasses = userController.users.map((u) => u.classe).toSet().toList();

    Get.dialog(AlertDialog(
      title: Text("Ajouter un livre"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titreCtrl,
            decoration: InputDecoration(labelText: "Titre du livre"),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedClasse,
            hint: Text("Sélectionner une classe"),
            items: existingClasses
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (val) {
              selectedClasse = val;
              classeCtrl.text = val ?? "";
            },
          ),
          TextField(
            controller: classeCtrl,
            decoration: InputDecoration(labelText: "Ou créer une nouvelle classe"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("Annuler")),
        ElevatedButton(
          onPressed: () {
            if (titreCtrl.text.isNotEmpty && classeCtrl.text.isNotEmpty) {
              bookController.addBook(BookModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                titre: titreCtrl.text,
                classe: classeCtrl.text,
              ));
              Get.back();
            }
          },
          child: Text("Ajouter"),
        ),
      ],
    ));
  }

  void _showEditBookDialog(BuildContext context, BookModel book) {
    TextEditingController titreCtrl = TextEditingController(text: book.titre);

    Get.dialog(AlertDialog(
      title: Text("Modifier ${book.titre}"),
      content: TextField(
        controller: titreCtrl,
        decoration: InputDecoration(labelText: "Titre du livre"),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("Annuler")),
        ElevatedButton(
          onPressed: () {
            if (titreCtrl.text.isNotEmpty) {
              bookController.updateBook(book.id, titreCtrl.text);
              Get.back();
            }
          },
          child: Text("Modifier"),
        ),
      ],
    ));
  }
}
