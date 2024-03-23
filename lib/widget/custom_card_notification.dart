import 'package:bldapp/Colors.dart';
import 'package:bldapp/Provider/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomCardNotification extends StatelessWidget {

  const CustomCardNotification({super.key, required this.snap});
  final QueryDocumentSnapshot snap;
  @override
  Widget build(BuildContext context) {
          var _theme = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color:  _theme.isDarkMode? Colors.white : kSecondary ,
      ),
      width: double.infinity,
      // height: 110,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 3, color: kSecondary),
            ),
            child: Icon(
              Icons.notifications_active,
              color: kPrimary,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomListTile(
                  text: snap['bloodType'],
                  icon: Icons.bloodtype,
                  fontSize: 20,


                ),
                CustomListTile(
                  text: snap['userName'],
                  icon: Icons.person,

                ),
                CustomListTile(
                  text: snap['place'],
                  icon: Icons.location_on,

                ),
                CustomListTile(
                  text: snap['phoneNumber'],
                  icon: Icons.phone,

                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  
  const CustomListTile({
    super.key,
    this.fontSize = 14,
    required this.text,
    required this.icon,
  });
  final String text;
  final double fontSize;

  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: kPrimary,
          size: 20,
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          width: 180,
          child: Text(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text,
            style: TextStyle(
                color: kPrimary,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
      ],
    );
  }
}
