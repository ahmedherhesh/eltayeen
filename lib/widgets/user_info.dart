import 'package:flutter/material.dart';
import 'package:soldiers_food/helpers/db.dart';

// ignore: must_be_immutable
class UserInfo extends StatelessWidget {
  UserInfo({required this.db, required this.userId, and});
  final DB db;
  final int userId;
  String and = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.read(''' 
                  SELECT DISTINCT (itemId),
                  items.title,
                  transactions.userId,
                  SUM(qty) as qty 
                  FROM `transactions` 
                  INNER JOIN items ON transactions.itemId = items.id 
                  AND transactions.userId=$userId 
                  AND transactions.status=1 $and
                  GROUP BY itemId ;
           '''),
      builder: (context, AsyncSnapshot snapshot) {
        List data = snapshot.data ?? [];
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              data.length,
              (i) => Container(
                margin: (data.length == i + 1) ? EdgeInsets.only(left: 0) : EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    SizedBox(height: 15),
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
          ),
        );
      },
    );
  }
}
