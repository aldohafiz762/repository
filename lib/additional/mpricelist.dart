import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/models/costprice_model.dart';
import 'package:project_tugas_akhir_copy/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/costprice_service.dart';

class M1pricelist extends StatefulWidget {
  static const nameRoute = '/m1price';
  const M1pricelist({super.key});

  @override
  State<M1pricelist> createState() => _M1pricelistState();
}

class _M1pricelistState extends State<M1pricelist> {
  TextEditingController Material1 = TextEditingController();
  TextEditingController Material2 = TextEditingController();
  TextEditingController Material3 = TextEditingController();
  bool editMode = false;
  String editType = "A";
  late Timer timer;
  StreamController streamPrice = StreamController.broadcast();
  List<GetPriceModel> priceList = [];
  GetPrice getPriceLIST = GetPrice();
  Future<void> priceData() async {
    priceList = await getPriceLIST.getPriceList();
    streamPrice.add(priceList);
  }

  String? name, otoritas;
  Future<void> getValidUser() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getName = shared.getString("name");
    var getOtoritas = shared.getString("otoritas");
    setState(() {
      name = getName!;
      otoritas = getOtoritas!;
    });
  }

  @override
  void initState() {
    getValidUser();
    priceData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      priceData();
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
    // UNTUK LEBAR TAMPILAN
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      home: Padding(
        padding: EdgeInsets.symmetric(
            vertical: blockVertical * 1.5, horizontal: blockHorizontal * 2),
        child: StreamBuilder(
          stream: streamPrice.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: priceList.map((e) {
                    return Card(
                      color: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(blockVertical * 1))),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: blockVertical * 1,
                            horizontal: blockHorizontal * 2),
                        height: blockVertical * 40,
                        width: MediaQuerywidth,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Type ${e.tipe}",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 65, 60, 60),
                                          fontSize: constraints.maxHeight * 0.1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    (otoritas == "Admin" ||
                                            otoritas == "User-Management")
                                        ? IconButton(
                                            onPressed: () {
                                              AwesomeDialog(
                                                      context: context,
                                                      dialogType: DialogType
                                                          .infoReverse,
                                                      animType:
                                                          AnimType.leftSlide,
                                                      body: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  "Update Harga Material "),
                                                              Text(
                                                                "${e.tipe} ?",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          formField(
                                                              context,
                                                              "Material ${e.tipe}1",
                                                              Material1,
                                                              TextInputType
                                                                  .number),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          formField(
                                                              context,
                                                              "Material ${e.tipe}2",
                                                              Material2,
                                                              TextInputType
                                                                  .number),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          formField(
                                                              context,
                                                              "Material ${e.tipe}3",
                                                              Material3,
                                                              TextInputType
                                                                  .number),
                                                          SizedBox(
                                                            height: 5,
                                                          )
                                                        ],
                                                      ),
                                                      useRootNavigator: true,
                                                      btnOkIcon:
                                                          FontAwesomeIcons
                                                              .upload,
                                                      btnOkText: "Update",
                                                      btnOkOnPress: () {
                                                        UpdateHarga.newHarga(
                                                          e.tipe.toString(),
                                                          int.parse(
                                                              Material1.text),
                                                          int.parse(
                                                              Material2.text),
                                                          int.parse(
                                                              Material3.text),
                                                        );
                                                      },
                                                      btnCancelText: "Cancel",
                                                      btnCancelIcon:
                                                          FontAwesomeIcons.ban,
                                                      btnCancelOnPress: () {})
                                                  .show();
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.penToSquare,
                                              size: constraints.maxHeight * 0.1,
                                              color: Color.fromARGB(
                                                  255, 65, 60, 60),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                                Divider(
                                  thickness: constraints.maxHeight * 0.01,
                                ),
                                Text(
                                  "Raw Material :",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 65, 60, 60),
                                      fontSize: constraints.maxHeight * 0.07,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: constraints.maxHeight * 0.03,
                                      horizontal: constraints.maxWidth * 0.03),
                                  height: constraints.maxHeight * 0.5,
                                  width: constraints.maxWidth,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 173, 173, 173)
                                                .withOpacity(0.5),
                                            Color.fromARGB(255, 121, 121, 121)
                                                .withOpacity(0.5)
                                          ],
                                          end: Alignment.topLeft,
                                          begin: Alignment.bottomRight),
                                      borderRadius: BorderRadius.circular(
                                          constraints.maxHeight * 0.05)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Material ${e.Nbaku1} : ",
                                            style: TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.07,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 65, 60, 60)),
                                          ),
                                          Text(
                                            "Rp. ${e.Pbaku1},-",
                                            style: TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.07,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 65, 60, 60)),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Material ${e.Nbaku2} : ",
                                            style: TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.07,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 65, 60, 60)),
                                          ),
                                          Text(
                                            "Rp. ${e.Pbaku2},-",
                                            style: TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.07,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 65, 60, 60)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Material ${e.Nbaku3} : ",
                                            style: TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.07,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 65, 60, 60)),
                                          ),
                                          Text(
                                            "Rp. ${e.Pbaku3},-",
                                            style: TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.07,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 65, 60, 60)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.01,
                                ),
                                Divider(
                                  thickness: constraints.maxHeight * 0.01,
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Price : ",
                                      style: TextStyle(
                                        fontSize: constraints.maxHeight * 0.08,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 65, 60, 60),
                                      ),
                                    ),
                                    Text(
                                      "Rp. ${e.Ptotal},-",
                                      style: TextStyle(
                                        fontSize: constraints.maxHeight * 0.08,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 65, 60, 60),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
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
            }
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
          },
        ),
      ),
    );
  }

  Widget formField(BuildContext context, String hint,
      TextEditingController controller, TextInputType inputType) {
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return Container(
      padding: EdgeInsets.only(left: blockHorizontal * 5),
      height: blockVertical * 7,
      width: MediaQuerywidth,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(blockVertical * 5),
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        autocorrect: false,
        keyboardType: inputType,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}
