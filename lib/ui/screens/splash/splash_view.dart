import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/core/all_themes.dart';
import 'package:get/get.dart';
import 'package:task/core/sizes.dart';
import '../../logic/splash_controller.dart';


class SplashView extends StatelessWidget {
  SplashView({super.key});
  //Injection the controller (GetX)
  final splashController=Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return Scaffold(
      backgroundColor: AllThemes.whiteColor,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Center(
                child: Column(
                  children: [
                    const Spacer(),
                    //Intro Image
                    Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.7,
                      child: Image.asset(
                        'assets/intro/splash.jpg',
                        width: 80.w,
                      ),
                    ),


                    //Main Title Text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        "Theory test in my language",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AllThemes.blackColor,
                          fontSize: 3.h,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Subtitle description text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        "I must write the real test will be in English language and this app just helps you to understand the materials in your language",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AllThemes.greyColor,
                          fontSize: 1.8.h,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const Spacer(flex: 2,),
                    // Loading indicator
                    SpinKitFadingCircle(
                      color: AllThemes.blueColor,
                      size: 10.w,
                    ),

                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}