import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soldiers_food/helpers/constants.dart';
import 'package:soldiers_food/helpers/db.dart';
import 'package:soldiers_food/widgets/appbar.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  DB db = DB();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: customAppBar(title:'المجندين'),
        body: FutureBuilder(
          future: db.get(table: 'users'),
          builder: (context, AsyncSnapshot snapshot) {
            List data = snapshot.data ?? [];
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else if (data.isEmpty) {
              return const Center(
                child: Text(
                  'لم تضف مجندين بعد',
                  style: textStyle,
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(padding),
              children: List.generate(
                data.length,
                (i) => Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    textColor: Colors.white,
                    title: Text(data[i]['fullname']),
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Get.toNamed(
                        'profile',
                        arguments: {
                          'fullname': data[i]['fullname'],
                          'userId': data[i]['id'],
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Get.toNamed('add_user');
            if (result == 1) setState(() {});
          },
          backgroundColor: primaryColor,
          child: const Icon(Icons.person_add),
        ),
      ),
    );
  }
}
