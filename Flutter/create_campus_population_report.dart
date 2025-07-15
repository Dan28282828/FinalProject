import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateCampusPopulationReport extends StatefulWidget {
  final String userEmail;
  final String userOffice;

  const CreateCampusPopulationReport({
    super.key,
    required this.userEmail,
    required this.userOffice,
  });

  @override
  State<CreateCampusPopulationReport> createState() =>
      _CreateCampusPopulationReportState();
}

class _CreateCampusPopulationReportState
    extends State<CreateCampusPopulationReport> {
  final Map<String, List<String>> reportFieldsByType = {
    'Campus Population': [
      'Campus',
      'Year',
      'NumStudents',
      'NumISStudents',
      'NumEmployees',
      'NumCanteenPersonnel',
      'NumConstructionPersonnel',
      'Total',
    ],
    'Food Waste': [
      'Campus',
      'DateGenerated',
      'Category',
      'WeightInKg',
      'Remarks',
    ],
  };

  late String selectedReport;
  List<Map<String, TextEditingController>> _formEntries = [];

  @override
  void initState() {
    super.initState();
    selectedReport = reportFieldsByType.keys.first;
    _addFormEntry();
  }

  void _addFormEntry() {
    final controllers = <String, TextEditingController>{};
    for (var field in reportFieldsByType[selectedReport]!) {
      controllers[field] = TextEditingController();
    }

    if (selectedReport == 'Campus Population') {
      for (var field in [
        'NumStudents',
        'NumISStudents',
        'NumEmployees',
        'NumCanteenPersonnel',
        'NumConstructionPersonnel',
      ]) {
        controllers[field]!.addListener(() => _calculateTotal(controllers));
      }
    }

    setState(() {
      _formEntries.add(controllers);
    });
  }

  void _calculateTotal(Map<String, TextEditingController> entry) {
    int total = 0;
    for (var field in [
      'NumStudents',
      'NumISStudents',
      'NumEmployees',
      'NumCanteenPersonnel',
      'NumConstructionPersonnel',
    ]) {
      total += int.tryParse(entry[field]?.text ?? '') ?? 0;
    }
    entry['Total']!.text = total.toString();
  }

  Future<void> _submitData() async {
    final url = 'http://192.168.56.1/redspartan_api/${_getApiEndpoint()}.php';

    final payload = {
      'CreatedBy': widget.userEmail,
      'rows': _formEntries.map((entry) {
        return {
          for (var field in reportFieldsByType[selectedReport]!)
            field: entry[field]?.text ?? ''
        };
      }).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submitted! Batch ID: ${result['batchId']}')),
        );
        setState(() {
          _formEntries.clear();
          _addFormEntry();
        });
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $e')),
      );
    }
  }

  String _getApiEndpoint() {
    switch (selectedReport) {
      case 'Campus Population':
        return 'campuspopulation';
      case 'Food Waste':
        return 'foodwaste';
      default:
        return 'campuspopulation';
    }
  }

  Future<void> _showConfirmationDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: const Text('Are you sure you want to submit this report?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _submitData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = reportFieldsByType[selectedReport]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Report'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addFormEntry,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              value: selectedReport,
              items: reportFieldsByType.keys.map((report) {
                return DropdownMenuItem<String>(
                  value: report,
                  child: Text(report),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null && value != selectedReport) {
                  setState(() {
                    selectedReport = value;
                    _formEntries.clear();
                    _addFormEntry();
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Select Report Type',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _formEntries.length,
              itemBuilder: (context, index) {
                final row = _formEntries[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: fields.map((field) {
                        final isTotal = field == 'Total';

                        if (field == 'DateGenerated') {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  final formatted =
                                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                  setState(() {
                                    row[field]!.text = formatted;
                                  });
                                }
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: row[field],
                                  decoration: const InputDecoration(
                                    labelText: 'DateGenerated',
                                    suffixIcon: Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextField(
                            controller: row[field],
                            enabled: !isTotal,
                            keyboardType: field.contains('Num') ||
                                    field == 'Year' ||
                                    field == 'WeightInKg'
                                ? TextInputType.number
                                : TextInputType.text,
                            decoration: InputDecoration(
                              labelText: field,
                              filled: isTotal,
                              fillColor: isTotal ? Colors.grey[300] : null,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              onPressed: _showConfirmationDialog,
              icon: const Icon(Icons.send),
              label: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
