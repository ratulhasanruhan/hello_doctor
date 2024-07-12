import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/Checker.dart';
import '../utils/colors.dart';
import 'HomeFunction.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  var box = Hive.box('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Lottie.network(
            'https://assets9.lottiefiles.com/private_files/lf30_fw6h59eu.json',
            height: 300.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Welcome back, you\'ve been missed!',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: '018XXXX',
                      labelText: 'Phone Number',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    maxLength: 11,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TextFormField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '********',
                      labelText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  RoundedLoadingButton(
                      controller: _btnController,
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){

                        if(await checkIfDocExists(phoneController.text)) {
                          var user = await FirebaseFirestore.instance.collection('doctor').doc(phoneController.text).get();

                          if(passController.text.trim() == user['password']) {

                            if(user['approved'] == true){
                              await box.put('phone', phoneController.text).then((value) {
                                _btnController.success();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeFunction()));
                              });
                            }
                            else{
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text('একাউন্ট অনুমোদন হয়নি'),
                                      content: Text('আপনার একাউন্ট টি এখনো অনুমোদিত হয়নি। অনুগ্রহ করে অপেক্ষা করুন। অথবা এডমিনদের সাথে যোগাযোগ করুন। '),
                                      actions: [
                                        TextButton(
                                            onPressed: ()async{
                                              await launchUrl(Uri.parse('https://wa.me/+8801316356332'), mode: LaunchMode.externalApplication);
                                            },
                                            child: Text('Contact')
                                        ),
                                        TextButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: Text('Close')
                                        ),
                                      ],
                                    );
                                  }
                              );
                            }

                          }
                          else{
                            showTopSnackBar(
                                context,
                                CustomSnackBar.error(message: 'আপনার পাসওয়ার্ড সঠিক নয়')
                            );
                            _btnController.error();
                            Future.delayed(Duration(seconds: 1), (){
                              _btnController.reset();
                            });
                          }

                        }
                        else{
                          showTopSnackBar(
                              context,
                              CustomSnackBar.error(message: 'আপনার মোবাইল নম্বরটি নিবন্ধিত নয়।\nরেজিস্ট্রেশন করুন')
                          );
                          _btnController.error();
                          Future.delayed(Duration(seconds: 1), (){
                            _btnController.reset();
                          });
                        }

                      }else{
                        _btnController.error();
                        Future.delayed(const Duration(seconds: 1),(){
                          _btnController.reset();
                        });
                      }

                    },
                      borderRadius: 12.r,
                    color: color1,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
