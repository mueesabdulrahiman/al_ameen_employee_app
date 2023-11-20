import 'package:al_ameen_employer_app/data/models/api_status.dart';
import 'package:al_ameen_employer_app/data/models/data.dart';
import 'package:al_ameen_employer_app/data/models/login.dart';
import 'package:al_ameen_employer_app/ui/view_models/login_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class FirebaseRepository {
  Future<void> connect();
  Future signInUser(Login login, BuildContext context);
  Future<void> insert(Data model);
  Future getData();
  Future<void> deleteData(String id);
  Future getChairs();
}

class FirebaseRepositoryImplementation implements FirebaseRepository {
  @override
  Future<void> connect() async {
    await Firebase.initializeApp();
  }

  @override
  Future<void> deleteData(String id) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    await docUser.delete();
  }

  @override
  Future getData() async {
    List<Data> data = [];
    try {
      final collections = FirebaseFirestore.instance.collection('users');
      final querySnapshot = await collections.get();

      data =
          querySnapshot.docs.map((doc) => Data.fromJson(doc.data())).toList();

      return Success(code: 400, response: data);
    } on FirebaseException catch (e) {
      return Failure(code: 404, response: e.message.toString());
    }
  }

  @override
  Future<void> insert(Data? model) async {
    if (model != null) {
      try {
        final docUser = FirebaseFirestore.instance.collection('users').doc();

        model.id = docUser.id;
        docUser.set(model.toJson());
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  @override
  Future signInUser(Login login, BuildContext context) async {
    final navigator = Navigator.of(context);
    final provider = Provider.of<LoginProvider>(context, listen: false);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "${login.username}@gmail.com", password: login.password);

      navigator.pop();
      final user = result.user!.email!;
      return Success(response: user, code: 200);
    } on FirebaseAuthException catch (e) {
      provider.setFailure(true);
      navigator.pop();
      return Failure(code: 404, response: e.message ?? 'something went wrong');
    }
  }

  @override
  Future getChairs() async {
    List<String> chairs = [];

    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('chairs').get();
      for (final document in querySnapshot.docs) {
        final data = document.data();
        chairs.add(data['name']);
      }
      return Success(response: chairs, code: 200);
    } on FirebaseException catch (e) {
      return Failure(code: 404, response: e.message.toString());
    }
  }
}
