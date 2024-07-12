import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_doctor/model/DoctorModel.dart';
import 'package:hello_doctor/screen/LoginScreen.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../controller/AvatarController.dart';
import '../utils/Checker.dart';
import '../utils/colors.dart';
import 'HomeFunction.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final key = GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();
  FirebaseFirestore database = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  List<String> tags = [];

  var box = Hive.box('user');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var img = context.read<AvatarController>().imageName;
        if (img == null) {
          return true;
        } else {
          await storage.ref().child('doctor/$img').delete();
          Fluttertoast.showToast(
            msg: 'রেজিস্ট্রেশন বাতিল করা হচ্ছে...',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
          );
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: key,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            children: [
              const SizedBox(height: 20),
              const Text(
                'Hello Doctor',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Consumer<AvatarController>(
                  builder: (context, controller, child) {
                    return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          await picker
                              .pickImage(
                                  source: ImageSource.gallery, imageQuality: 60)
                              .then((value) async {
                            String fileExt = value!.name
                                .substring(value.name.lastIndexOf('.'));

                            storage
                                .ref()
                                .child(
                                    'doctor/${DateTime.now().microsecondsSinceEpoch}$fileExt')
                                .putData(await value.readAsBytes())
                                .snapshotEvents
                                .listen((taskSnapshot) async {
                              switch (taskSnapshot.state) {
                                case TaskState.running:
                                  final progress =
                                      (taskSnapshot.bytesTransferred /
                                          taskSnapshot.totalBytes);
                                  controller.setProgress(progress);
                                  print("Upload is $progress% complete.");
                                  break;
                                case TaskState.paused:
                                  print("Upload is paused.");
                                  break;
                                case TaskState.canceled:
                                  print("Upload was canceled");
                                  break;
                                case TaskState.error:
                                  print("Upload was error");
                                  break;
                                case TaskState.success:
                                  print("Successful");
                                  controller.setImageLink(
                                      await taskSnapshot.ref.getDownloadURL());
                                  controller.setImageName(
                                      await taskSnapshot.ref.name);
                                  print(
                                      await taskSnapshot.ref.getDownloadURL());
                                  break;
                              }
                            });
                          });
                        },
                        child: controller.imageLink == null
                            ? CircularPercentIndicator(
                                radius: 65,
                                lineWidth: 5,
                                percent: controller.progress,
                                progressColor: primaryColor,
                                backgroundColor: Colors.white,
                                center: Image.asset(
                                  'assets/add_avatar.png',
                                  height: 80.h,
                                ),
                              )
                            : ClipOval(
                                child: FadeInImage(
                                placeholder: AssetImage(
                                  'assets/success.gif',
                                ),
                                image: NetworkImage(
                                  controller.imageLink,
                                ),
                                height: 80.h,
                                width: 80.h,
                                fit: BoxFit.cover,
                              )));
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: designationController,
                decoration: InputDecoration(
                  labelText: 'Designation',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your designation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: experienceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Experience (in years)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your experience';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: bioController,
                decoration: InputDecoration(
                  labelText: 'Biography',
                  hintText: '(You can change it later)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                minLines: 1,
              ),
              const SizedBox(height: 6),
              Text(
                'Specialization',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('admin')
                      .doc('doctor')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ChipsChoice<String>.multiple(
                        padding: const EdgeInsets.only(top: 3, bottom: 14),
                        wrapped: true,
                        choiceCheckmark: true,
                        value: tags,
                        onChanged: (val) => setState(() => tags = val),
                        choiceItems: C2Choice.listFrom<String, String>(
                          source:
                              snapshot.data['specialization'].cast<String>(),
                          value: (i, v) => v,
                          label: (i, v) => v,
                        ),
                      );
                    }
                    return Text(
                      'Loading...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    );
                  }),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 11,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length < 11) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              RoundedLoadingButton(
                color: color1,
                controller: _btnController,
                onPressed: () async {
                  if (key.currentState!.validate()) {
                    var photo = context.read<AvatarController>().imageLink;

                    if (photo == null) {
                      Fluttertoast.showToast(
                          msg: "অনুগ্রহ করে ফটো সিলেক্ট করুন",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Future.delayed(const Duration(seconds: 1), () {
                        _btnController.reset();
                      });
                    } else if (tags.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please Select Specialization",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Future.delayed(const Duration(seconds: 1), () {
                        _btnController.reset();
                      });
                    } else {
                      //TODO: send data to server
                      bool userExists =
                          await checkIfDocExists(phoneController.text);

                      if (userExists) {
                        showTopSnackBar(
                          context,
                          const CustomSnackBar.error(
                              message:
                                  "আপনার মোবাইল নম্বর ইতিমধ্যে নিবন্ধিত রয়েছে।\nলগইন করুন "),
                        );
                        _btnController.error();
                        Future.delayed(const Duration(seconds: 1), () {
                          _btnController.reset();
                        });
                      } else {
                        var user = DoctorModel(
                          name: nameController.text,
                          phone: phoneController.text,
                          password: passwordController.text,
                          experience:
                              int.parse(experienceController.text.trim()),
                          avatar: photo,
                          designation: designationController.text,
                          specialization: tags,
                          approved: false,
                          active: false,
                          watched: 0,
                          bio: bioController.text ?? '',
                        );

                        await database
                            .collection('doctor')
                            .doc(phoneController.text.trim())
                            .set(user.toJson())
                            .then((value) async {
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text('রেজিস্ট্রেশন সফল হয়েছে'),
                                      content: Text('শীঘ্রই আপনার একাউন্ট এর তথ্য যাচাই করে একটিভ করে দেয়া হবে। তারপর আপনি লগইন অপসন থেকে লগইন করতে পারবেন। ধন্যবাদ। '),
                                      actions: [
                                        TextButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: Text('Close')
                                        ),
                                        TextButton(
                                            onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                            },
                                            child: Text('Login')
                                        )
                                      ],
                                    );
                                  }
                              );
                        });
                      }
                    }
                  } else {
                    _btnController.error();
                    await Future.delayed(Duration(seconds: 2));
                    _btnController.reset();
                  }
                },
                child: Text(
                  'REGISTER',
                  style: GoogleFonts.varelaRound(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
