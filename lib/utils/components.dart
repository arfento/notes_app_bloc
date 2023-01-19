import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_bloc/data/blocs/main_cubit/main_cubit.dart';

Widget defaultTextField(
    {required TextEditingController? controller,
    required TextInputType type,
    bool obsecure = false,
    InputDecoration? decoration,
    required IconData prefix,
    double radius = 35,
    IconData? suffix,
    void Function()? ontap,
    required String label,
    final VoidCallback? suffixpressed,
    required String? Function(String?)? validate,
    void Function(String)? onsubmit,
    AutovalidateMode? validatemode}) {
  return TextFormField(
    onTap: ontap,
    onFieldSubmitted: onsubmit,
    autovalidateMode: validatemode,
    obscureText: obsecure,
    controller: controller,
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixpressed, icon: Icon(suffix))
            : null),
    validator: validate,
    keyboardType: type,
  );
}

List colors = [
  Colors.purple,
  Colors.amber,
  Colors.teal,
  Colors.pinkAccent.shade100
];

Widget buildNotesItem({required Map mp, context, required dynamic color}) {
  var cubit = MainCubit.get(context);
  var dateController = TextEditingController();
  return Container(
      width: double.infinity,
      height: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'note  : ${mp['ID']}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'title : ${mp['TITLE']}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text('body : ${mp['BODY']}',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              'date : ${mp['DATE']}',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Update'),
                                content: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35)),
                                  child: TextFormField(
                                    controller: dateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        suffixIcon: GestureDetector(
                                            onTap: () {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.parse(
                                                          '2025-12-31'))
                                                  .then((value) {
                                                if (value != null) {
                                                  dateController.text =
                                                      DateFormat.yMMMd()
                                                          .format(value);
                                                }
                                              });
                                            },
                                            child: const Icon(
                                              Icons.calendar_today_sharp,
                                            )),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(35)),
                                        labelText: 'date'),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        cubit.updateDb(
                                            date: dateController.text,
                                            id: mp['ID']);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Save Changes'))
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.edit, color: Colors.green)),
                  const SizedBox(
                    width: 25.0,
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                width: 15.0,
                                height: 15,
                                child: AlertDialog(
                                  icon: const Icon(Icons.delete_forever,
                                      size: 25),
                                  backgroundColor: Colors.indigo.shade200,
                                  content: const Text(
                                    'Are you sure you want to delete this item ?',
                                    style: TextStyle(height: 2),
                                  ),
                                  title: const Text(
                                    'Delete item ',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Container(
                                        width: 60.0,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            color: Colors.green),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Yes',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        cubit.deleteFromDb(id: mp['ID']);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Container(
                                        width: 60.0,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            color: Colors.red),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'No',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),

                                    //  TextButton(onPressed: (){}, child: Text('Yes'))
                                  ],
                                ),
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ],
              ),
            ),
          ],
        ),
      ));
}

Widget buildNotesBuilder({required List<Map> notes}) {
  if (notes.length > 0) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildNotesItem(
            color: colors[index % colors.length],
            mp: MainCubit.get(context).notes[index],
            context: context),
        separatorBuilder: (context, index) => const SizedBox(height: 10.0),
        itemCount: notes.length);
  } else {
    return const Center(
      child: Text(
        "No Notes here add notes",
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
