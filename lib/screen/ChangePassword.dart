import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../utils/colors.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();

  FirebaseFirestore database = FirebaseFirestore.instance;
  var box = Hive.box('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'পাসওয়ার্ড পরিবর্তন',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
          physics: const BouncingScrollPhysics(),
          children: [
            TextFormField(
              controller: oldPassword,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black,
              ),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  fillColor: offWhite,
                  filled: true,
                  hintText: 'পুরাতন পাসওয়ার্ড',
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 8, top: 5, bottom: 5),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.password_rounded, color: primaryColor,),
                          VerticalDivider(color: darkWhite,thickness:1),
                        ],
                      ),
                    ),
                  )
              ),
              validator: (val){
                if(val!.isEmpty){
                  return "পুরাতন পাসওয়ার্ড লিখুন";
                }
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: newPassword,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: blackColor,
              ),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  fillColor: offWhite,
                  filled: true,
                  hintText: 'নতুন পাসওয়ার্ড',
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 8, top: 5, bottom: 5),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FeatherIcons.lock, color: primaryColor,),
                          VerticalDivider(color: darkWhite,thickness:1),
                        ],
                      ),
                    ),
                  )
              ),
              validator: (val){
                if(val!.isEmpty){
                  return "নতুন পাসওয়ার্ড লিখুন";
                }
                if(val.length < 6){
                  return "পাসওয়ার্ড কমপক্ষে ৬ অক্ষর হতে হবে";
                }
              },
            ),
            SizedBox(height: 25.h,),
            RoundedLoadingButton(
              color: primaryColor,
              controller: _btnController,
              onPressed: () async {
                if(_formKey.currentState!.validate()){
                  await database.collection('doctor').doc(box.get('phone')).get().then((value) async {
                    if(value.data()!['password'] == oldPassword.text){
                      await database.collection('doctor').doc(box.get('phone')).update({
                        'password': newPassword.text,
                      }).then((value) {
                        _btnController.success();
                        Navigator.pop(context);
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(message: 'Password Changed Successfully'),
                        );
                      });
                    }else{
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(message: 'পুরাতন পাসওয়ার্ড ভুল হয়েছে'),
                      );
                      _btnController.error();
                      Future.delayed(Duration(seconds: 1), () {
                        _btnController.reset();
                      });
                    }
                  });
                }
                else{
                  _btnController.error();
                  Future.delayed(Duration(seconds: 1),(){
                    _btnController.reset();
                  });
                }
              },
              child: Text('সাবমিট',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
