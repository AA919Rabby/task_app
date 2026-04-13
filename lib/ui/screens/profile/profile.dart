import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';
import '../../logic/auth_controller.dart';
import '../../logic/profile_controller.dart';


class Profile extends StatelessWidget {
  Profile({super.key});
  final authController=Get.put(AuthController());
  final profileController=Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AllThemes.whiteColor,
      appBar: AppBar(
        backgroundColor: AllThemes.noColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            fontSize: 2.8.h,
            fontWeight: FontWeight.w700,
            color: AllThemes.blackColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 4.h),

          // Profile Image Section
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Obx(() {
                  return Container(
                    height: 15.h,
                    width: 15.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AllThemes.greyColor.withOpacity(0.1),
                      image: DecorationImage(
                        image: profileController.selectedImage.value.isNotEmpty
                            ? FileImage(File(profileController.selectedImage.value)) as ImageProvider
                            : const AssetImage('assets/profile/person.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
                // Edit Icon Badge
                Positioned(
                  bottom: 0.5.h,
                  right: 0.5.h,
                  child: Container(
                    height: 4.h,
                    width: 4.h,
                    decoration: BoxDecoration(
                      color: AllThemes.blueColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AllThemes.whiteColor, width: 2),
                    ),
                    child: Image.asset('assets/profile/edit.jpg',color: AllThemes.whiteColor,),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // User Name
          Text(
            'Wade Warren', // Hardcoded to match Figma
            style: GoogleFonts.inter(
              fontSize: 2.6.h,
              fontWeight: FontWeight.w600,
              color: AllThemes.blackColor,
            ),
          ),

          SizedBox(height: 4.h),
          Divider(color: AllThemes.greyColor.withOpacity(0.2), height: 1),

          // Menu Options
          _buildMenuOption(
            iconAsset: 'assets/profile/edit.jpg',
            title: 'Edit Profile',
            onTap: () {},
          ),
          Divider(color: AllThemes.greyColor.withOpacity(0.2), height: 1),

          _buildMenuOption(
            iconAsset: 'assets/profile/support.jpg',
            title: 'Support',
            onTap: () {},
          ),
          Divider(color: AllThemes.greyColor.withOpacity(0.2), height: 1),

          _buildMenuOption(
            iconAsset: 'assets/profile/privacy.jpg',
            title: 'Privacy',
            onTap: () {},
          ),
          Divider(color: AllThemes.greyColor.withOpacity(0.2), height: 1),

          // Logout Option with Orange Text
          _buildMenuOption(
            iconAsset: 'assets/profile/logout.jpg',
            title: 'Logout',
            textColor: AllThemes.orangeColor,
            onTap: () {
              // Add logout logic here later
            },
          ),
          Divider(color: AllThemes.greyColor.withOpacity(0.2), height: 1),
        ],
      ),
    );
  }
  // Reusable widget for Menu List items
   _buildMenuOption({
    required String iconAsset,
    required String title,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
        child: Row(
          children: [
            Image.asset(
              iconAsset,
              height: 3.h,
              width: 3.h,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 2.1.h,
                fontWeight: FontWeight.w500,
                color: textColor ?? AllThemes.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
