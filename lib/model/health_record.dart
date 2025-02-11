class HealthRecord {
  String? uid;
  int? dailySteps;
  double? weight;
  String? meals;

  HealthRecord({this.uid, this.dailySteps, this.weight, this.meals});

  HealthRecord.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    dailySteps = data['dailySteps'] is int
        ? data['dailySteps']
        : int.tryParse(data['dailySteps'].toString());
    weight = data['weight'] is double
        ? data['weight']
        : double.tryParse(data['weight'].toString());
    meals = data['meals'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'dailySteps': dailySteps,
      'weight': weight,
      'meals': meals,
    };
  }
}
