import 'package:flutter/material.dart';
import '../model/health_record.dart';
import '../services/firestore_services.dart';

class HealthRecordsProvider extends ChangeNotifier {
  List<HealthRecord> _records = [];
  bool _isLoading = false;

  List<HealthRecord> get records => _records;
  bool get isLoading => _isLoading;

  HealthRecordsProvider() {
    loadRecords();
  }

  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();
    _records = await FirestoreService().readHealthData();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRecord(int dailySteps, double weight, String meals) async {
    await FirestoreService().addHealthData(dailySteps, weight, meals);
    await loadRecords();
  }

  Future<void> deleteRecord(String uid) async {
    await FirestoreService().deleteHealthData(uid);
    await loadRecords();
  }
}
