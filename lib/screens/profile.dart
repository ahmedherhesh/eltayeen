import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soldiers_food/helpers/constants.dart';
import 'package:soldiers_food/helpers/db.dart';
import 'package:soldiers_food/widgets/appbar.dart';
import 'package:soldiers_food/widgets/user_info.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var args = Get.arguments;
  DB db = DB();
  @override
  Widget build(BuildContext context) {
    String fullname = args['fullname'];
    int userId = args['userId'];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: customAppBar(title: fullname),
        body: ListView(
          children: [
            Container(
              decoration: BoxDecoration(color: Color(0xff40739e), borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(margin),
              child: Column(
                children: [
                  // User Info
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.account_circle, size: 30),
                      ),
                      SizedBox(width: 12),
                      Text(fullname, style: TextStyle(color: Colors.white, fontSize: 18))
                    ],
                  ),
                  // User Transactions
                  UserInfo(db: db, userId: userId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

