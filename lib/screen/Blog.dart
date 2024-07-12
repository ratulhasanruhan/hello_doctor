import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_doctor/screen/EditBlog.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../utils/colors.dart';
import 'AddBlog.dart';

class Blog extends StatefulWidget {
  const Blog({Key? key}) : super(key: key);

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {

  final query = FirebaseFirestore.instance.collection('blog').where('phone', isEqualTo: Hive.box('user').get('phone'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backWhite,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddBlog()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: backWhite,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Blog',
          style: TextStyle(
            color: blackColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(
          color: blackColor,
        ),
      ),
      body: FirestoreListView(
        padding: EdgeInsets.symmetric(horizontal: 8.w,),
        query: query,
        itemBuilder: (context, snapshot,) {

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF656565).withOpacity(0.1),
                        blurRadius: 50,
                        spreadRadius: 0,
                        offset: const Offset(0, 0),
                      ),
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        placeholder: AssetImage(
                            'assets/medi.png'
                        ),
                        image: NetworkImage( snapshot['image'],
                        ),
                        imageErrorBuilder: (context, ob, stack){
                          return Image.asset('assets/medi.png');
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot['title'],
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(snapshot['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: greyWhite,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat('MMMM dd, yyyy').format(snapshot['date'].toDate()),
                                style: TextStyle(
                                  color: greyWhite,
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Delete Blog'),
                                            content: const Text('Are you sure you want to delete this blog?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance.collection('blog').doc(snapshot.id).delete();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: greyWhite,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 20,),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditBlog(title: snapshot['title'], description: snapshot['description'],)));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: greyWhite,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
          );

        },
      ),

    );
  }
}
