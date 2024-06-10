import 'dart:async';
// import 'package:project_tugas_akhir_copy/routes.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/models/status_model.dart';
import 'package:project_tugas_akhir_copy/services/status_service.dart';

class StatusScreen extends StatefulWidget {
  static const nameRoute = '/dashboard';

  const StatusScreen(String b, {super.key});
  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  late Timer timer;
  StreamController<List<DashStatusModel>> streamStatusDash =
      StreamController.broadcast();
  List<DashStatusModel> status = [];
  GetStatusDash statusState = GetStatusDash();
  Future<void> getStatus() async {
    status = await GetStatusDash.fetchStatusData();
    streamStatusDash.add(status);
  }

  // @override
  @override
  void initState() {
    // plantState();
    // OEEData();
    // avaiState();
    // qualityData();
    // getValidUser();
    // _loadData();
    getStatus();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // _loadData();
      getStatus();
      // plantState();
      // OEEData();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Monitor'),
      ),
      body: StreamBuilder<List<DashStatusModel>>(
        stream: streamStatusDash.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<DashStatusModel> statusList = snapshot.data!;
            return ListView.builder(
              itemCount: statusList.length,
              itemBuilder: (context, index) {
                DashStatusModel status = statusList[index];
                return ListTile(
                  title: Text('Status: ${status.status}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
