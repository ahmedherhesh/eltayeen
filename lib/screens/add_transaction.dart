import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soldiers_food/helpers/constants.dart';
import 'package:soldiers_food/helpers/db.dart';
import 'package:soldiers_food/widgets/appbar.dart';
import 'package:flutter/services.dart';

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
  showSnackBar(String text) {
    var snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: Container(
        alignment: Alignment.center,
        child: Text(
          '$text',
          style: textStyle,
        ),
      ),
      duration: Duration(milliseconds: 500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getUsers() async {
    users = await db.get(table: 'users');
    if (users.isEmpty) {
      showSnackBar('أضف مجندين');
      Get.back();
    }
    setState(() => users);
  }

  getItems() async {
    items = await db.get(table: 'items');
    if (items.isEmpty) {
      showSnackBar('أضف طعام');
      Get.back();
    }
    setState(() => items);
  }

  String arNumToEn(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    for (int i = 0; i < arabic.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }

    return input;
  }

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  addTransaction() async {
    if (formState.currentState!.validate()) {
      if (itemId == null || userId == null) return;
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
    }
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
        appBar: customAppBar(title:'معامله جديده'),
        body: Form(
          key: formState,
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
                          validator: (value) {
                            if (value.toString().trim() == '') {
                              return 'هذا الحقل مطلوب';
                            }
                            return null;
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
                          validator: (value) {
                            if (value.toString().trim() == '') {
                              return 'هذا الحقل مطلوب';
                            }
                            return null;
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
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      value = arNumToEn(value.toString().trim());
                      if (value == '') {
                        return 'هذا الحقل مطلوب';
                      }
                      return null;
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
                  onPressed: addTransaction,
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
