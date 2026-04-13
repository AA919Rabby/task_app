import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:task/ui/logic/network_controller.dart';
import 'package:task/ui/screens/auth/forgetpass.dart';
import 'package:task/ui/screens/auth/resetpass.dart';
import 'package:task/ui/screens/auth/resetpass_verify.dart';
import 'package:task/ui/screens/auth/signin.dart';
import 'package:task/ui/screens/auth/signup.dart';
import 'package:task/ui/screens/auth/verify_view.dart';
import 'package:task/ui/screens/home/add_product.dart';
import 'package:task/ui/screens/home/edit_product.dart';
import 'package:task/ui/screens/home/home_view.dart';
import 'package:task/ui/screens/profile/enable_location.dart';
import 'package:task/ui/screens/profile/profile.dart';
import 'package:task/ui/screens/profile/select_language.dart';
import 'package:task/ui/screens/profile/setprofile.dart';
import 'package:task/ui/screens/splash/onboarding_view.dart';
import 'package:task/ui/screens/splash/splash_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/models/product_model.dart';


void main()async{
  //This prevent app from landscape, for better user experiences
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());
  await Hive.openBox<ProductModel>('productsBox');
  Get.put(NetworkController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
    debugShowCheckedModeBanner: false,
     home: SplashView(),
    );
  }
}

