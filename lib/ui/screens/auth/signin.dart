import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task/ui/screens/auth/forgetpass.dart';
import 'package:task/ui/screens/auth/signup.dart';
import 'package:task/ui/widgets/custom_auth.dart';
import 'package:task/ui/widgets/custom_buttom.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';
import '../../logic/auth_controller.dart';


class Signin extends StatelessWidget {
  Signin({super.key});
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AllThemes.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Form(
            key: authController.signInGlobalKey, //For validation check
            child: Column(
              children: [
                SizedBox(height: 10.h),
                //LOGO
                Image.asset("assets/auth/logo.jpg", height: 12.h),
                SizedBox(height: 3.h),
                Text(
                  "Welcome Back!",
                  style: GoogleFonts.inter(
                    fontSize: 3.8.h,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Please login first to start your Theory Test.",
                  style: GoogleFonts.inter(
                    fontSize: 1.8.h,
                    color: AllThemes.greyColor,
                  ),
                ),

                SizedBox(height: 5.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email Address",
                    style: GoogleFonts.inter(
                      fontSize: 1.8.h,
                      fontWeight: FontWeight.w600,
                    ),
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
                    controller: authController.signInEmailClt,
                    hintText: "pristia@gmail.com"),

                SizedBox(height: 2.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: GoogleFonts.inter(
                      fontSize: 1.8.h,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Obx(
                  //Password field
                  () => CustomAuth(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Required";
                      }
                      return null;
                    },
                    controller: authController.signInPasswordClt,
                    hintText: "••••••••",
                    obscureText: authController.isObscure.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        authController.isObscure.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 2.5.h,
                      ),
                      onPressed: () => authController.toggleVisibility(),
                    ),
                  ),
                ),
                //Forget pass section TODO
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: authController.rememberMe.value,
                            activeColor: AllThemes.blueColor,
                            onChanged: (val) =>
                                authController.rememberMe.value = val!,
                          ),
                        ),
                        Text(
                          "Remember Me",
                          style: GoogleFonts.inter(fontSize: 1.6.h),
                        ),
                      ],
                    ),
                    Hero(
                      tag: 'pass',
                      child: Material(
                        color: AllThemes.noColor,
                        child: GestureDetector(
                          onTap: (){
                            Get.to(()=>Forgetpass(),duration: Duration(milliseconds: 500),
                              transition: Transition.fade,
                            );
                          },
                          child: Text(
                            "Forgot Password",
                            style: GoogleFonts.inter(
                              fontSize: 1.6.h,
                              color: AllThemes.greyColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),
                //Sign in button TODO

                Obx(()=> authController.isLoading.value?
                    Center(
                      child:SpinKitFadingCircle(
                        color: AllThemes.blueColor,
                        size: 10.w,
                      ),
                    )
                    :CustomButton(
                  onTap: (){
                    if(authController.signInGlobalKey.currentState!.validate()){
                      authController.signInUser();
                    }
                  },
                  color: AllThemes.blueColor, label: "Sign In",
                  labelColor: AllThemes.whiteColor,
                ),),

                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New to Theory Test? ",
                      style: GoogleFonts.inter(
                        fontSize: 1.8.h,
                        color: AllThemes.greyColor,
                      ),
                    ),
                    //Switch to signup
                    Hero(
                      tag: 'auth',
                      child: Material(
                        color: AllThemes.noColor,
                        child: GestureDetector(
                          onTap: (){
                            Get.to(()=>Signup(),duration: Duration(milliseconds: 500),
                            transition: Transition.fade,curve: Curves.ease,
                            );
                          },
                          child: Text(
                            "Create Account",
                            style: GoogleFonts.inter(
                              fontSize: 1.8.h,
                              color: AllThemes.blueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
