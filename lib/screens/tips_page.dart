import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/health_record.dart';
import '../provider/health_records_provider.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  List<String> _generateTips(HealthRecord record) {
    List<String> tips = [];

    if (record.dailySteps != null) {
      if (record.dailySteps! < 5000) {
        tips.add(
            'Your daily steps are a bit low. Try taking short walks throughout the day to reach at least 5000 steps.');
      } else {
        tips.add(
            'Great job on staying active! Keep up your daily exercise routine.');
      }
    }

    if (record.weight != null) {
      if (record.weight! > 80) {
        tips.add(
            'Consider a balanced diet with more fruits, vegetables, and lean proteins to help manage your weight.');
      } else {
        tips.add(
            'Your weight is within a healthy range. Continue your balanced diet and regular exercise.');
      }
    }
  
    if (record.meals != null) {
      if (record.meals!.length < 10) {
        tips.add(
            'Try to include a variety of foods in your meals for a balanced diet.');
      } else {
        tips.add(
            'Your meals seem well thought out. Keep experimenting with healthy recipes!');
      }
    } else {
      tips.add(
          'Record your meals regularly to get personalized suggestions on healthy eating.');
    }
    return tips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Health Tips'),
      ),
      body: Consumer<HealthRecordsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.records.isEmpty) {
            return const Center(
                child: Text('No health data found. Please add your records.'));
          }

          HealthRecord latestRecord = provider.records.last;
          List<String> tips = _generateTips(latestRecord);

          return ListView.builder(
            itemCount: tips.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.health_and_safety),
                title: Text(tips[index]),
              );
            },
          );
        },
      ),
    );
  }
}
