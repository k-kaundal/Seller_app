import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/delivery_man_provider.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_divider.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/order/widget/customer_contact_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/order/widget/delivery_man_assign_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/order/widget/order_product_list_item.dart';
import 'package:sixvalley_vendor_app/view/screens/order/widget/shipping_and_biilling_widget.dart';


class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  final int orderId;
  final String orderType;
  final String shippingType;
  final double extraDiscount;
  final String extraDiscountType;
  OrderDetailsScreen({this.orderModel, @required this.orderId, @required this.orderType, this.shippingType, this.extraDiscount, this.extraDiscountType});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _loadData(BuildContext context, String type) async {
    if(widget.orderModel == null) {
      await Provider.of<SplashProvider>(context, listen: false).initConfig(context);
    }
    Provider.of<OrderProvider>(context, listen: false).getOrderDetails(widget.orderId.toString(), context);
    Provider.of<OrderProvider>(context, listen: false).initOrderStatusList(context,
        Provider.of<SplashProvider>(context, listen: false).configModel.shippingMethod == 'inhouse_shipping' ?  'inhouse_shipping':"seller_wise");
    Provider.of<DeliveryManProvider>(context, listen: false).getDeliveryManList(widget.orderModel, context);
  }




  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false).setPaymentStatus(widget.orderModel.paymentStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    _loadData(context,widget.shippingType);
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('order_details', context)),

      body: RefreshIndicator(
        onRefresh: () async{
          _loadData(context,widget.shippingType);
          return true;
        },
        child: Consumer<OrderProvider>(
            builder: (context, order, child) {

              bool _onlyDigital = true;
              double _itemsPrice = 0;
              double _discount = 0;
              double eeDiscount = 0;
              double _coupon = widget.orderModel.discountAmount;
              double _tax = 0;
              double _shipping = widget.orderModel.shippingCost;
              if (order.orderDetails != null) {
                order.orderDetails.forEach((orderDetails) {
                  if(orderDetails.productDetails.productType == "physical"){
                    _onlyDigital =  false;
                  }
                  _itemsPrice = _itemsPrice + (orderDetails.price * orderDetails.qty);
                  _discount = _discount + orderDetails.discount;
                  _tax = _tax + orderDetails.tax ;
                });
              }
              double _subTotal = _itemsPrice +_tax - _discount;

              if(widget.orderType == 'POS'){
                if(widget.extraDiscountType == 'percent'){
                  eeDiscount = _itemsPrice * (widget.extraDiscount/100);
                }else{
                  eeDiscount = widget.extraDiscount;
                }
              }
              double _totalPrice = _subTotal + _shipping - _coupon - eeDiscount;

              return order.orderDetails != null ? order.orderDetails.length > 0 ?
              ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL, right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        bottom: Dimensions.PADDING_SIZE_DEFAULT),
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_DEFAULT),

                    child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [



                      //assign delivery man
                      !_onlyDigital?
                     DeliveryManAssignWidget(orderType: widget.orderType,orderModel: widget.orderModel,orderId: widget.orderId):SizedBox(),



                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${getTranslated('order_no', context)}#${widget.orderModel.id}',
                          style: titilliumSemiBold.copyWith(color: ColorResources.titleColor(context),
                              fontSize: Dimensions.FONT_SIZE_LARGE),),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,
                              vertical: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(color: ColorResources.mainCardThreeColor(context).withOpacity(.085),
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE),),
                          child: Center(child: Text(getTranslated('${widget.orderModel.orderStatus}', context),
                                style: titilliumRegular.copyWith(color: ColorResources.mainCardThreeColor(context))),
                          ),),]),



                      Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(widget.orderModel.createdAt)),
                          style: titilliumRegular.copyWith(color: ColorResources.getHint(context),
                              fontSize: Dimensions.FONT_SIZE_SMALL)),

                      widget.orderType != 'POS'?
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT),
                        child: CustomDivider(),
                      ):SizedBox.shrink(),





                      widget.orderType != 'POS'?
                      Row(children: [
                        Text( '${getTranslated('payment_method', context)}:',
                          style: titilliumSemiBold.copyWith(color: ColorResources.getTextColor(context),
                              fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                          Text((widget.orderModel.paymentMethod != null && widget.orderModel.paymentMethod.length > 0) ?
                          '${widget.orderModel.paymentMethod[0]}${widget.orderModel.paymentMethod.substring(1).replaceAll('_', ' ')}' :
                          'Digital Payment', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                        Expanded(child: SizedBox()),

                        Row( mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [

                          Builder(
                            builder: (context) {
                              return FlutterSwitch(width: 100.0, height: 35.0, toggleSize: 30.0,
                                value: order.paymentStatus == 'paid',
                                borderRadius: 25.0,
                                activeColor: Theme.of(context).primaryColor,
                                activeText: 'paid',
                                inactiveText: 'unpaid',
                                padding: 5.0,
                                activeTextFontWeight: FontWeight.w400,
                                inactiveTextFontWeight: FontWeight.w400,
                                showOnOff: true,
                                onToggle:(bool isActive) {
                                print('==status==>${order.paymentStatus}');
                                  order.updatePaymentStatus(orderId: widget.orderId,
                                      status:order.paymentStatus == 'paid' ?'unpaid':'paid',context: context);
                                }
                              );
                            }
                          ),
                          ],)
                      ],
                      ):SizedBox.shrink(),

                      SizedBox(height: widget.orderType != 'POS'? Dimensions.PADDING_SIZE_DEFAULT : 0),
                      widget.orderType != 'POS'? CustomDivider():SizedBox.shrink(),

                    ]),
                  ),


                  widget.orderType == 'POS'? SizedBox():
                  ShippingAndBillingWidget(orderModel: widget.orderModel, onlyDigital: _onlyDigital),

                  widget.orderType != 'POS'?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: CustomDivider(),
                  ):SizedBox.shrink(),

                  Container(margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      bottom: Dimensions.PADDING_SIZE_DEFAULT),
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(getTranslated('order_summery', context),
                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                        color: ColorResources.titleColor(context),) ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),



                      ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: order.orderDetails.length,
                        itemBuilder: (context, index) {
                          return OrderedProductListItem(orderDetailsModel: order.orderDetails[index], paymentStatus: order.paymentStatus,orderId: widget.orderId);
                        },
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                      // Total
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(getTranslated('sub_total', context),
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),


                        Text(PriceConverter.convertPrice(context, _itemsPrice),
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),]),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),



                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(getTranslated('tax', context),
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),


                        Text('+ ${PriceConverter.convertPrice(context, _tax)}',
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),]),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),




                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(getTranslated('discount', context),
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),


                        Text('- ${PriceConverter.convertPrice(context, _discount)}',
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),]),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),



                      widget.orderType == "POS"?
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(getTranslated('extra_discount', context),
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),
                        Text('- ${PriceConverter.convertPrice(context, eeDiscount)}',
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),
                      ]):SizedBox(),
                      SizedBox(height:  widget.orderType == "POS"? Dimensions.PADDING_SIZE_SMALL: 0),


                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(getTranslated('coupon_discount', context),
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),
                        Text('- ${PriceConverter.convertPrice(context, _coupon)}',
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),]),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),



                      if(!_onlyDigital)Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(getTranslated('shipping_fee', context),
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),
                        Text('+ ${PriceConverter.convertPrice(context, _shipping)}',
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: ColorResources.titleColor(context))),]),


                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomDivider(),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(getTranslated('total_amount', context),
                            style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                color: Theme.of(context).primaryColor)),
                        Text(PriceConverter.convertPrice(context, _totalPrice),
                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                              color: Theme.of(context).primaryColor),),]),

                    ]),
                  ),




                  widget.orderModel.customer != null?
                  CustomerContactWidget(orderModel: widget.orderModel):SizedBox(),


                ],
              ) : NoDataScreen() : Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
            }
        ),
      ),

      bottomNavigationBar: widget.orderType =='POS'? SizedBox.shrink():
      Consumer<OrderProvider>(
        builder: (context, order, _) {
          return Container(height: 85,
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

              order.isLoading ?
              Center(child: CircularProgressIndicator(key: Key(''),
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) :

              Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Consumer<OrderProvider>(builder: (context, order, child) {
                  return Row(mainAxisAlignment:MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,children: [

                    Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                      child: Container(height: 50,
                        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL,
                        right: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.5))
                        ),
                        alignment: Alignment.center,
                        child: DropdownButtonFormField<String>(
                          value: order.orderStatusType,
                          isExpanded: true,
                          decoration: InputDecoration(border: InputBorder.none),
                          iconSize: 24, elevation: 16, style: titilliumRegular,
                          onChanged: order.updateStatus,
                          items: order.orderStatusList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(getTranslated(value, context), style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.bodyText1.color)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),


                    Align(alignment: Alignment.bottomRight,
                      child: InkWell(onTap: () async {
                        if(order.orderStatusType == order.orderStatusList[0]) {
                          ScaffoldMessenger.of(c).showSnackBar(SnackBar(
                            content: Text(getTranslated('select_order_status', context)),
                            backgroundColor: Colors.red,));
                        }else {order.setOrderStatusErrorText('');
                        List<int> _productIds = [];
                        order.orderDetails.forEach((orderDetails) {
                          _productIds.add(orderDetails.id);
                        });
                        if(widget.orderModel.customer != null) {
                          await order.updateOrderStatus(widget.orderModel.id, order.orderStatusType,context).then((value) {
                            if(value.response.statusCode==200){

                            }
                          });
                        }else{
                          showCustomSnackBar(getTranslated('customer_account_was_deleted_you_cant_update_status', context), context);
                        }
                        }},

                          child: Container(height: 50,
                              decoration: BoxDecoration(color: ColorResources.getPrimary(context),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  child: Text(getTranslated('change_status', context),
                                    style: titilliumSemiBold.copyWith(color: Theme.of(context).cardColor),),
                                ),
                              ))),
                    ),
                  ],);}),),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE)
          ],),
            ),);
        }
      ),
    );
  }
}
