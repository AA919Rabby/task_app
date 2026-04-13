import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/ui/screens/profile/profile.dart';
import 'package:task/ui/widgets/custom_auth.dart';
import 'package:task/ui/widgets/custom_buttom.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';
import '../../logic/profile_controller.dart';
import '../../widgets/custom_text.dart';
import '../home/home_view.dart';

class Setprofile extends StatelessWidget {
  Setprofile({super.key});
  final profileController = Get.put(ProfileController());

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
        centerTitle: true,
        title: Text(
          'Set Up Profile',
          style: GoogleFonts.inter(
            fontSize: 2.8.h,
            fontWeight: FontWeight.w700,
            color: AllThemes.blackColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Form(
            key: profileController.setProfileGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _showImagePicker(context),
                        child: Obx(() {
                          return profileController.selectedImage.value.isNotEmpty
                              ? Container(
                            height: 15.h,
                            width: 15.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(File(profileController
                                    .selectedImage.value)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                              : Image.asset(
                            'assets/profile/person.jpg',
                            height: 15.h,
                            width: 15.h,
                            fit: BoxFit.cover,
                          );
                        }),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Upload profile picture',
                        style: GoogleFonts.inter(
                          fontSize: 2.2.h,
                          fontWeight: FontWeight.w400,
                          color: AllThemes.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                // About Field
                Text("About",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 2.1.h)),
                SizedBox(height: 1.h),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  style: GoogleFonts.inter(
                    color: AllThemes.blackColor,
                    fontSize: 2.2.h,
                    fontWeight: FontWeight.w500,
                  ),
                  controller: profileController.setProfileAbout,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Tell us about yourself",
                    hintStyle: GoogleFonts.inter(
                      color: AllThemes.greyColor,
                      fontSize: 1.8.h,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1.5.h)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.3.h),
                      borderSide: BorderSide(
                          color: AllThemes.greyColor.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.3.h),
                      borderSide:
                      BorderSide(color: AllThemes.blueColor, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.3.h),
                      borderSide:
                      BorderSide(color: AllThemes.redColor, width: 1.5),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // Date of Birth
                Text("Date of Birth",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 2.1.h)),
                SizedBox(height: 1.h),
                CustomText(
                  controller: profileController.dateOfBirth,
                  hintText: 'DD/MM/YYYY',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9/-]')),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final dateRegExp = RegExp(r"^\d{2}[/-]\d{2}[/-]\d{4}$");
                    if (!dateRegExp.hasMatch(value)) {
                      return 'Use format DD/MM/YYYY';
                    }
                    try {
                      String sanitizedDate = value.replaceAll('-', '/');
                      List<String> parts = sanitizedDate.split('/');
                      int day = int.parse(parts[0]);
                      int month = int.parse(parts[1]);
                      int year = int.parse(parts[2]);

                      DateTime birthDate = DateTime(year, month, day);
                      DateTime today = DateTime.now();

                      if (birthDate.year != year ||
                          birthDate.month != month ||
                          birthDate.day != day) {
                        return 'Invalid date';
                      }

                      int age = today.year - birthDate.year;
                      if (today.month < birthDate.month ||
                          (today.month == birthDate.month &&
                              today.day < birthDate.day)) {
                        age--;
                      }

                      if (age < 18) return 'You must be at least 18 years old';
                      if (age > 120) return 'Please enter a valid year';
                      return null;
                    } catch (e) {
                      return 'Invalid date';
                    }
                  },
                  suffixIcon: Image.asset('assets/profile/date.jpg'),
                ),
                SizedBox(height: 2.h),

                // Gender Dropdown
                Text("Gender",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 2.1.h,
                        color: AllThemes.blackColor)),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.only(left: 4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.3.h),
                    border: Border.all(
                        color: AllThemes.greyColor.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Obx(() => DropdownButton<String>(
                      dropdownColor: AllThemes.whiteColor,
                      isExpanded: true,
                      focusColor: Colors.transparent,
                      value: profileController.selectedGender.value,
                      icon: Icon(Icons.arrow_drop_down_sharp, size: 4.h),
                      items:
                      ['Male', 'Female', 'Other'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: GoogleFonts.inter(fontSize: 2.h)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null)
                          profileController.updateGender(val);
                      },
                    )),
                  ),
                ),

                SizedBox(height: 4.h),
                CustomButton(
                  onTap: () async {
                    if (profileController.setProfileGlobalKey.currentState!
                        .validate()) {
                      bool isSaved = await profileController.saveProfile();
                      if (isSaved) {
                        showSuccessDialog(context);
                        await Future.delayed(const Duration(seconds: 3));
                        Get.offAll(() => HomeView(),duration: Duration(milliseconds: 500),
                          transition: Transition.fade,curve: Curves.easeIn,);
                      }
                    }
                  },
                  color: AllThemes.blueColor,
                  label: 'Next',
                  labelColor: AllThemes.whiteColor,
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Bottomsheet for open camera
  void _showImagePicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AllThemes.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.w),
            topRight: Radius.circular(5.w),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, size: 3.h),
                title: Text(
                  'Gallery',
                  style: GoogleFonts.inter(fontSize: 2.h),
                ),
                onTap: () {
                  profileController.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, size: 3.h),
                title: Text(
                  'Camera',
                  style: GoogleFonts.inter(fontSize: 2.h),
                ),
                onTap: () {
                  profileController.pickImage(ImageSource.camera);
                },
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Success Dialog
  showSuccessDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            backgroundColor: AllThemes.whiteColor,
            surfaceTintColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 1.h),
                  Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AllThemes.noColor,
                          ),
                          width: 35.w,
                          height: 27.w,
                          child: Image.asset("assets/profile/success.jpg",
                              height: 12.h),
                        ),
                      ]),
                  SizedBox(height: 2.h),
                  Text(
                    "Congratulations!",
                    style: GoogleFonts.inter(
                      fontSize: 3.h,
                      fontWeight: FontWeight.bold,
                      color: AllThemes.blackColor,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    "Your account is ready to use. You will be redirected to the home page in a few seconds",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 1.8.h,
                      color: AllThemes.greyColor,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  //Loading indicator
                  CupertinoActivityIndicator(
                    radius: 2.5.h,
                    color: AllThemes.indigoColor,
                  ),

                  SizedBox(height: 3.h),
                ],
              ),
            ),
          );
        });
  }
}