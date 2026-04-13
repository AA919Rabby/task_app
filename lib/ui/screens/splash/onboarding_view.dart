import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/ui/screens/auth/signin.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';
import '../../logic/onboarding_controller.dart';


class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});
  //Injecting controller
  final onboardingController = Get.put(OnboardingController());
  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return Scaffold(
      backgroundColor: AllThemes.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: onboardingController.pageController,
                onPageChanged: onboardingController.onPageChanged,
                itemCount: onboardingController.onboardingData.length,
                itemBuilder: (context, index) {
                 return Obx((){
                   bool isActive = onboardingController.currentPage.value == index;
                   return Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       //Animation
                     AnimatedScale(
                       scale: isActive ? 1.0 : 0.8,
                       duration: const Duration(milliseconds: 500),
                       curve: Curves.easeOutBack,
                         child: AnimatedOpacity(
                           opacity: isActive ? 1.0 : 0.0,
                           duration: const Duration(milliseconds: 500),
                           child: Stack(
                             alignment: Alignment.center,
                             children: [
                               // Image
                               Image.asset(
                                 onboardingController.onboardingData[index]['images']!,
                                 height: 34.h,
                                 fit: BoxFit.contain,
                               ),
                             ],
                           ),
                         ),
                       ),
                       SizedBox(height: 4.h),
                       // Title
                       Text(
                         onboardingController.onboardingData[index]['title']!,
                         textAlign: TextAlign.center,
                         style: GoogleFonts.inter(
                           fontSize: 3.2.h,
                           fontWeight: FontWeight.w700,
                           color: AllThemes.blackColor,
                         ),
                       ),
                       SizedBox(height: 1.5.h),
                       // Subtitle
                       Padding(
                         padding: EdgeInsets.symmetric(horizontal: 10.w),
                         child: Text(
                           onboardingController.onboardingData[index]['subtitle']!,
                           textAlign: TextAlign.center,
                           style: GoogleFonts.inter(
                             fontSize: 1.8.h,
                             fontWeight: FontWeight.w400,
                             color: AllThemes.greyColor,
                             height: 1.5,
                           ),
                         ),
                       ),
                     ],
                   );
                 });
                },
              ),
            ),

            // Bottom section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [
                  // Page Indicators (Dots)
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingController.onboardingData.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        height: 0.8.h,
                        width: onboardingController.currentPage.value == index ? 4.w : 1.5.w,
                        decoration: BoxDecoration(
                          color: onboardingController.currentPage.value == index
                              ? AllThemes.blueColor
                              : AllThemes.blueColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(height: 6.h),

                  // Main Button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 7.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (onboardingController.currentPage.value < 1) {
                          onboardingController.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        } else {
                          //TODO Navigating to user authentication
                          Get.offAll(()=>Signin(),
                           duration: Duration(milliseconds: 500),
                          transition: Transition.leftToRightWithFade,curve: Curves.bounceInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AllThemes.blueColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        onboardingController.onboardingData[onboardingController.currentPage.value]['button']!,
                        style: GoogleFonts.inter(
                          color: AllThemes.whiteColor,
                          fontSize: 2.2.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}