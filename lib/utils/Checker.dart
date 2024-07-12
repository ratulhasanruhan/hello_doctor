import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkIfDocExists(String docId) async {
  try {
    var collectionRef = FirebaseFirestore.instance.collection('doctor');
    var doc = await collectionRef.doc(docId).get();
    return doc.exists;
  } catch (e) {
    throw e;
  }
}

Future<bool> checkCard(String docId) async {
  try {
    var collectionRef = FirebaseFirestore.instance.collection('health_card');
    var doc = await collectionRef.doc(docId).get();
    return doc.exists;
  } catch (e) {
    throw e;
  }
}