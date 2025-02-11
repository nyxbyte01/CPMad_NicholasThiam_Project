import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/health_record.dart';

class FirestoreService {
  final CollectionReference healthCollection =
      FirebaseFirestore.instance.collection('health');

  Future<void> addHealthData(int dailySteps, double weight, String meals) async {
    var docRef = healthCollection.doc();
    debugPrint('Adding docRef: ${docRef.id}');

    await healthCollection.doc(docRef.id).set({
      'uid': docRef.id,
      'dailySteps': dailySteps,
      'weight': weight,
      'meals': meals,
    });
  }

  Future<List<HealthRecord>> readHealthData() async {
    List<HealthRecord> healthList = [];
    QuerySnapshot snapshot = await healthCollection.get();

    for (var document in snapshot.docs) {
      HealthRecord record =
          HealthRecord.fromMap(document.data() as Map<String, dynamic>);
      healthList.add(record);
    }

    debugPrint('HealthList: $healthList');
    return healthList;
  }

  Future<void> deleteHealthData(String docId) async {
    await healthCollection.doc(docId).delete();
    debugPrint('Deleting uid: $docId');
  }

  Future<void> updateHealthData(
      String docId, int dailySteps, double weight, String meals) async {
    debugPrint('Updating docRef: $docId');

    await healthCollection.doc(docId).update({
      'dailySteps': dailySteps,
      'weight': weight,
      'meals': meals,
    });
  }

  Future<void> deleteAllHealthRecords() async {
    QuerySnapshot snapshot = await healthCollection.get();
    for (var ds in snapshot.docs) {
      await ds.reference.delete();
    }
    debugPrint('All health records deleted.');
  }
}
