import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/health_records_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Records'),
      ),
      body: Consumer<HealthRecordsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.records.isEmpty) {
            return const Center(
              child: Text(
                'No records found',
                style: TextStyle(color: Colors.black),
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.records.length,
            itemBuilder: (context, index) {
              final record = provider.records[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Steps: ${record.dailySteps}',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Weight: ${record.weight}',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14.0),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Meals: ${record.meals}',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          if (record.uid != null) {
                            await Provider.of<HealthRecordsProvider>(context,
                                    listen: false)
                                .deleteRecord(record.uid!);
                            Fluttertoast.showToast(
                              msg: 'Data deleted successfully',
                              gravity: ToastGravity.TOP,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
