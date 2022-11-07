import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CustomerContactWidget extends StatelessWidget {
  final OrderModel orderModel;
  const CustomerContactWidget({Key key, this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
      margin: EdgeInsets.only(left: 5, right: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),

      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(getTranslated('customer_contact_details', context),
            style: titilliumSemiBold.copyWith(color: ColorResources.titleColor(context),
              fontSize: Dimensions.FONT_SIZE_LARGE,)),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


        Row(children: [ClipRRect(borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
              placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
              imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                  '${orderModel.customer.image}',
              height: 50,width: 50, fit: BoxFit.cover),),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),


          Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${orderModel.customer.fName ?? ''} '
                '${orderModel.customer.lName ?? ''}',
                style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                    fontSize: Dimensions.FONT_SIZE_DEFAULT)),


            Text('${getTranslated('email', context)} : '
                '${orderModel.customer.email ?? ''}',
                style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                    fontSize: Dimensions.FONT_SIZE_DEFAULT)),


            Text('${getTranslated('contact', context)} : ${orderModel.customer.phone}',
                style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                    fontSize: Dimensions.FONT_SIZE_DEFAULT)),],))
        ],
        )
      ]),
    );
  }
}
