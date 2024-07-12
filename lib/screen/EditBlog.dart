import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../utils/colors.dart';
import 'HomeFunction.dart';

class EditBlog extends StatefulWidget {
  String title;
  String description;
  EditBlog({required this.title, required this.description});

  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    descriptionController.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Blog',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: darkGreen,
        elevation: 3,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [

            const SizedBox(height: 20,),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter title';
                }
                return null;
              },
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: descriptionController,
              minLines: 5,
              maxLines: 15,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),

            SizedBox(height: 20.h),

            ElevatedButton(
              onPressed: () {
                if (key.currentState!.validate()) {
                  FirebaseFirestore.instance.collection('blog').add(
                      {
                        'title' : titleController.text,
                        'description' : descriptionController.text,
                      }

                  ).then((value) {
                    OverlayLoadingProgress.stop();
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: 'Blog updated successfully',
                        onConfirmBtnTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeFunction()));
                        }
                    );
                  });
                }
              },
              child: Text('Update'),
            ),

          ],
        ),
      ),
    );
  }
}
