import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soldiers_food/helpers/constants.dart';
import 'package:soldiers_food/helpers/db.dart';
import 'package:soldiers_food/widgets/appbar.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  DB db = DB();
  List users = [];
  List items = [];
  int qty = 1;
  int? userId, itemId;
  getUsers() async {
    users = await db.get(table: 'users');
    setState(() => users);
  }

  getItems() async {
    items = await db.get(table: 'items');
    setState(() => items);
  }

  @override
  void initState() {
    getUsers();
    getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: customAppBar('معامله جديده'),
        body: Form(
          child: Container(
            padding: const EdgeInsets.all(padding),
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                users.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: DropdownButtonFormField(
                          onChanged: (val) {
                            userId = int.parse('$val');
                          },
                          hint: const Text('المجندين'),
                          items: List.generate(
                            users.length,
                            (i) => DropdownMenuItem(
                              value: users[i]['id'],
                              onTap: () {},
                              child: Text('${users[i]['fullname']}'),
                            ),
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                items.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: DropdownButtonFormField(
                          onChanged: (val) {
                            itemId = int.parse('$val');
                          },
                          hint: const Text('الطعام'),
                          items: List.generate(
                            items.length,
                            (i) => DropdownMenuItem(
                              value: items[i]['id'],
                              onTap: () {},
                              child: Text('${items[i]['title']}'),
                            ),
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    onChanged: (val) {
                      qty = val.isNotEmpty ? int.parse(val) : 1;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                      labelText: 'الكميه',
                    ),
                  ),
                ),
                MaterialButton(
                  color: primaryColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (itemId == null || userId == null) {
                      return;
                    }
                    var insertItem = await db.insert(
                      table: 'transactions',
                      data: {
                        'adminId': 1,
                        'userId': userId,
                        'itemId': itemId,
                        'qty': qty,
                        'date': date,
                      },
                    );
                    if (insertItem != null) {
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
    );
  }
}
