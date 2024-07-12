import 'package:cached_network_image/cached_network_image.dart';
import 'package:chip_list/chip_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_doctor/controller/AvatarController.dart';
import 'package:hello_doctor/model/DoctorModel.dart';
import 'package:hello_doctor/screen/WelcomeScreen.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import '../utils/colors.dart';
import 'ChangePassword.dart';
import 'EditProfile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  var box = Hive.box('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Color(0xFF272A2F),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('doctor').doc(box.get('phone')).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            DoctorModel data = DoctorModel.fromJson(snapshot.data.data());
            List<String> listOfChipNames = List<String>.from(
                snapshot.data['specialization']);


            return ListView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(top: 10.h, left: 12.w, right: 12.w),
                children: [
                  Center(
                    child:  WidgetCircularAnimator(
                      innerColor: color1,
                      outerColor: color1,
                      size: 125.h,
                      child: Container(
                          height: 85.r,
                          width: 85.r,
                          padding: EdgeInsets.all(3.5.r),
                          decoration: BoxDecoration(
                            color: color1,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: data.avatar,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Image.asset(
                                  'assets/avatar.png',
                                  fit: BoxFit.cover,
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  'assets/avatar.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Text(
                    data.name,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5.h,),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        data.designation,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h,),
                  ChipList(
                    listOfChipNames: listOfChipNames,
                    activeBgColorList: [primaryColor],
                    inactiveBgColorList: [Color(0xFFF6F6F6)],
                    activeTextColorList: [Colors.white],
                    inactiveTextColorList: [Color(0xFF5E5E5E)],
                    listOfChipIndicesCurrentlySeclected: [-1],
                    shouldWrap: true,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    extraOnToggle: (index) {
                      print(index);
                    },
                  ),
                  SizedBox(height: 5.h,),
                  Card(
                    color: Colors.white,
                    shadowColor: waterColor,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        data.bio,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Card(
                    color: Colors.white,
                    child: SwitchListTile(
                      value: data.active,
                      onChanged: (value) {
                        FirebaseFirestore.instance.collection('doctor').doc(box.get('phone')).update({
                          'active': value
                        });
                        setState(() {
                          data.active = value;
                        });
                      },
                      activeColor: color1,
                      title: Text(
                        'Activity',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(Icons.health_and_safety_outlined, color: color1,),
                      minLeadingWidth: 0,
                      title: Text(
                        'Patient watched',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      trailing: Text(
                        data.watched.toString(),
                        style: TextStyle(
                            color: color1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(Icons.edit, color: color1,),
                      minLeadingWidth: 0,
                      title: Text(
                        'Edit Profile',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Provider.of<AvatarController>(context, listen: false).setImageLink(data.avatar);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(initialData: data,)));
                      },
                  ),
                  ),
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(Icons.password, color: color1,),
                      minLeadingWidth: 0,
                      title: Text(
                        'Change Password',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePassword()));
                      },
                  ),
                  ),
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () async {
                        box.clear();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => WelcomeScreen()),
                                (route) => false);
                      },
                      leading: Icon(Icons.logout, color: color1,),
                      minLeadingWidth: 0,
                      title: Text(
                        'Logout',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                  ),
                  ),

                  SizedBox(
                    height: 20.h,
                  )


                ]
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
