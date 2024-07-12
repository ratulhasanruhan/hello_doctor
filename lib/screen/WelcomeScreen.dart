import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_doctor/utils/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import 'LoginScreen.dart';
import 'RegistrationScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 70.h,
          ),
          Lottie.asset(
            'assets/doctor.json',
            width: 270.w,
          ),
          Text(
            'HELLO DOCTOR',
            style: GoogleFonts.varelaRound(
              fontSize: 26.sp,
              fontWeight: FontWeight.w600,
              color: color1,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Manage your all patients',
            style: GoogleFonts.varelaRound(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color1.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(
            height: 40.h,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  height: 45.h,
                  color: color1,
                  child: Text(
                    'REGISTER',
                    style: GoogleFonts.varelaRound(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                    ),
                  ),
                    onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                    }
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    height: 45.h,
                    color: color1,
                    child: Text(
                    'LOGIN',
                    style: GoogleFonts.varelaRound(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                    ),
                  ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    }
                ),
              ),
            ],
          ),

          SizedBox(
            height: 20.h,
          ),
          TextButton(
              onPressed: () async{
                await launchUrl(Uri.parse('https://wa.me/+8801316356332'), mode: LaunchMode.externalApplication);
              },
              child: Text(
                'Support',
                style: GoogleFonts.varelaRound(
                  fontSize: 14,
                  color: color1.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              )
          ),

        ],
      ),
    );
  }
}
