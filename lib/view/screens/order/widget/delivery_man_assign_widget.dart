import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/delivery_man_provider.dart';
import 'package:sixvalley_vendor_app/provider/shipping_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/custom_divider.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';

class DeliveryManAssignWidget extends StatefulWidget {
  final int orderId;
  final String orderType;
  final OrderModel orderModel;
  const DeliveryManAssignWidget({Key key, this.orderType, this.orderModel, this.orderId}) : super(key: key);

  @override
  State<DeliveryManAssignWidget> createState() => _DeliveryManAssignWidgetState();
}

class _DeliveryManAssignWidgetState extends State<DeliveryManAssignWidget> {


  TextEditingController _thirdPartyShippingNameController = TextEditingController();
  TextEditingController _thirdPartyShippingIdController = TextEditingController();
  FocusNode _thirdPartyShippingNameNode = FocusNode();
  FocusNode _thirdPartyShippingIdNode = FocusNode();
  String deliveryType = 'select delivery type';

  @override
  void initState() {
    if(widget.orderModel.thirdPartyServiceName!=null){
      _thirdPartyShippingNameController.text = widget.orderModel.thirdPartyServiceName;
    }
    if(widget.orderModel.thirdPartyTrackingId!=null){
      _thirdPartyShippingIdController.text = widget.orderModel.thirdPartyTrackingId;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [
      Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod =='sellerwise_shipping' && widget.orderType != 'POS'?
      Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getTranslated('shipping_info', context), style: robotoBold,),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
          Container(
            child: Container( padding: EdgeInsets.symmetric(horizontal:Dimensions.FONT_SIZE_EXTRA_SMALL ),
                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                    border: Border.all(width: .5,color: Theme.of(context).hintColor.withOpacity(.5)),
                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                child: DropdownButton<String>(
                  value: deliveryType,
                  isExpanded: true,
                  underline: SizedBox(),
                  onChanged: (String newValue) {
                    setState(() {
                      deliveryType = newValue;

                      print('======dd========$deliveryType ===========>${widget.orderModel.deliveryType}');

                    });
                  },
                  items: <String>['select delivery type', getTranslated('by_self_delivery_man', context),
                    getTranslated('by_third_party_delivery_service', context)]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
            ),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),





          deliveryType == getTranslated('by_self_delivery_man', context) || widget.orderModel.deliveryType == 'self_delivery'?
          Padding(padding: const EdgeInsets.only(bottom: 20.0),
            child: widget.orderType == 'POS'? SizedBox(): Consumer<DeliveryManProvider>(builder: (context, deliveryMan, child) {
              return Row(children: [Expanded(child: Container(
                padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL, right: Dimensions.PADDING_SIZE_SMALL,),
                decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                  border: Border.all(width: .5,color: Theme.of(context).hintColor.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),),
                alignment: Alignment.center,
                child: DropdownButtonFormField<int>(
                  value: deliveryMan.deliveryManIndex,
                  isExpanded: true,
                  decoration: InputDecoration(border: InputBorder.none),
                  iconSize: 24, elevation: 16, style: titilliumRegular,
                  items: deliveryMan.deliveryManIds.map((int value) {
                    return DropdownMenuItem<int>(
                      value: deliveryMan.deliveryManIds.indexOf(value),
                      child: Text(value != 0?
                      '${deliveryMan.deliveryManList[(deliveryMan.deliveryManIds.indexOf(value) -1)].fName} '
                          '${deliveryMan.deliveryManList[(deliveryMan.deliveryManIds.indexOf(value) -1)].lName}':
                      getTranslated('select_delivery_man', context),
                        style: TextStyle(color: ColorResources.getTextColor(context)),),);
                  }).toList(),
                  onChanged: (int value) {
                    deliveryMan.setDeliverymanIndex(value, true);
                    deliveryMan.assignDeliveryMan(context,widget.orderId, deliveryMan.deliveryManList[value-1].id);
                  },
                ),),),],);}),) :


          deliveryType == 'By third party delivery service' || widget.orderModel.deliveryType == "third_party_delivery" || deliveryType == getTranslated('by_third_party_delivery_service', context)?
          Padding(padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
              children: [Container(child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated('third_party_delivery_service', context),
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                  CustomTextField(
                    border: true,
                    hintText: 'Ex: xyz service',
                    controller: _thirdPartyShippingNameController,
                    focusNode: _thirdPartyShippingNameNode,
                    nextNode: _thirdPartyShippingIdNode,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.name,
                    isAmount: false,
                  ),],),),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated('third_party_delivery_tracking_id', context),
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                        color: Theme.of(context).disabledColor),),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  CustomTextField(
                    hintText: 'Ex: xyz-12345678',
                    border: true,
                    controller: _thirdPartyShippingIdController,
                    focusNode: _thirdPartyShippingIdNode,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    isAmount: false,
                  ),
                ],),),
              ],),),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                Consumer<ShippingProvider>(
                    builder: (context, shipping,_) {
                      return Container( width: 120,
                        child: CustomButton(btnTxt: getTranslated('add', context), onTap: (){
                          String serviceName =_thirdPartyShippingNameController.text.trim().toString();
                          String trackingId =_thirdPartyShippingIdController.text.trim().toString();
                          if(serviceName.isEmpty){
                            showCustomSnackBar(getTranslated('delivery_service_provider_name_required',context), context);
                          } else{
                            shipping.isLoading? CircularProgressIndicator(color: Theme.of(context).primaryColor) :
                            Provider.of<ShippingProvider>(context,listen: false).assignThirdPartyDeliveryMan(context,
                                serviceName, trackingId, widget.orderModel.id);
                          }},),
                      );
                    }
                )
              ],
            ),
          ):SizedBox(),
        ],
      ):SizedBox(),
      Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod =='sellerwise_shipping' && widget.orderType != 'POS'?
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT),
        child: CustomDivider(),
      ):SizedBox.shrink(),
    ]));
  }
}
