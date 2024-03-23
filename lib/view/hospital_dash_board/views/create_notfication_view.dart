import 'package:bldapp/Colors.dart';
import 'package:bldapp/helper/notification_helper.dart';
import 'package:bldapp/widget/custom_card_notification.dart';
import 'package:bldapp/widget/show_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);
  static const String path = "lib/src/pages/lists/list2.dart";

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final TextStyle dropdownMenuItem =
      const TextStyle(color: Colors.black, fontSize: 18);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  CollectionReference notification =
      FirebaseFirestore.instance.collection('notification');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          customShowBottomSheet(context);
        },
        child: Icon(
          Icons.notification_add,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 145),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: StreamBuilder<List<QueryDocumentSnapshot>>(
                    stream: notification
                        .snapshots()
                        .map((snapshot) => snapshot.docs),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Something went wrong'),
                        );
                      } else {
                        List<QueryDocumentSnapshot> dataList = snapshot.data!;

                        return ListView.builder(
                            itemCount: dataList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CustomCardNotification(
                                snap: dataList[index],
                              );
                            });
                      }
                    }),
              ),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white
                        ),
                      ),
                      const Text(
                        "Notification",
                        style: TextStyle(fontSize: 24,color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete
                          ,color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
