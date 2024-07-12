import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hello_doctor/screen/HomeFunction.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../utils/colors.dart';

class AddBlog extends StatefulWidget {

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final key = GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();

  XFile? image;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Add Blog',
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

            InkWell(
              onTap: () async{
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    image = pickedFile;
                  });
                } else {
                  print('No image selected.');
                }
              },

              child: image == null
                  ? Image.asset(
                'assets/add_image.png',
                height: 100.h,
                width: 100.w,
              )
                  : Image.file(File(image!.path),
                height: 100.h,
                width: 100.w,
              ),
            ),

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
              maxLines: 10,
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
                  if (image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select an image'),
                      ),
                    );
                  } else {
                    OverlayLoadingProgress.start(context);

                    FirebaseStorage.instance.ref().child('notice/${DateTime.now().millisecondsSinceEpoch}').putFile(File(image!.path)).then((value) {

                      FirebaseFirestore.instance.collection('doctor').doc(Hive.box('user').get('phone')).get().then((name) {
                        value.ref.getDownloadURL().then((value) {
                          FirebaseFirestore.instance.collection('blog').add(
                          {
                          'title' : titleController.text,
                          'description' : descriptionController.text,
                          'date' : Timestamp.now(),
                          'image' : value,
                          'writer' : name['name'],
                           'phone' : Hive.box('user').get('phone'),
                          }

                          ).then((value) {
                            OverlayLoadingProgress.stop();
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                title: 'Blog added successfully',
                                onConfirmBtnTap: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeFunction()));
                                }
                            );
                          });


                        });
                      });


                    });

                  }
                }
              },
              child: Text('Submit'),
            ),

          ],
        ),
      ),
    );
  }
}
