import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/core/all_themes.dart';
import 'package:task/ui/widgets/custom_auth.dart';
import 'package:task/ui/widgets/custom_buttom.dart';
import '../../../core/sizes.dart';
import '../../logic/auth_controller.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  final authController = Get.put(AuthController());

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
                padding: EdgeInsets.only(left: 10),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        child: Form(
          key: authController.signUpGlobalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to Eduline",
                style: GoogleFonts.inter(
                  fontSize: 3.5.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "Let’s join to Eduline learning ecosystem & meet\nour professional mentor. It’s Free!",
                style: GoogleFonts.inter(
                  fontSize: 1.8.h,
                  color: AllThemes.greyColor,
                ),
              ),
              SizedBox(height: 4.3.h),
              Text(
                "Email Address",
                style: GoogleFonts.inter(
                  fontSize: 1.8.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              //Email field
              CustomAuth(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Required";
                    }if(!GetUtils.isEmail(value)){
                      return "Invalid email";
                    }
                    return null;
                  },
                  controller: authController.signUpEmailClt,
                  hintText: "pristia@gmail.com"),
              SizedBox(height: 2.h),
              Text(
                "Full Name",
                style: GoogleFonts.inter(
                  fontSize: 1.8.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              //Name field
              CustomAuth(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Required";
                    }
                    return null;
                  },
                  controller: authController.signUpFullNameClt,
                  hintText: "Pristia Candra"),
              SizedBox(height: 2.h),
              Text(
                "Password",
                style: GoogleFonts.inter(
                  fontSize: 1.8.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Obx(
                   //Password field
                    () => CustomAuth(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Required";
                        }if(value.length<8){
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                  controller: authController.signUpPasswordClt,
                  hintText: "••••••••",
                  onChanged: (val) => authController.validatePassword(val),
                  obscureText: authController.isSignUpObscure.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      authController.isSignUpObscure.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 2.5.h,
                    ),
                    onPressed: () => authController.toggleSignUpVisibility(),
                  ),
                ),
              ),

              // Strength Bars + Strength Text
              SizedBox(height: 1.5.h),
              Obx(() => Row(
                children: [
                  ...List.generate(
                    4,
                        (i) => Expanded(
                      child: Container(
                        height: 0.5.h,
                        margin: EdgeInsets.only(right: 1.w),
                        decoration: BoxDecoration(
                          color: i < authController.passwordStrength.value
                              ? authController.strengthColor.value
                              : AllThemes.greyColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    authController.strengthText.value,
                    style: GoogleFonts.inter(
                      fontSize: 1.5.h,
                      color: authController.strengthColor.value,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),

              //  Row (Check/Close Icon)
              SizedBox(height: 1.5.h),
              Obx(() {
                bool isEmpty = authController.signUpPasswordClt.text.isEmpty;
                bool isMet = authController.isRequirementMet.value;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isMet ? Icons.check_circle_outline : (isEmpty ?
                      Icons.check_circle_outline : Icons.highlight_off),
                      color: isMet ? AllThemes.greenColor : (isEmpty ?
                      AllThemes.greenColor : AllThemes.redColor),
                      size: 2.h,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        "At least 8 characters with a combination of letters\nand numbers",
                        style: GoogleFonts.inter(
                          fontSize: 1.4.h,
                          color: isMet ? AllThemes.greenColor : (isEmpty ? AllThemes.greenColor : AllThemes.redColor),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: 5.h),
              //Sign up button TODO
              Obx(()=>authController.isLoading.value?
              Center(
                child:SpinKitFadingCircle(
                  color: AllThemes.blueColor,
                  size: 10.w,
                ),
                ):CustomButton(
                onTap: (){
                  if(authController.signUpGlobalKey.currentState!.validate()){
                    authController.SignUpUser();
                  }
                },
                color: AllThemes.blueColor,
                label: "Sign Up",
                labelColor: AllThemes.whiteColor,
              ),),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: GoogleFonts.inter(
                      fontSize: 1.8.h,
                      color: AllThemes.greyColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.inter(
                        fontSize: 1.8.h,
                        color: AllThemes.blueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}