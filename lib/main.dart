import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hello_doctor/screen/HomeFunction.dart';
import 'package:hello_doctor/screen/RegistrationScreen.dart';
import 'package:hello_doctor/screen/WelcomeScreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'controller/AvatarController.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('user');

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AvatarController()),
        ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  var box = Hive.box('user');

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          title: 'Hello Doctor',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,

          ),
          home: box.get('phone') == '' || box.get('phone') == null ? WelcomeScreen() : HomeFunction(),
        );
      }
    );
  }
}
