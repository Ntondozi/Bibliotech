import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kshieldauth/models/user.dart';
import '../controllers/user_controller.dart';

class UserManagementPage extends StatelessWidget {
  final UserController userController = Get.find();
  final TextEditingController searchController = TextEditingController();
  var blue = Color(0xFF125695);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      appBar: AppBar(
        backgroundColor: blue,
        title: Text("Gestion des Utilisateurs",  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))  ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// 🔍 Champ de recherche
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 242, 236, 236),
                  labelText: "Rechercher par nom ou classe",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => userController.filterUsers(value),
              ),
            ),
        
            /// 👇 Liste des classes + étudiants
            Expanded(
              child: Obx(() {
                // 🔥 Extraire toutes les classes uniques à partir des utilisateurs filtrés
                var classes = userController.filteredUsers
                    .map((u) => u.classe)
                    .toSet()
                    .toList();
        
                if (classes.isEmpty) {
                  return Center(child: Text("Aucune donnée trouvée"));
                }
        
                return ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (_, i) {
                    String classe = classes[i];
                    var usersInClasse = userController.filteredUsers
                        .where((u) => u.classe == classe)
                        .toList();
        
                    return ExpansionTile(
                      collapsedBackgroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                      title: Text("Classe : $classe",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      children: [
                        ...usersInClasse.map((user) => ListTile(
                              leading: Icon(Icons.person, color: Colors.blue),
                              title: Text(user.nom),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () =>
                                        _showEditUserDialog(context, user),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        userController.deleteUser(user.id),
                                  ),
                                ],
                              ),
                            )),
                        ListTile(
                          leading: Icon(Icons.add, color: Colors.green),
                          title: Text("Ajouter un étudiant"),
                          onTap: () => _showAddUserDialog(context, classe),
                        )
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),

      /// ➕ Ajouter un étudiant avec choix de la classe
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddUserDialog(context, null),
      ),
    );
  }

  /// ✅ Ajout d’un étudiant
  void _showAddUserDialog(BuildContext context, String? classe) {
  TextEditingController nomCtrl = TextEditingController();
  TextEditingController classeCtrl = TextEditingController(text: classe ?? "");
  String? selectedClasse;

  List<String> existingClasses = userController.users.map((u) => u.classe).toSet().toList();

  Get.dialog(AlertDialog(
    title: Text("Ajouter un étudiant"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(controller: nomCtrl, decoration: InputDecoration(labelText: "Nom")),
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
          if (nomCtrl.text.isNotEmpty && classeCtrl.text.isNotEmpty) {
            userController.addUser(UserModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              nom: nomCtrl.text,
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

  /// ✅ Modification d’un étudiant
  void _showEditUserDialog(BuildContext context, UserModel user) {
    TextEditingController nomCtrl = TextEditingController(text: user.nom);
    TextEditingController classeCtrl = TextEditingController(text: user.classe);

    Get.dialog(AlertDialog(
      title: Text("Modifier l'étudiant"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: nomCtrl, decoration: InputDecoration(labelText: "Nom")),
          SizedBox(height: 8),
          TextField(
              controller: classeCtrl,
              decoration: InputDecoration(labelText: "Classe")),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("Annuler")),
        ElevatedButton(
          onPressed: () {
            if (nomCtrl.text.isNotEmpty && classeCtrl.text.isNotEmpty) {
              userController.updateUser(UserModel(
                id: user.id,
                nom: nomCtrl.text,
                classe: classeCtrl.text,
              ));
              Get.back();
            }
          },
          child: Text("Enregistrer"),
        ),
      ],
    ));
  }
}
