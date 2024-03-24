import 'package:bldapp/Provider/theme_provider.dart';
import 'package:bldapp/view/SearchView.dart';
import 'package:bldapp/view/hospital_dash_board/views/create_notfication_view.dart';
import 'package:bldapp/view/ocr_view.dart';
import 'package:bldapp/view/register_as_hospital.dart';
import 'package:bldapp/view/updatessss/create_qr_coed.dart';
import 'package:bldapp/view/updatessss/info.dart';
import 'package:bldapp/view/updatessss/inventory_view.dart';
import 'package:bldapp/view/updatessss/remove.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../Colors.dart';
import '../DonationView.dart';
import 'add_blood_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HospitalDashboard extends StatefulWidget {
  final QueryDocumentSnapshot snap;
  HospitalDashboard({super.key, required this.snap});

  @override
  State<HospitalDashboard> createState() => _HospitalDashboardState();
}

class _HospitalDashboardState extends State<HospitalDashboard> {
  final String url =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5GWRHhWN4BMsklL8oXjWMtCQEVMfzM1sub6yDv6hz_uLUSF4WZgCg1XEwakiL-2d6NuQ&usqp=CAU';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  checkUser() {}

  @override
  void initState() {
    super.initState();
  }

  final List<serviceData> list = [
    serviceData('Assets/Images/scan.png', 'Create Qr'),
    serviceData('Assets/Images/search (3).png', 'Search'),
    serviceData('Assets/Images/add (1).png', 'Add '),
    serviceData('Assets/Images/remove.png', 'Remove'),
    serviceData('Assets/Images/check.png', 'Check Donar'),
    serviceData('Assets/Images/info0.png', 'Info'),
  ];

  @override
  Widget build(BuildContext context) {
    var _theme = Provider.of<ThemeProvider>(context, listen: false);

    final List<Widget> pages = [
      CreateQRBloodType(
        hospitalName: widget.snap['name'],
      ),
      SearchView(),
      AddBloodType(
        id: widget.snap['id'],
      ),
      Remove(
        id: widget.snap['id'],
      ),
    OCR_View (),
      NotificationView(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: AssetImage('Assets/Images/bld.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Profile',
                style: Style.style16,
              ),
              leading: Icon(Icons.account_circle),
              onTap: () {
                // Handle profile tap
              },
            ),
            ListTile(
              title: Text(
                'Department',
                style: Style.style16,
              ),
              leading: Icon(Icons.pie_chart),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => inventoryView(
                      id: widget.snap['id'],
                    ),
                  ),
                );
                // Handle department tap
              },
            ),
            ListTile(
              title: Text(
                'My Notification',
                style: Style.style16,
              ),
              leading: Icon(Icons.notifications_active),
              onTap: () {
                Navigator.push(
                  context,
                  (MaterialPageRoute(
                    builder: (context) => NotificationView(),
                  )),
                );
              },
            ),
            ListTile(
              title: Text(
                'Sign Out',
                style: Style.style16,
              ),
              leading: Icon(Icons.output_sharp),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterAsHospitalView(),
                  ),
                  (route) => false,
                );
              },
            ),
            ListTile(
              title: Text(
                'Dark Mode',
                style: Style.style16,
              ),
              leading: Switch(
                value: _theme.isDarkMode,
                onChanged: (value) {
                  _theme.toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    AppBarDashboard(
                      onPressed: _openDrawer,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    BackgroundImageDashboard(
                      url: widget.snap['image'],
                      title: widget.snap['name'],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return pages[index];
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        color: _theme.isDarkMode ? Colors.white : kSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    list[index].image!,
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    list[index].serviceText!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff100B20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: pages.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Style {
  static const style16 = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}

class serviceData {
  String? image;
  String? serviceText;

  serviceData(this.image, this.serviceText);
}

class BackgroundImageDashboard extends StatelessWidget {
  const BackgroundImageDashboard({
    super.key,
    required this.url,
    required this.title,
  });

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(
            0.5,
          ),
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(
              url,
            ),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5), BlendMode.dstATop),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AppBarDashboard extends StatelessWidget {
  const AppBarDashboard({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.menu,
              size: 35,
            )),
        Text(
          'Dashboard',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Container(
          // padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8)),
          child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                size: 30,
              )),
        ),
      ],
    );
  }
}
