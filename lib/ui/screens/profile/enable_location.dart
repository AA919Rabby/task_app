import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/ui/screens/profile/select_language.dart';
import 'package:task/ui/widgets/custom_buttom.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';


class EnableLocation extends StatelessWidget {
  EnableLocation({super.key});

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return Scaffold(
      backgroundColor: AllThemes.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/profile/location.jpg", height: 32.h,),
            Text(
              "Enable Location",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AllThemes.blackColor,
              ),
            ),
            SizedBox(height: 1.5.h),
            Text(
              "Kindly allow us to access your location to\nprovide you with suggestions for nearby\nsalons",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 1.8.h,
                fontWeight: FontWeight.w600,
                color: AllThemes.greyColor,
              ),
            ),
            SizedBox(height: 2.5.h),
            CustomButton(color: AllThemes.blueColor, label:'Enable',
            labelColor: AllThemes.whiteColor,
            ),
            SizedBox(height: 2.5.h),
            GestureDetector(
              onTap: (){
                Get.to(()=>SelectLanguage(),duration: Duration(milliseconds: 500),
                  transition: Transition.fade,curve: Curves.easeIn,
                );
              },
              child: Text(
                'Skip, Not Now',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 2.4.h,
                  fontWeight: FontWeight.w700,
                  color: AllThemes.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
