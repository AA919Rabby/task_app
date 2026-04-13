import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/ui/screens/profile/setprofile.dart';
import 'package:task/ui/widgets/custom_buttom.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';
import '../../logic/profile_controller.dart';


class SelectLanguage extends StatelessWidget {
  SelectLanguage({super.key});

  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AllThemes.whiteColor,
      appBar: AppBar(
        backgroundColor: AllThemes.noColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 2),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: AllThemes.whiteColor,
                  border: Border.all(
                    color: AllThemes.greyColor.withOpacity(0.1),
                    width: 1.5,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios, size: 2.7.h)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            // Added the missing Title from Figma
            Text(
              "What is Your Mother Language",
              style: TextStyle(
                fontSize: 2.8.h,
                fontWeight: FontWeight.w700,
                color: AllThemes.blackColor,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              "Discover what is a podcast description and\npodcast summary.",
              style: TextStyle(
                fontSize: 1.8.h,
                color: AllThemes.greyColor,
              ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: ListView.builder(
            itemCount: profileController.languages.length,
              itemBuilder: (context, index) {
               return Obx((){
                 final language = profileController.languages[index];
                 final isSelected = profileController.selectedIndex.value == index;
                 return AnimatedContainer(
                   duration: const Duration(milliseconds: 300),
                   margin: EdgeInsets.only(bottom: 2.h),
                   padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                   decoration: BoxDecoration(
                     color: AllThemes.whiteColor,
                     borderRadius: BorderRadius.circular(20),
                     boxShadow: isSelected
                         ? [
                       BoxShadow(
                         color: AllThemes.greyColor.withOpacity(0.15),
                         blurRadius: 15,
                         offset: const Offset(0, 8),
                       )
                     ]
                         : [],
                   ),
                   child: GestureDetector(
                     onTap: ()=>profileController.changeSelection(index),
                     child: Row(
                       children: [
                         // For Flags
                         CircleAvatar(
                           radius: 2.5.h,
                           backgroundColor: AllThemes.greyColor.withOpacity(0.1),
                           backgroundImage: AssetImage(language['flag']!),
                         ),
                         SizedBox(width: 4.w),

                         //Language Name
                         Text(
                           language['name']!,
                           style: TextStyle(
                             color: AllThemes.blackColor,
                             fontSize: 2.h,
                             fontWeight: FontWeight.w500,
                           ),
                         ),

                         const Spacer(),

                         // 3. Selection Button
                         GestureDetector(
                           onTap: () => profileController.changeSelection(index),
                           child: Container(
                             padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                             decoration: BoxDecoration(
                               color: isSelected
                                   ? AllThemes.blueColor
                                   : AllThemes.greyColor.withOpacity(0.08),
                               borderRadius: BorderRadius.circular(12),
                             ),
                             child: Row(
                               children: [
                                 if (isSelected) ...[
                                   Icon(Icons.check, color: Colors.white, size: 1.8.h),
                                   SizedBox(width: 1.5.w),
                                 ],
                                 Text(
                                   isSelected ? "Selected" : "Select",
                                   style: TextStyle(
                                     color: isSelected ? Colors.white : Colors.grey,
                                     fontWeight: FontWeight.w600,
                                     fontSize: 1.6.h,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 );
                });
              },
            ),
            ),
            SizedBox(height: 1.h),
            //Continue button
            CustomButton(
              onTap: (){
                Get.to(()=>Setprofile(),duration: Duration(milliseconds: 500),
                  transition: Transition.fade,curve: Curves.easeIn,
                );
              },
              color: AllThemes.blueColor, label: 'Continue',
            labelColor: AllThemes.whiteColor,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}