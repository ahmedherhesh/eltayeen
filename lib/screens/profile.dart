import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soldiers_food/helpers/constants.dart';
import 'package:soldiers_food/helpers/db.dart';
import 'package:soldiers_food/widgets/appbar.dart';

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
        appBar: customAppBar('${fullname}'),
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
                  FutureBuilder(
                    future: db.read(''' 
                                SELECT DISTINCT (itemId),
                                items.title,
                                transactions.userId,
                                SUM(qty) as qty 
                                FROM `transactions` 
                                INNER JOIN items ON transactions.itemId = items.id 
                                AND transactions.userId=$userId 
                                AND transactions.status=1
                                GROUP BY itemId ;
                         '''),
                    builder: (context, AsyncSnapshot snapshot) {
                      List data = snapshot.data ?? [];
                      return Row(
                        children: List.generate(
                          data.length,
                          (i) => Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${data[i]['qty']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${data[i]['title']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
