import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportHistoryPage extends StatefulWidget {
  final String userEmail;

  const ReportHistoryPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ReportHistoryPageState createState() => _ReportHistoryPageState();
}

class _ReportHistoryPageState extends State<ReportHistoryPage> {
  List<dynamic> reports = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    // Replace with emulator or your real IP
    final url = Uri.parse('http://192.168.56.1/redspartan_api/report_history.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userEmail': widget.userEmail}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            reports = data['reports'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Unknown error';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch reports: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report History'),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : reports.isEmpty
                  ? const Center(child: Text('No reports found.'))
                  : ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return Card(
                          margin: const EdgeInsets.all(12),
                          child: ListTile(
                            leading: const Icon(Icons.history, color: Colors.redAccent),
                            title: Text(report['TableName'] ?? 'No Table'),
                            subtitle: Text('Submitted at: ${report['SubmittedAt']}\nBatch ID: ${report['BatchId']}'),
                          ),
                        );
                      },
                    ),
    );
  }
}
