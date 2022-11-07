import 'dart:io';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_pass_textfeild.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';
import 'package:sixvalley_vendor_app/view/screens/forgetPassword/widget/code_picker_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/more/html_view_screen.dart';



class InfoFieldVIew extends StatefulWidget {
  
  final bool isShopInfo;
  const InfoFieldVIew({Key key, this.isShopInfo = false}) : super(key: key);

  @override
  State<InfoFieldVIew> createState() => _InfoFieldVIewState();
}

class _InfoFieldVIewState extends State<InfoFieldVIew> {
  String _countryDialCode = "+880";
  String currency = '',  country = '', selectedTimeZone = '';
  @override
  void initState() {
    super.initState();
    _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (authContext, authProvider, _) {
        return SingleChildScrollView(
          child: Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              if(!widget.isShopInfo) Container(child: Column(children: [
                Container(margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE,
                    bottom: Dimensions.PADDING_SIZE_SMALL),
                    child: CustomTextField(
                      border: true,
                      hintText: getTranslated('first_name', context),
                      focusNode: authProvider.firstNameNode,
                      nextNode: authProvider.lastNameNode,
                      textInputType: TextInputType.name,
                      controller: authProvider.firstNameController,
                      textInputAction: TextInputAction.next,
                    )),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Container(margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE,
                    bottom: Dimensions.PADDING_SIZE_SMALL),
                    child: CustomTextField(
                      border: true,
                      hintText: getTranslated('last_name', context),
                      focusNode: authProvider.lastNameNode,
                      nextNode: authProvider.emailNode,
                      textInputType: TextInputType.name,
                      controller: authProvider.lastNameController,
                      textInputAction: TextInputAction.next,
                    )),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                Container(margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE,
                    bottom: Dimensions.PADDING_SIZE_SMALL),
                    child: CustomTextField(
                      border: true,
                      hintText: getTranslated('email_address', context),
                      focusNode: authProvider.emailNode,
                      nextNode: authProvider.phoneNode,
                      textInputType: TextInputType.name,
                      controller: authProvider.emailController,
                      textInputAction: TextInputAction.next,
                    )),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Container(
                  margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT,
                      right: Dimensions.PADDING_SIZE_DEFAULT, top: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(children: [
                    CodePickerWidget(
                      onChanged: (CountryCode countryCode) {
                        _countryDialCode = countryCode.dialCode;
                      },
                      initialSelection: _countryDialCode,
                      favorite: [_countryDialCode],
                      showDropDownButton: true,
                      padding: EdgeInsets.zero,
                      showFlagMain: true,
                      textStyle: TextStyle(color: Theme.of(context).textTheme.headline1.color),

                    ),



                    Expanded(child: CustomTextField(
                      hintText: getTranslated('ENTER_MOBILE_NUMBER', context),
                      controller: authProvider.phoneController,
                      focusNode: authProvider.phoneNode,
                      nextNode: authProvider.passwordNode,
                      isPhoneNumber: true,
                      border: true,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.phone,

                    )),
                  ]),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(
                    children: [
                      Text(getTranslated('password', context),style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                    ],
                  ),
                ),

                Container(margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE,
                    right: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_DEFAULT),
                    child: CustomPasswordTextField(
                      border: true,
                      hintTxt: getTranslated('password_hint', context),
                      textInputAction: TextInputAction.next,
                      focusNode: authProvider.passwordNode,
                      nextNode: authProvider.confirmPasswordNode,
                      controller: authProvider.passwordController,
                    )),


                Padding(
                  padding: const EdgeInsets.fromLTRB( Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(
                    children: [
                      Text(getTranslated('confirm_password', context),style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                    ],
                  ),
                ),
                Container(margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE,
                    right: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_DEFAULT),
                    child: CustomPasswordTextField(
                      border: true,
                      hintTxt: getTranslated('password_hint', context),
                      textInputAction: TextInputAction.done,
                      focusNode: authProvider.confirmPasswordNode,
                      controller: authProvider.confirmPasswordController,
                    )),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                Padding(
                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE,
                      right: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(
                    children: [
                      Text(getTranslated('upload_image', context),
                          style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                      Text('(${getTranslated('seller_profile', context)})',
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Align(alignment: Alignment.center, child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                    child: authProvider.sellerProfileImage != null ?  Image.file(File(authProvider.sellerProfileImage.path),
                      width: 150, height: 120, fit: BoxFit.cover,
                    ) :Image.asset(Images.placeholder_image,height: 120,
                      width: 150, fit: BoxFit.cover,),
                  ),
                  Positioned(
                    bottom: 0, right: 0, top: 0, left: 0,
                    child: InkWell(
                      onTap: () => authProvider.pickImage(true,false, false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ])),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              ],)),



              if(widget.isShopInfo)Container(child: Column(children: [
                Container(margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE,
                    bottom: Dimensions.PADDING_SIZE_SMALL),
                    child: CustomTextField(
                      border: true,
                      hintText: getTranslated('shop_name', context),
                      focusNode: authProvider.shopNameNode,
                      nextNode: authProvider.shopAddressNode,
                      textInputType: TextInputType.name,
                      controller: authProvider.shopNameController,
                      textInputAction: TextInputAction.next,
                    )),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                Container(margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE,
                    bottom: Dimensions.PADDING_SIZE_SMALL),
                    child: CustomTextField(
                      border: true,
                      hintText: getTranslated('shop_address', context),
                      focusNode: authProvider.shopAddressNode,
                      textInputType: TextInputType.name,
                      controller: authProvider.shopAddressController,
                      textInputAction: TextInputAction.done,
                    )),
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                Padding(
                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE,
                      right: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(
                    children: [
                      Text(getTranslated('upload_image', context),
                          style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                      Text('(${getTranslated('business_or_shop_logo', context)})',
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Align(alignment: Alignment.center, child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                    child: authProvider.shopLogo != null ?  Image.file(File(authProvider.shopLogo.path),
                      width: 150, height: 120, fit: BoxFit.cover,
                    ) :Image.asset(Images.placeholder_image,height: 120,
                      width: 150, fit: BoxFit.cover,),
                  ),
                  Positioned(
                    bottom: 0, right: 0, top: 0, left: 0,
                    child: InkWell(
                      onTap: () => authProvider.pickImage(false,true, false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ])),


                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE,
                      right: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(
                    children: [
                      Text(getTranslated('upload_image', context),
                          style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                      Text('(${getTranslated('business_or_shop_banner', context)})',
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Align(alignment: Alignment.center, child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                    child: authProvider.shopBanner != null ?  Image.file(File(authProvider.shopBanner.path),
                      width: 250, height: 120, fit: BoxFit.cover,
                    ) :Image.asset(Images.placeholder_image,height: 120,
                      width: 250, fit: BoxFit.cover,),
                  ),
                  Positioned(
                    bottom: 0, right: 0, top: 0, left: 0,
                    child: InkWell(
                      onTap: () => authProvider.pickImage(false,false, false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ])),

                Container(
                  margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Row(children: [
                      Consumer<AuthProvider>(
                          builder: (context, authProvider, child) => Checkbox(
                              checkColor: ColorResources.WHITE,
                              activeColor: Theme.of(context).primaryColor,
                              value: authProvider.isTermsAndCondition,
                              onChanged: authProvider.updateTermsAndCondition)),

                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_) => HtmlViewScreen(
                            title: getTranslated('terms_and_condition', context),
                            url: Provider.of<SplashProvider>(context, listen: false).configModel.termsConditions,
                          )));
                        },
                          child: Row(
                            children: [
                              Text(getTranslated('i_agree_to_your', context)),
                              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Text(getTranslated('terms_and_condition', context),style: robotoMedium),
                            ],
                          )),
                    ],),

                    ],
                  ),
                ),
              ],),)


            ],
          ),
        );
      }
    );
  }
}
