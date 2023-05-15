import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soldiers_food/helpers/constants.dart';
import 'package:soldiers_food/helpers/db.dart';
import 'package:soldiers_food/widgets/appbar.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  String? itemName;
  DB db = DB();
  List items = [];

  getItems() async {
    items = await db.get(table: 'items');
    setState(() => items);
  }

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  addFood() async {
    if (formState.currentState!.validate()) {
      var insertItem = await db.insert(table: 'items', data: {'title': itemName});
      if (insertItem != null) {
        Get.back(result: 1);
      }
    }
  }

  @override
  void initState() {
    getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: customAppBar('إضافة طعام'),
        body: Form(
          key: formState,
          child: Container(
            padding: const EdgeInsets.all(padding),
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                items.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: DropdownButtonFormField(
                          onChanged: (val) {},
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
                TextFormField(
                  onChanged: (val) => setState(() => itemName = val.trim()),
                  validator: (value) {
                    if (value.toString().trim() == '') {
                      return 'هذا الحقل مطلوب';
                    } else if (value.toString().length < lettersCount) {
                      return 'عدد الأحرف يجب ان تكون اكثر من $lettersCount ';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColor,
                      ),
                    ),
                    labelText: 'إسم المنتج',
                  ),
                ),
                const SizedBox(height: 8),
                MaterialButton(
                  color: primaryColor,
                  textColor: Colors.white,
                  onPressed: addFood,
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
