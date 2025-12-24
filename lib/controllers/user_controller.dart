import 'package:flutter/widgets.dart'; // Pour WidgetsBinding
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kshieldauth/models/user.dart';

class UserController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var users = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() {
    firestore.collection('users').snapshots().listen((snapshot) {
      // ✅ Assurer l'exécution sur le thread principal
      WidgetsBinding.instance.addPostFrameCallback((_) {
        users.value = snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return UserModel.fromMap(data);
        }).toList();
        filteredUsers.value = users;
      });
    });
  }

  /// 🔥 Récupérer uniquement les étudiants d’une classe
  List<UserModel> getUsersByClasse(String classe) {
    return users.where((u) => u.classe == classe).toList();
  }

  void filterUsers(String query) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (query.isEmpty) {
        filteredUsers.value = users;
      } else {
        filteredUsers.value = users
            .where((u) =>
                u.nom.toLowerCase().contains(query.toLowerCase()) ||
                u.classe.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void addUser(UserModel user) {
    firestore.collection('users').add(user.toMap());
  }

  void updateUser(UserModel user) {
    firestore.collection('users').doc(user.id).update(user.toMap());
  }

  void deleteUser(String id) {
    firestore.collection('users').doc(id).delete();
  }
}
