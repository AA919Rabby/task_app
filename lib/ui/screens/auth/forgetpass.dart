import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/all_themes.dart';
import '../../../core/sizes.dart';
import '../../logic/forgetpass_controller.dart';
import '../../widgets/custom_auth.dart';
import '../../widgets/custom_buttom.dart';



class Forgetpass extends StatelessWidget {
  Forgetpass({super.key});
  final forgetpassController=Get.put(ForgetpassController());
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
            onTap: () => Get.back(),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Form(
            key: forgetpassController.resetPassEmailGlobalKey,
            child: Column(
              children: [
                Text(
                  "Forgot Password",
                  style: GoogleFonts.inter(
                    fontSize: 3.8.h,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Enter your email, we will send a\nverification code to email",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 1.8.h,
                    color: AllThemes.greyColor,
                  ),
                ),

                SizedBox(height: 5.5.h),
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
                    controller: forgetpassController.resetPassEmail,
                    hintText: "pristia@gmail.com"),

                SizedBox(height: 6.7.h),
                //send in button TODO

                Obx(()=> forgetpassController.isLoading.value?
                Center(
                  child:SpinKitFadingCircle(
                    color: AllThemes.blueColor,
                    size: 10.w,
                  ),
                )
                    :CustomButton(
                  onTap: (){
                    if(forgetpassController.resetPassEmailGlobalKey.currentState!.validate()){
                      forgetpassController.forgetPassSendOtp();
                    }
                  },
                  color: AllThemes.blueColor, label: "Continue",
                  labelColor: AllThemes.whiteColor,
                ),),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
