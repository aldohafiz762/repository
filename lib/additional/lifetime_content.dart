import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/models/lifetime_model.dart';
import 'package:project_tugas_akhir_copy/services/lifetime_service.dart';
import 'package:shimmer/shimmer.dart';

class DataFetcher {
  final int componentId;
  final StreamController<List<LifetimeModel>> streamController =
      StreamController.broadcast();
  late Timer timer;
  List<LifetimeModel> ltList = [];
  final GetOneLT getLatestLT = GetOneLT();

  DataFetcher(this.componentId);

  Future<void> fetchData() async {
    try {
      ltList = await getLatestLT.getOne(componentId);
      streamController.add(ltList);
    } catch (e) {
      streamController.addError(e);
    }
  }

  void startFetching() {
    fetchData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchData();
    });
  }

  void stopFetching() {
    if (timer.isActive) timer.cancel();
  }
}

class DataDisplayWidget extends StatefulWidget {
  final DataFetcher dataFetcher;
  final String title;

  DataDisplayWidget({required this.dataFetcher, required this.title});

  @override
  _DataDisplayWidgetState createState() => _DataDisplayWidgetState();
}

class _DataDisplayWidgetState extends State<DataDisplayWidget> {
  @override
  void initState() {
    widget.dataFetcher.startFetching();
    super.initState();
  }

  @override
  void dispose() {
    widget.dataFetcher.stopFetching();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;

    return StreamBuilder<List<LifetimeModel>>(
      stream: widget.dataFetcher.streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child: Text(
                'Loading',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: blockVertical * 5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          List<LifetimeModel> ltList = snapshot.data!;
          return Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: ltList.map((e) {
                  String toDateTime(int value) {
                    final duration = Duration(seconds: value);
                    final hours = duration.inHours;
                    final minutes = duration.inMinutes.remainder(60);
                    final seconds = duration.inSeconds.remainder(60);
                    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                  }

                  return Column(
                    children: [
                      Text(
                        "Timevalue: ${toDateTime(e.timevalue)}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: blockVertical * 2.5),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Reset'),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        } else {
          return Center(child: Text("No data available"));
        }
      },
    );
  }
}

class GetCylinderLT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataFetcher = DataFetcher(1); // Component ID untuk GetCylinderLT

    return Scaffold(
      appBar: AppBar(
        title: Text("Get Cylinder LT"),
      ),
      body: DataDisplayWidget(
        dataFetcher: dataFetcher,
        title: "Cylinder Lifetime",
      ),
    );
  }
}

class GetCVLT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataFetcher = DataFetcher(2); // Component ID untuk GetCVLT

    return Scaffold(
      body: DataDisplayWidget(
        dataFetcher: dataFetcher,
        title: "CV Lifetime",
      ),
    );
  }
}
