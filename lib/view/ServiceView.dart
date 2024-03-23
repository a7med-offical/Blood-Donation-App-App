import 'package:awesome_icons/awesome_icons.dart';
import 'package:bldapp/Provider/ProvidetUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:provider/provider.dart';

import '../Colors.dart';
import '../widget/CustomButton.dart';
import 'DonationView.dart';
import 'LoginView.dart';
import 'SearchView.dart';

class ServiceView extends StatefulWidget {
  const ServiceView({super.key});
  static String id = '4';
  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  List<QueryDocumentSnapshot> dataList = [];
  bool isLoading = true;
  getUserName() async {
    QuerySnapshot response = await FirebaseFirestore.instance
        .collection('user')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    dataList.addAll(response.docs);
    isLoading = false;
    setState(() {});
  }

  bool? serviceEnabled;
  LocationPermission? permission;

  @override
  void initState() {
    getUserName();
    determinePosition();
    super.initState();
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.amber,
    content: Text(
      'Location is required to use app! ',
      style: TextStyle(color: background),
    ),
  );
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {}

    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {}

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);
    return await Geolocator.getCurrentPosition();
  }

  GlobalKey<ScaffoldState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.open_in_new,
          color: background,
        ),
        backgroundColor: Colors.amber[400],
        onPressed: () {
          key.currentState!.openDrawer();
        },
      ),
      drawer: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(80),
            ),
          ),
          backgroundColor: background,
          child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      margin: EdgeInsets.all(0),
                      child: DrawerHeader(
                          padding: EdgeInsets.all(0),
                          curve: Curves.easeInOutCubicEmphasized,
                          // duration: Duration(seconds: 2),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("Assets/Images/1111.jfif"),
                                    fit: BoxFit.cover)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dataList[index]['url'] != null
                                      ? CircleAvatar(
                                          foregroundColor: Colors.transparent,
                                          backgroundColor: Colors.transparent,
                                          radius: 70,
                                          backgroundImage: NetworkImage(
                                            dataList[index]['url'],
                                            scale: 2,
                                          ))
                                      : CircleAvatar(
                                          foregroundColor: background,
                                          backgroundColor: background,
                                          radius: 70,
                                          backgroundImage: NetworkImage(
                                            'https://thumbs.dreamstime.com/b/default-profile-picture-avatar-photo-placeholder-vector-illustration-default-profile-picture-avatar-photo-placeholder-vector-189495158.jpg',
                                            scale: 2,
                                          ),
                                        ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    '${dataList[0]['frist_name']} ${dataList[index]['last_name']}',
                                    style: TextStyle(
                                      color: background,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    dataList[index]['email'],
                                    style: TextStyle(
                                      color: background,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                  CustomListTitle(
                    onpressed: () {
                      Navigator.pushNamed(context, DonationView.id);
                      key.currentState!.closeDrawer();
                    },
                    text: 'Blood Donate',
                    icon: Icons.bloodtype,
                  ),
                  CustomListTitle(
                    text: 'Find blood type',
                    onpressed: () {
                      Navigator.pushNamed(context, SearchView.id);
                      key.currentState!.closeDrawer();
                    },
                    icon: FontAwesomeIcons.search,
                  ),
                  CustomListTitle(
                    onpressed: () async {
                      key.currentState!.closeDrawer();

                      await OpenAppSettings.openAppSettings();
                    },
                    text: 'Permission',
                    icon: Icons.settings_input_antenna_rounded,
                  ),
                  Divider(
                    height: 2,
                    indent: 5,
                    endIndent: 5,
                    thickness: 2,
                    color: background,
                  ),
                  CustomListTitle(
                    text: 'Sign out',
                    onpressed: () {
                      key.currentState!.closeDrawer();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: background,
                            content: Text("Do you want to sign out ?",
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold)),
                            actions: [
                              MaterialButton(
                                  color: Colors.amber[400],
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      LoginView.id,
                                      (route) => false,
                                    );
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: background),
                                  )),
                            ],
                          );
                          // show the dialog ;
                        },
                      );
                      // set up the button
                      // set up the AlertDialog
                    },
                    icon: Icons.output_outlined,
                  ),
                  CustomListTitle(
                    onpressed: () async {
                      key.currentState!.closeDrawer();
                    },
                    text: 'Close',
                    icon: Icons.close,
                  ),
                ],
              );
            },
          )),
      backgroundColor: background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.amber[400]),
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Text(
                                'Hello , ',
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.yellow,
                                    fontSize: 22,
                                    fontFamily: 'Borel-Regular'),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 200,
                              child: ListView.builder(
                                  reverse: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: dataList.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            dataList[index]['frist_name'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            dataList[index]['last_name'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, LoginView.id);
                        },
                        icon: Icon(
                          Icons.logout_outlined,
                          color: Colors.amber[400],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100),
                  Image.asset('Assets/Images/image2.png', height: 200),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Blood Locator Donation',
                    style: TextStyle(
                        color: Colors.amber[400],
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'choose the Service you want',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DonationView(),
                            ));
                      },
                      text: 'Donate blood'),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      text: 'Find blood type',
                      onTap: () {
                        Navigator.pushNamed(context, SearchView.id);
                      }),
                  const SizedBox(
                    height: 70,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  )
                ],
              ),
      ),
    );
  }
}

class CustomListTitle extends StatelessWidget {
  const CustomListTitle({
    super.key,
    required this.text,
    required this.onpressed,
    required this.icon,
  });
  final String? text;
  final VoidCallback onpressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: ListTile(
        title: Text(
          text!,
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
