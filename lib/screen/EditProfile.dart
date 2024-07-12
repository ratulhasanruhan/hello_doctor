
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_doctor/model/DoctorModel.dart';
import 'package:hello_doctor/screen/HomeFunction.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../controller/AvatarController.dart';
import '../utils/colors.dart';


class EditProfile extends StatefulWidget {
  DoctorModel initialData;
  EditProfile({Key? key, required this.initialData}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  List<String> tags = [];

  var box = Hive.box('user');
  final ImagePicker picker = ImagePicker();
  FirebaseFirestore database = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;


  @override
  void initState() {
    super.initState();
    nameController.text = widget.initialData.name;
    experienceController.text = widget.initialData.experience.toString();
    designationController.text = widget.initialData.designation;
    bioController.text = widget.initialData.bio;
    tags = widget.initialData.specialization.cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('প্রোফাইল সম্পাদনা'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.only(top: 15.h, left: 12.w, right: 12.w),
          children: [
            SizedBox(
              height: 25.h,
            ),
            Center(
              child: Consumer<AvatarController>(
                builder: (context, controller, child) {
                  return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        await picker.pickImage(source: ImageSource.gallery, imageQuality: 60).then((value) async {
                          String fileExt = value!.name.substring(value.name.lastIndexOf('.'));

                          Fluttertoast.showToast(
                            msg: 'আপনার ছবি আপলোড হচ্ছে...',
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_LONG,
                          );

                          storage.ref().child('doctor/${DateTime.now().microsecondsSinceEpoch}$fileExt').putData(await value.readAsBytes()).snapshotEvents.listen((taskSnapshot) async {
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

                                await storage.refFromURL(widget.initialData.avatar).delete().then((value) async {
                                  await database.collection('doctor').doc(box.get('phone')).update({
                                    'avatar': await taskSnapshot.ref.getDownloadURL(),
                                  });

                                  controller.setImageLink(
                                      await taskSnapshot.ref.getDownloadURL());
                                  controller.setImageName(
                                      await taskSnapshot.ref.name);

                                  showTopSnackBar(
                                      context, CustomSnackBar.error(message: 'প্রোফাইল ফটো পরিবর্তন হয়েছে'));
                                });

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
            SizedBox(
              height: 10.h,
            ),
            RoundedLoadingButton(
              color: color1,
              controller: _btnController,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
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
                      var user = DoctorModel(
                        name: nameController.text,
                        phone: widget.initialData.phone,
                        password: widget.initialData.password,
                        experience: int.parse(experienceController.text.trim()),
                        avatar: photo,
                        designation: designationController.text,
                        specialization: tags,
                        approved: widget.initialData.approved,
                        active: widget.initialData.active,
                        watched: widget.initialData.watched,
                        bio: bioController.text ?? '',
                      );

                      await database.collection('doctor').doc(Hive.box('user').get('phone')).set(user.toJson()).then((value) async {
                        showTopSnackBar(
                            context,
                            CustomSnackBar.success(message: 'Data updated successfully')
                        );
                        await Future.delayed(Duration(seconds: 2), (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeFunction()));
                        });
                      });
                    }

                } else {
                  _btnController.error();
                  await Future.delayed(Duration(seconds: 2));
                  _btnController.reset();
                }
              },
              child: Text(
                'UPDATE',
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
    );
  }
}
