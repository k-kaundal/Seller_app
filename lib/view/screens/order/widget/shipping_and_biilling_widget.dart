import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class ShippingAndBillingWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool onlyDigital;
  const ShippingAndBillingWidget({Key key, this.orderModel, this.onlyDigital}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(left: 5, right: 5,),
      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [



        if(!onlyDigital)Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(getTranslated('shipping_details', context),
                style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                  color: ColorResources.titleColor(context),)),

            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

            Text('${getTranslated('name', context)} : ''${orderModel.customer != null? orderModel.customer.fName ?? '': ""}' ' '
                '${orderModel.customer != null? orderModel.customer.lName ?? '':""}',
              style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context)),),




            Text('${getTranslated('address', context)} : ''${orderModel.shippingAddressData != null ?
            jsonDecode(orderModel.shippingAddressData)['address']  :
            orderModel.shippingAddress ?? ''}',
                style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),


            Text('${getTranslated('phone', context)} : ''${orderModel.shippingAddressData != null ?
            jsonDecode(orderModel.shippingAddressData)['phone']  : orderModel.shippingAddress ?? ''}',
                style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),

            Text('${getTranslated('zip_code', context)} : ''${orderModel.shippingAddressData != null ?
            jsonDecode(orderModel.shippingAddressData)['zip']  :
            orderModel.shippingAddress ?? ''}', style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),


            Text('${getTranslated('city', context)} : ''${orderModel.shippingAddressData != null ?
            jsonDecode(orderModel.shippingAddressData)['city']  :
            orderModel.shippingAddress ?? ''}', style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),


          ],
        ),),

        Text(getTranslated('billing_address', context), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
              color: ColorResources.titleColor(context),)),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


        Text('${getTranslated('name', context)} : ''${orderModel.billingAddressData != null ?
        orderModel.billingAddressData.contactPersonName :
        orderModel.billingAddress ?? ''}', style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),


        Text('${getTranslated('billing_address', context)} : ''${orderModel.billingAddressData != null ?
        orderModel.billingAddressData.address :
        orderModel.billingAddress ?? ''}', style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),



        Text('${getTranslated('phone', context)} : ''${orderModel.customer != null?
        orderModel.customer.phone ?? '':""}', style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),

        Text('${getTranslated('zip_code', context)} : ''${orderModel.billingAddressData != null?
        orderModel.billingAddressData.zip ?? '':""}', style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),

        Text('${getTranslated('city', context)} : ''${orderModel.customer != null?
        orderModel.billingAddressData != null ? orderModel.billingAddressData.city : '' : ''}',
            style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),



        Text(getTranslated('order_note', context), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
              color: ColorResources.titleColor(context),)),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        Text('${getTranslated('order_note', context)} : ''${orderModel.orderNote != null? orderModel.orderNote ?? '': ""}',
            style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),

      ]),
    );
  }
}
