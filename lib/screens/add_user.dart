import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soldiers_food/helpers/constants.dart';
import 'package:soldiers_food/helpers/db.dart';
import 'package:soldiers_food/widgets/appbar.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String? fullname;
  @override
  Widget build(BuildContext context) {
    DB db = DB();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: customAppBar('إضافة مجند'),
        body: Padding(
          padding: const EdgeInsets.all(padding),
          child: Form(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (val) {
                      setState(() {
                        fullname = val;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                      labelText: 'الإسم بالكامل',
                    ),
                  ),
                  const SizedBox(height: 8),
                  MaterialButton(
                    color: primaryColor,
                    textColor: Colors.white,
                    onPressed: () async {
                      var insertUser = await db.insert(table: 'users', data: {'fullname': fullname, 'role': 'user'});
                      if (insertUser != null) {
                        Get.back(result: 1);
                      }
                    },
                    child: const Text(
                      'إضافة',
                      style: textStyle,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
