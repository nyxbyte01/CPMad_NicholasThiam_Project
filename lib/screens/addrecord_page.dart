import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../provider/health_records_provider.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({super.key});

  @override
  AddRecordPageState createState() => AddRecordPageState();
}

class AddRecordPageState extends State<AddRecordPage> {
  int? dailySteps;
  double? weight;
  String? meals;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Saving Health Record'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Daily Steps'),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter Daily Steps' : null,
                  onSaved: (val) => dailySteps = int.tryParse(val!),
                ),
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Weight'),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter Weight' : null,
                  onSaved: (val) => weight = double.tryParse(val!),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Meals'),
                  maxLength: 50, 
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter Meals' : null,
                  onSaved: (val) => meals = val,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Save Health Record'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (dailySteps != null && weight != null && meals != null) {
        await Provider.of<HealthRecordsProvider>(context, listen: false)
            .addRecord(dailySteps!, weight!, meals!);

        Fluttertoast.showToast(
          msg: 'Data saved successfully',
          gravity: ToastGravity.TOP,
        );

        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: 'Please enter valid values',
          gravity: ToastGravity.TOP,
        );
      }
    }
  }
}
