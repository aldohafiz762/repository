// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/services/troubleshoot_service.dart';
import 'package:project_tugas_akhir_copy/services/user_service.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
import 'package:project_tugas_akhir_copy/constant.dart';
import 'package:project_tugas_akhir_copy/models/troubleshoot_model.dart';
import 'package:project_tugas_akhir_copy/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class M1alarm extends StatefulWidget {
  static const nameRoute = '/m1alarm';

  const M1alarm(String j, {super.key});

  @override
  State<M1alarm> createState() => _M1alarmState();
}

class _M1alarmState extends State<M1alarm> {
  late Timer timer;
  final ScrollController _controller = ScrollController();
  final TextEditingController messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> mesin = <String>[
    "Machine 1",
  ];

  String? name, otoritas, mesinValue, worker;
  Future<void> getValidUser() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getName = shared.getString("name");
    var getOtoritas = shared.getString("otoritas");
    setState(() {
      name = getName!;
      otoritas = getOtoritas!;
    });
  }

  List<String> userMTDP = [];
  AllUserGet userMT = AllUserGet();
  Future<void> userMTData() async {
    userMTDP = await userMT.getuserMT();
  }

  StreamController streamOrder = StreamController.broadcast();
  List<GetTB> listOrder = [];
  GetData orderList = GetData();
  Future<void> orderData() async {
    listOrder = await orderList.getRecTB(1);
    streamOrder.add(listOrder);
  }

  void clearMessage() {
    messageController.clear();
  }

  @override
  void initState() {
    orderData();
    userMTData();
    getValidUser();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      orderData();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;

    return MaterialApp(
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Machine 1 Troubleshoot",
            style: TextStyle(fontSize: blockVertical * 2.5),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 6, 160, 207),
          toolbarHeight: blockVertical * 8,
          leading: backbutton(context),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, myhistoriTB, arguments: "hi");
                },
                icon: Icon(
                  FontAwesomeIcons.clockRotateLeft,
                  size: blockVertical * 2.5,
                ))
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top: blockVertical * 2),
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 29, 206, 215),
                  Color.fromARGB(255, 19, 78, 227),
                ]),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(blockVertical * 1),
                  margin: EdgeInsets.symmetric(horizontal: blockHorizontal * 2),
                  height: blockVertical * 40,
                  width: MediaQuerywidth,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(blockVertical * 1)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "List Orders",
                            style: TextStyle(
                                fontSize: blockVertical * 2.5,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "*If empty no order available",
                            style: TextStyle(
                                fontSize: blockVertical * 1.5,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: blockVertical * 0.2,
                      ),
                      Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        height: blockVertical * 32.5,
                        child: StreamBuilder(
                            stream: streamOrder.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView(
                                    controller: _controller,
                                    children: listOrder.map((e) {
                                      int id = e.idorder!;
                                      if (e.solved == false) {
                                        return listOrders(
                                            blockHorizontal,
                                            blockVertical,
                                            "${e.from} (${e.otoritas})",
                                            "${e.to} (Maintenance)",
                                            "${e.keterangan}",
                                            "${e.message}",
                                            id);
                                      }
                                      return Center();
                                    }).toList());
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                              }
                              return Center(
                                child: Text(
                                  "No Order",
                                  style: TextStyle(
                                      fontSize: blockVertical * 4,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: blockVertical * 1),
                  padding: EdgeInsets.all(blockVertical * 1),
                  height: blockVertical * 46,
                  width: MediaQuerywidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(blockVertical * 1),
                      topRight: Radius.circular(blockVertical * 1),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Form Order",
                        style: TextStyle(
                            fontSize: blockVertical * 2.5,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        thickness: blockVertical * 0.2,
                      ),
                      DPMachine(blockHorizontal, blockVertical),
                      SizedBox(
                        height: blockVertical * 1,
                      ),
                      DPWorker(blockHorizontal, blockVertical),
                      SizedBox(
                        height: blockVertical * 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Message : ",
                            style: TextStyle(
                              fontSize: blockVertical * 2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              clearMessage();
                            },
                            child: Text(
                              "Clear ",
                              style: TextStyle(
                                fontSize: blockVertical * 2,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: blockVertical * 0.5),
                        padding: EdgeInsets.all(blockVertical * 0.5),
                        height: blockVertical * 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(blockVertical * 1),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5)),
                        ),
                        child: TextField(
                          readOnly:
                              (otoritas != "User-Maintenance") ? false : true,
                          keyboardType: TextInputType.name,
                          controller: messageController,
                          focusNode: _focusNode,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: "Write your message...",
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: blockVertical * 1,
                      ),
                      (otoritas != "User-Maintenance" ||
                              otoritas != "User-Management")
                          ? buttonInput(
                              MediaQueryheight,
                              MediaQuerywidth,
                              blockHorizontal,
                              blockVertical,
                              1,
                              name.toString(),
                              worker.toString(),
                              otoritas.toString(),
                              messageController.text)
                          : buttonInputDis(MediaQueryheight, MediaQuerywidth,
                              blockHorizontal, blockVertical)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listOrders(
    double blockHorizontal,
    double blockVertical,
    String from,
    String to,
    String status,
    String message,
    int idorder,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: blockVertical * 1),
      padding: EdgeInsets.symmetric(
          vertical: blockVertical * 0.1, horizontal: blockVertical * 1),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 243, 243),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(blockVertical * 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.gears,
                size: blockVertical * 2,
              ),
              Text(
                "    Maintenance Order    ",
                style: TextStyle(
                    fontSize: blockVertical * 2.5, fontWeight: FontWeight.bold),
              ),
              Icon(
                FontAwesomeIcons.gears,
                size: blockVertical * 2,
              ),
            ],
          ),
          Divider(thickness: blockVertical * 0.1),
          Text(
            "From : $from",
            style: TextStyle(fontSize: blockVertical * 2),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "To : $to",
            style: TextStyle(fontSize: blockVertical * 2),
          ),
          Text(
            "Status : $status",
            style: TextStyle(fontSize: blockVertical * 2),
          ),
          Text(
            "Message : ",
            style: TextStyle(fontSize: blockVertical * 2),
          ),
          Container(
            padding: EdgeInsets.all(blockVertical * 0.5),
            height: blockVertical * 9,
            width: blockHorizontal * 85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(blockVertical * 1),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
            child: SelectableText(
              message,
              showCursor: true,
              style: TextStyle(fontSize: blockVertical * 2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 0, 255, 8),
                    radius: blockVertical * 1.5,
                    child: Icon(
                      FontAwesomeIcons.rotate,
                      color: Colors.white,
                      size: blockVertical * 1.5,
                    ),
                  ),
                  Text(
                    " Id Order : $idorder",
                    style: TextStyle(fontSize: blockVertical * 2),
                  ),
                ],
              ),
              (otoritas == "Admin" || otoritas == "User-Maintenance")
                  ? ElevatedButton(
                      onPressed: () {
                        UpdateData.updateTB(
                            1, idorder, "Solved", true, "$name");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            FontAwesomeIcons.check,
                            size: blockVertical * 2,
                            color: Colors.white,
                          ),
                          Text(
                            "  Solve",
                            style: TextStyle(
                                fontSize: blockVertical * 2,
                                color: Colors.white),
                          )
                        ],
                      ),
                    )
                  : SizedBox(
                      height: blockVertical * 5,
                    )
            ],
          )
        ],
      ),
    );
  }

  Widget buttonInput(
      double MediaQueryheight,
      double MediaQuerywidth,
      double blockHorizontal,
      double blockVertical,
      int machine_id,
      String from,
      String To,
      String otoritas,
      String message) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: blockHorizontal * 2, vertical: blockVertical * 1),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuerywidth,
          height: MediaQueryheight * 0.05,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(210, 10, 83, 179),
                    Color.fromARGB(235, 2, 139, 146)
                  ])),
          child: Material(
            type: MaterialType.canvas,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              splashColor: Color.fromARGB(19, 3, 191, 233),
              radius: 100,
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if (worker != null && messageController.text.isNotEmpty) {
                  PostData.sendMessage(1, To, message, from);
                  PostData.trigTB(machine_id, from, otoritas, To, message)
                      .then((value) {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            btnOkOnPress: () {},
                            useRootNavigator: true,
                            title: "Success Order")
                        .show();
                  });
                } else {
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          btnOkOnPress: () {},
                          useRootNavigator: true,
                          title: "Order Can't Be Empty")
                      .show();
                }
              },
              child: Center(
                child: Text(
                  "SUBMIT",
                  style: TextStyle(
                      fontSize: MediaQueryheight * 0.02,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonInputDis(double MediaQueryheight, double MediaQuerywidth,
      double blockHorizontal, double blockVertical) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: blockHorizontal * 2, vertical: blockVertical * 1),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuerywidth,
          height: MediaQueryheight * 0.05,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(210, 165, 165, 165),
                    Color.fromARGB(235, 102, 102, 102)
                  ])),
          child: Center(
            child: Text(
              "SUBMIT",
              style: TextStyle(
                  fontSize: MediaQueryheight * 0.02,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget DPMachine(double blockHorizontal, double blockVertical) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: blockHorizontal * 5),
      height: blockVertical * 7,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 236, 236, 236),
        borderRadius: BorderRadius.circular(blockVertical * 1),
        border: Border.all(
          color: (mesinValue == null)
              ? Color.fromARGB(255, 224, 224, 224)
              : Color.fromARGB(255, 24, 142, 238),
        ),
      ),
      child: DropdownSearch<String>(
        enabled: (otoritas != "User-Maintenance") ? true : false,
        clearButtonProps: ClearButtonProps(
          isVisible: true,
        ),
        popupProps: PopupProps.menu(
          constraints: BoxConstraints(maxHeight: blockVertical * 7.5),
          showSelectedItems: true,
        ),
        items: mesin,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            border: InputBorder.none,
            labelText: "Choose Machine",
            hintText: "Machine",
          ),
        ),
        onChanged: (value) {
          setState(() {
            mesinValue = value;
          });
          print(mesinValue);
        },
      ),
    );
  }

  Widget DPWorker(double blockHorizontal, double blockVertical) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: blockHorizontal * 5),
      height: blockVertical * 7,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 236, 236, 236),
        borderRadius: BorderRadius.circular(blockVertical * 1),
        border: Border.all(
          color: (worker == null)
              ? Color.fromARGB(255, 224, 224, 224)
              : Color.fromARGB(255, 24, 142, 238),
        ),
      ),
      child: DropdownSearch<String>(
        enabled: (mesinValue != null) ? true : false,
        clearButtonProps: ClearButtonProps(
          isVisible: true,
        ),
        popupProps: PopupProps.menu(
          constraints: BoxConstraints(maxHeight: blockVertical * 20),
          showSelectedItems: true,
        ),
        items: userMTDP,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            border: InputBorder.none,
            labelText: "Choose Worker (Maintenance)",
            hintText: "Worker",
          ),
        ),
        onChanged: (value) {
          setState(() {
            worker = value;
          });
          print(worker);
        },
      ),
    );
  }
}
