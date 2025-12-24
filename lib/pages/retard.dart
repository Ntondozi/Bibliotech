import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kshieldauth/models/book.dart';
import '../controllers/book_controller.dart';
import '../controllers/user_controller.dart';

class DelayManagementPage extends StatelessWidget {
  final BookController bookController = Get.find();
  final UserController userController = Get.find();
  var blue = Color(0xFF125695);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      appBar: AppBar(
        backgroundColor: blue,
        title: Text("Gestion des Retards", style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
      body: Obx(() {
        var overdueBooks = bookController.books
            .where((b) => !b.isAvailable && b.dueAt != null && DateTime.now().isAfter(b.dueAt!))
            .toList();

        if (overdueBooks.isEmpty) {
          return Center(child: Text("Aucun retard détecté ✅", style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)));
        }

        return ListView.builder(
  itemCount: overdueBooks.length,
  itemBuilder: (_, i) {
    BookModel book = overdueBooks[i];
    var user = userController.users.firstWhereOrNull((u) => u.id == book.borrowedByUserId);

    int delay = DateTime.now().difference(book.dueAt!).inDays;
    String status = delay <= 0 ? "Fiable" : "Non fiable";

    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 2),
      color: Colors.white, // Couleur de fond blanche
      child: ListTile(
        title: Text(book.titre),
        subtitle: Text(
          "${book.borrowedByNom ?? 'Inconnu'} - ${book.borrowedByClasse ?? ''}",
        ),
        trailing: Text(
          status,
          style: TextStyle(
            color: status == "Fiable" ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  },
);

      }),
    );
  }
}
