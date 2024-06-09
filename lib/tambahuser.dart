import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
import 'package:project_tugas_akhir_copy/services/user_service.dart';
import 'package:project_tugas_akhir_copy/constant.dart';
import 'package:project_tugas_akhir_copy/routes.dart';

class Tambahuser extends StatefulWidget {
  const Tambahuser(String as, {super.key});

  @override
  State<Tambahuser> createState() => _TambahuserState();
}

class _TambahuserState extends State<Tambahuser> {
  // Input Textfield Controller
  TextEditingController username = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController oto = TextEditingController();
  TextEditingController nohp = TextEditingController();

  //HTTP METHOD
  HttpUserPost dataResponse = HttpUserPost();

  // List Otoritas
  final List<String> otoritas = <String>[
    "Admin (Disabled)",
    "User-Management",
    "User-Maintenance",
    "User-Production",
    "User-Operator",
  ];
  late String? otoValue;
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
      home: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 5, 180, 238),
                  Color.fromARGB(255, 0, 163, 233),
                ]),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                Container(
                  height: blockVertical * 30,
                  width: MediaQuerywidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/asset14.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: blockVertical * 25),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    height: blockVertical * 75,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(blockVertical * 4),
                          topRight: Radius.circular(blockVertical * 4)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            backbutton(context),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: blockVertical * 2),
                              child: Text(
                                "     Add User",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: blockVertical * 1,
                              horizontal: blockHorizontal * 2),
                          child: Text(
                            "Username",
                          ),
                        ),
                        formField(context, "Input Username", username,
                            TextInputType.text),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: blockVertical * 1,
                              horizontal: blockHorizontal * 2),
                          child: Text(
                            "Password",
                          ),
                        ),
                        formField(context, "Input Password", pass,
                            TextInputType.text),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: blockVertical * 1,
                              horizontal: blockHorizontal * 2),
                          child: Text(
                            "Name",
                          ),
                        ),
                        formField(
                            context, "Input Name", name, TextInputType.text),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: blockVertical * 1,
                              horizontal: blockHorizontal * 2),
                          child: Text(
                            "Number Phone (62)",
                          ),
                        ),
                        formField(context, "Input Number Phone (62)", nohp,
                            TextInputType.number),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: blockVertical * 1,
                              horizontal: blockHorizontal * 2),
                          child: Text(
                            "Otoritas",
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: blockHorizontal * 5),
                          height: blockVertical * 7.0,
                          width: MediaQuerywidth,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.circular(blockVertical * 5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: blockVertical * 0.1,
                                horizontal: blockHorizontal * 1),
                            child: DropdownSearch<String>(
                              clearButtonProps: ClearButtonProps(
                                isVisible: true,
                              ),
                              popupProps: PopupProps.bottomSheet(
                                constraints: BoxConstraints(
                                    maxHeight: blockVertical * 30),
                                showSelectedItems: true,
                                disabledItemFn: (String s) => s.startsWith('A'),
                              ),
                              items: otoritas,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Choose Authority",
                                  hintText: "Authority",
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  otoValue = value;
                                });
                                print(otoValue);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        //BUTTON ADD USER----------------------------------------------------------------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: MediaQueryheight * 0.06,
                                width: MediaQuerywidth * 0.95,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          Color.fromARGB(212, 4, 20, 245),
                                          Color.fromARGB(235, 4, 143, 236)
                                        ])),
                                child: Material(
                                  type: MaterialType.canvas,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    splashColor:
                                        Color.fromARGB(19, 3, 191, 233),
                                    radius: 100,
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      if (username.text.isNotEmpty &&
                                          pass.text.isNotEmpty &&
                                          name.text.isNotEmpty &&
                                          nohp.text.isNotEmpty &&
                                          otoValue!.isNotEmpty) {
                                        HttpUserPost.connectAPIPost(
                                            username.text,
                                            pass.text,
                                            name.text,
                                            otoValue.toString(),
                                            nohp.text);
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.leftSlide,
                                          headerAnimationLoop: false,
                                          dialogType: DialogType.success,
                                          showCloseIcon: false,
                                          title: 'Succes',
                                          desc: 'Success Add User',
                                          btnOkOnPress: () {
                                            Navigator.pushNamed(context, myakun,
                                                arguments: "Success Add User");
                                          },
                                          dismissOnTouchOutside: false,
                                          autoHide: Duration(seconds: 3),
                                          btnOkIcon: Icons.check_circle,
                                          onDismissCallback: (type) {
                                            Navigator.pushNamed(context, myakun,
                                                arguments: "Success Add User");
                                          },
                                        ).show();
                                        ;
                                      } else {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.leftSlide,
                                          title: "Form Empty",
                                          desc: "Form Can't Be Empty",
                                          autoHide: Duration(seconds: 2),
                                        ).show();
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        "Add User",
                                        style: TextStyle(
                                            fontSize: MediaQueryheight * 0.028,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
