// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/services/user_service.dart';
// import 'package:project_tugas_akhir_copy/drawer.dart';
import 'package:project_tugas_akhir_copy/models/user_model.dart';
import 'package:project_tugas_akhir_copy/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'constant.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Akun extends StatefulWidget {
  static const nameRoute = '/akun';

  const Akun(String g, {super.key});

  @override
  State<Akun> createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      home: Myakun(),
    );
  }
}

class Myakun extends StatefulWidget {
  const Myakun({super.key});

  @override
  State<Myakun> createState() => _MyakunState();
}

class _MyakunState extends State<Myakun> {
  final pdf = pw.Document();

  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController nohp = TextEditingController();
  // List Otoritas
  final List<String> otoritas = <String>[
    "Admin (Disabled)",
    "User-Management",
    "User-Maintenance",
    "User-Production",
  ];
  late String? otoValue;
  // LIST USER
  List<userModel> userList = [];
  AllUserGet alluser = AllUserGet();

  Future<void> connectAPIGetAll() async {
    setState(() {
      userList.clear();
    });
    userList = await alluser.connectAPIGetAll();
    return await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    connectAPIGetAll();
    super.initState();
  }

  bool sort = true;
  @override
  Widget build(BuildContext context) {
    // UNTUK LEBAR TAMPILAN
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;
    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return Scaffold(
      extendBodyBehindAppBar: true,
      //APPBAR----------------------------------------------------------------------------------------------------------------
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        toolbarHeight: blockVertical * 6,
        shadowColor: Colors.transparent,
        title: Text(
          "Manage Accounts",
          style: TextStyle(
              fontSize: blockVertical * 3,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 49, 65).withOpacity(0.5),
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     onPressed: () {
        //       Scaffold.of(context).openDrawer();
        //     },
        //     icon: Icon(
        //       FontAwesomeIcons.bars,
        //       size: blockVertical * 3,
        //     ),
        //   ),
        // ),
        actions: [
          IconButton(
              onPressed: () {
                getPDF();
              },
              icon: Icon(FontAwesomeIcons.filePdf)),
        ],
      ),
      // drawer: TheDrawer(mode: "Account"),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 5, 180, 238),
                Color.fromARGB(255, 1, 37, 53),
              ]),
        ),
        child: LiquidPullToRefresh(
          onRefresh: connectAPIGetAll,
          color: Color.fromARGB(255, 3, 76, 136),
          backgroundColor: Color.fromARGB(255, 5, 180, 238),
          animSpeedFactor: 3,
          showChildOpacityTransition: true,
          height: blockVertical * 30,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(blockHorizontal * 2,
                    blockVertical * 2, blockHorizontal * 2, blockVertical * 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: blockVertical * 70,
                    width: MediaQuerywidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FutureBuilder(
                          future: AllUserGet().connectAPIGetAll(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
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
                            } else {
                              if (snapshot.hasData) {
                                return DataTable(
                                  sortColumnIndex: 0,
                                  sortAscending: sort,
                                  border: TableBorder(
                                    verticalInside: BorderSide(
                                      width: 3,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                    horizontalInside: BorderSide(
                                      width: 3,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ),
                                  ////HEADER TABLE------------------------------------------------------------------------------------------------------------
                                  columns: [
                                    DataColumn(
                                      onSort: ((ColumnIndex, ascending) {
                                        setState(() {
                                          sort = !sort;
                                        });
                                        onSortUserName(ColumnIndex, ascending);
                                      }),
                                      label: Text(
                                        "Username",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: blockVertical * 2),
                                      ),
                                    ),
                                    DataColumn(
                                        label: Text(
                                      "Name",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Authority",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Number Phone",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Actions",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                  ],
                                  //BODY TABLE----------------------------------------------------------------------------------------------------------------
                                  rows: userList.map((e) {
                                    return DataRow(cells: [
                                      DataCell(SelectableText(
                                        "${e.username}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: blockVertical * 2),
                                      )),
                                      DataCell(SelectableText("${e.name}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: blockVertical * 2))),
                                      DataCell(SelectableText("${e.otoritas}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: blockVertical * 2))),
                                      DataCell(SelectableText("${e.noHp}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: blockVertical * 2))),
                                      DataCell(Row(
                                        children: [
                                          // Update User-------------------------------------------------------------------------------
                                          (e.otoritas != "Admin")
                                              ? IconButton(
                                                  onPressed: () {
                                                    AwesomeDialog(
                                                            context: context,
                                                            dialogType:
                                                                DialogType
                                                                    .infoReverse,
                                                            animType: AnimType
                                                                .leftSlide,
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
                                                                        "Update Data "),
                                                                    Text(
                                                                      "${e.name} ?",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                formField(
                                                                    context,
                                                                    "Username",
                                                                    username,
                                                                    TextInputType
                                                                        .text),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                formField(
                                                                    context,
                                                                    "Name",
                                                                    name,
                                                                    TextInputType
                                                                        .text),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                formField(
                                                                    context,
                                                                    "Number Phone (62)",
                                                                    nohp,
                                                                    TextInputType
                                                                        .text),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  padding: EdgeInsets.only(
                                                                      left:
                                                                          blockHorizontal *
                                                                              5),
                                                                  height:
                                                                      blockVertical *
                                                                          7.0,
                                                                  width:
                                                                      MediaQuerywidth,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                            .grey[
                                                                        200],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            blockVertical *
                                                                                5),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            blockVertical *
                                                                                0.1,
                                                                        horizontal:
                                                                            blockHorizontal *
                                                                                1),
                                                                    child: DropdownSearch<
                                                                        String>(
                                                                      clearButtonProps:
                                                                          ClearButtonProps(
                                                                        isVisible:
                                                                            true,
                                                                      ),
                                                                      popupProps:
                                                                          PopupProps
                                                                              .menu(
                                                                        constraints:
                                                                            BoxConstraints(
                                                                          maxHeight:
                                                                              blockVertical * 30,
                                                                        ),
                                                                        showSelectedItems:
                                                                            true,
                                                                        disabledItemFn:
                                                                            (String s) =>
                                                                                s.startsWith('A'),
                                                                      ),
                                                                      items:
                                                                          otoritas,
                                                                      dropdownDecoratorProps:
                                                                          DropDownDecoratorProps(
                                                                        dropdownSearchDecoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              InputBorder.none,
                                                                          labelText:
                                                                              "Choose Authority",
                                                                          hintText:
                                                                              "Authority",
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          otoValue =
                                                                              value;
                                                                        });
                                                                        print(
                                                                            otoValue);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            useRootNavigator:
                                                                true,
                                                            btnOkIcon:
                                                                FontAwesomeIcons
                                                                    .upload,
                                                            btnOkText: "Update",
                                                            btnOkOnPress: () {
                                                              HttpUserPut.connectAPIPut(
                                                                  e.id
                                                                      .toString(),
                                                                  username.text,
                                                                  name.text,
                                                                  otoValue
                                                                      .toString(),
                                                                  nohp.text);
                                                            },
                                                            btnCancelText:
                                                                "Cancel",
                                                            btnCancelIcon:
                                                                FontAwesomeIcons
                                                                    .ban,
                                                            btnCancelOnPress:
                                                                () {})
                                                        .show();
                                                  },
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.amber,
                                                  ))
                                              : SizedBox(),
                                          // Delete User------------------------------------------------------------------------------
                                          (e.otoritas != "Admin")
                                              ? IconButton(
                                                  onPressed: () {
                                                    AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.question,
                                                      animType:
                                                          AnimType.leftSlide,
                                                      body: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              "Are You Sure You Want to Delete "),
                                                          Text(
                                                            "${e.name} ?",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      useRootNavigator: true,
                                                      btnOkText: "Delete",
                                                      btnOkIcon:
                                                          FontAwesomeIcons
                                                              .trash,
                                                      btnOkOnPress: () {
                                                        HttpUserDelete
                                                                .connectAPIDelete(
                                                                    "${e.id}")
                                                            .then((value) =>
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    myakun,
                                                                    arguments:
                                                                        "berhasil hapus"));
                                                      },
                                                      btnCancelIcon:
                                                          FontAwesomeIcons.ban,
                                                      btnCancelOnPress: () {},
                                                    ).show();
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 0.1,
                                                ),
                                        ],
                                      ))
                                    ]);
                                  }).toList(),
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                            }
                            return Center(
                              child: Text("No DATA"),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 1, 201, 201),
        onPressed: () {
          Navigator.pushNamed(context, mytambahuser, arguments: 'from akun');
        },
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  onSortUserName(int ColumnIndex, bool ascending) {
    if (ColumnIndex == 0) {
      if (ascending) {
        userList.sort((a, b) => a.username!.compareTo(b.username!));
      } else if (ascending == false) {
        userList.sort((a, b) => b.username!.compareTo(a.username!));
      }
    }
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

  //----------------------------------MEMBUAT PAGE PDF------------------------------------//
  void getPDF() async {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
                child: pw.Text(
                    "PRODUCTION MONITORING SYSTEM APPLICATION USER ACCOUNT DATA",
                    softWrap: true,
                    style: pw.TextStyle(fontBold: pw.Font.courierBold()))),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
                headers: ['Username', 'Name', 'Authority', 'Number Phone'],
                data: userList
                    .map((e) => [e.username, e.name, e.otoritas, e.noHp])
                    .toList())
          ];
        },
      ),
    ); // Page
    // SIMPAN
    Uint8List bytes = await pdf.save();

    // buat file kosong di directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Daftar_User.pdf');
    print(dir);
    // timpa file kosong dengan file pdf
    await file.writeAsBytes(bytes);

    //open pdf
    await OpenFile.open(file.path);
  }
}
