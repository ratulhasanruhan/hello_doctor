import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_doctor/model/HealthCardModel.dart';
import 'package:hello_doctor/screen/HomeFunction.dart';
import 'package:hello_doctor/utils/Checker.dart';
import 'package:hello_doctor/utils/calculateTIme.dart';
import 'package:hello_doctor/utils/colors.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class QrHealthCard extends StatefulWidget {
  String phone;
  QrHealthCard({required this.phone, Key? key}) : super(key: key);

  @override
  State<QrHealthCard> createState() => _QrHealthCardState();
}

class _QrHealthCardState extends State<QrHealthCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Health Card',
            style: TextStyle(
              color: Colors.white,
            ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: darkGreen,
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeFunction()));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        )
      ),
      body: WillPopScope(
        onWillPop: () async{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeFunction()));
          return false;
        },
        child: FutureBuilder(
          future: checkCard(widget.phone),
          builder: (context, futuer) {
            if(futuer.hasData){
              if(futuer.data == true){
                return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('health_card').doc(widget.phone).snapshots(),
                    builder: (context,AsyncSnapshot snapshot) {
                      if(snapshot.hasData){
                        HealthCardModel data = HealthCardModel.fromJson(snapshot.data.data());

                        if(data.doctor == Hive.box('user').get('phone')){
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 16,
                            ),
                            children: [
                              SizedBox(
                                height: 50.h,
                              ),
                              Card(
                                elevation: 2,
                                color: Colors.white,
                                shadowColor: waterColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12.r),
                                            child: Image.network(
                                              data.photo,
                                              height: 120.h,
                                              width: 100.w,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.name,
                                                style: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Text(
                                                'Phone: ' +data.phone,
                                                style: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                'NID: ' +data.nid,
                                                style: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),

                                              Text(
                                                'Type: ' +data.type,
                                                style: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Text(
                                                'Viewed: ' +data.viewed.toString(),
                                                style: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )

                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Card Created: ' + DateFormat('dd-MM-yyyy').format(data.date.toDate()) + '  ('+ calculateTimeDifference(startDate: data.date.toDate(), endDate: DateTime.now()).replaceAll('-', '') +' আগে)',
                                              style: TextStyle(
                                                color: blackColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),

                                            Text(
                                              'Address: ' + data.address,
                                              style: TextStyle(
                                                color: blackColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Status: ' + data.status,
                                              style: TextStyle(
                                                color: blackColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            data.viewed == 0 ? Text(
                                              'Last visited: ' + 'Not Visited Yet',
                                              style: TextStyle(
                                                color: blackColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ) : Text(
                                              'Last visited: ' + DateFormat('dd-MM-yyyy').format(data.lastDate.toDate()) + '  ('+ calculateTimeDifference(startDate: data.lastDate.toDate(), endDate: DateTime.now()).replaceAll('-', '') +' আগে)',
                                              style: TextStyle(
                                                color: blackColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.r),
                                          ),
                                          height: 45.h,
                                          color: Colors.red,
                                          child: Text(
                                            'CANCEL',
                                            style: GoogleFonts.varelaRound(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white
                                            ),
                                          ),
                                          onPressed: (){
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeFunction()));
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
                                          color: Colors.green,
                                          child: Text(
                                            'CONFIRM',
                                            style: GoogleFonts.varelaRound(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white
                                            ),
                                          ),
                                          onPressed: ()async{
                                            await FirebaseFirestore.instance.collection('health_card').doc(widget.phone).update({
                                              'status': 'confirmed',
                                              'viewed': FieldValue.increment(1),
                                            });
                                            await FirebaseFirestore.instance.collection('doctor').doc(Hive.box('user').get('phone')).update({
                                              'watched': FieldValue.increment(1),
                                            });
                                            showTopSnackBar(
                                                context,
                                                CustomSnackBar.success(
                                                  message: 'Patient watched confirmed',
                                                  backgroundColor: Colors.green,
                                                )
                                            );
                                            Future.delayed(Duration(seconds: 2), (){
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeFunction()));
                                            });
                                          }

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        else{
                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Lottie.network('https://assets1.lottiefiles.com/packages/lf20_h55dw0gs.json'),
                                Text(
                                    'You are not his/her Doctor',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                ),
                              ],
                            ),
                          );
                        }

                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                );
              }
              else{
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.network('https://assets1.lottiefiles.com/packages/lf20_debgr4jk.json'),
                      Text(
                          'Health card is not valid',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                    ],
                  ),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        ),
      ),
    );
  }
}
