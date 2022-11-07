import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_details_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/provider/shop_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_divider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderedProductListItem extends StatefulWidget {
  final OrderDetailsModel orderDetailsModel;
  final String paymentStatus;
  final OrderModel orderModel;
  final int orderId;
  const OrderedProductListItem({Key key, this.orderDetailsModel, this.paymentStatus, this.orderModel, this.orderId}) : super(key: key);

  @override
  State<OrderedProductListItem> createState() => _OrderedProductListItemState();
}

class _OrderedProductListItemState extends State<OrderedProductListItem> {
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
  PlatformFile fileNamed;
  File file;
  int  fileSize;
  @override
  Widget build(BuildContext context) {
    return  Column( children: [
      Row(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: Dimensions.image_size,
          width: Dimensions.image_size, child: ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: FadeInImage.assetNetwork(
              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, fit: BoxFit.cover,),
              placeholder: Images.placeholder_image,
              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/'
                  '${widget.orderDetailsModel.productDetails.thumbnail}',
              height: Dimensions.image_size, width: Dimensions.image_size,
              fit: BoxFit.cover,),),),
          SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),


          Expanded(
            child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
              Text(widget.orderDetailsModel.productDetails.name,
                style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    color: ColorResources.getTextColor(context)),
                maxLines: 1, overflow: TextOverflow.ellipsis,),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),


              Row( children: [
                (widget.orderDetailsModel.productDetails.discount > 0 &&
                    widget.orderDetailsModel.productDetails.discount!= null)?
                Text(PriceConverter.convertPrice(context,
                    widget.orderDetailsModel.productDetails.unitPrice.toDouble()),
                  style: titilliumRegular.copyWith(color: ColorResources.mainCardFourColor(context),fontSize: Dimensions.FONT_SIZE_SMALL,
                      decoration: TextDecoration.lineThrough),):SizedBox(),
                SizedBox(width: widget.orderDetailsModel.productDetails.discount > 0?
                Dimensions.PADDING_SIZE_DEFAULT : 0),



                Text(PriceConverter.convertPrice(context,
                    widget.orderDetailsModel.productDetails.unitPrice.toDouble(),
                    discount :widget.orderDetailsModel.productDetails.discount,
                    discountType :widget.orderDetailsModel.productDetails.discountType),
                  style: titilliumSemiBold.copyWith(color: Theme.of(context).primaryColor),),


              ],),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Row(children: [
                Text(getTranslated('qty', context),
                    style: titilliumRegular.copyWith(color: Theme.of(context).hintColor)),

                Text(': ${widget.orderDetailsModel.qty}',
                    style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),],),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),


              (widget.orderDetailsModel.variant != null && widget.orderDetailsModel.variant.isNotEmpty) ?
              Padding(padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Text(widget.orderDetailsModel.variant,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: Theme.of(context).disabledColor,)),) : SizedBox(),
            ],),
          ),

        ],
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

      SizedBox(height: widget.orderDetailsModel.productDetails.productType =='digital' && widget.orderDetailsModel.productDetails.digitalProductType == 'ready_after_sell'?
      Dimensions.PADDING_SIZE_EXTRA_LARGE : 0),
      widget.orderDetailsModel.productDetails.productType =='digital' ?
      Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            return Row(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: InkWell(
                    onTap : () async {
                      if(widget.orderDetailsModel.productDetails.digitalProductType == 'ready_after_sell' &&
                          widget.orderDetailsModel.digitalFileAfterSell == null ){

                        Fluttertoast.showToast(
                            msg: getTranslated('product_not_uploaded_yet', context),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: Dimensions.FONT_SIZE_DEFAULT
                        );
                      }else{
                        widget.orderDetailsModel.productDetails.digitalProductType == 'ready_after_sell'?
                        _launchUrl(Uri.parse('${Provider.of<SplashProvider>(context, listen: false).baseUrls.digitalProductUrl}/${widget.orderDetailsModel.digitalFileAfterSell}')):
                        _launchUrl(Uri.parse('${Provider.of<SplashProvider>(context, listen: false).baseUrls.digitalProductUrl}/${widget.orderDetailsModel.productDetails.digitalFileReady}'));
                        // print('ios url click=====>${'${Provider.of<SplashProvider>(context, listen: false).baseUrls.digitalProductUrl}/${widget.orderDetailsModel.digitalFileAfterSell}'}');
                        // final status = await Permission.storage.request();
                        // if(status.isGranted){
                        //   Directory directory = Directory('/storage/emulated/0/Download');
                        //   if (!await directory.exists()) directory = Platform.isAndroid
                        //       ? await getExternalStorageDirectory()
                        //       : await getApplicationSupportDirectory();
                        //   orderProvider.downloadFile(
                        //       widget.orderDetailsModel.productDetails.digitalProductType == 'ready_after_sell'?
                        //       '${Provider.of<SplashProvider>(context, listen: false).baseUrls.digitalProductUrl}/${widget.orderDetailsModel.digitalFileAfterSell}':
                        //       '${Provider.of<SplashProvider>(context, listen: false).baseUrls.digitalProductUrl}/${widget.orderDetailsModel.productDetails.digitalFileReady}',
                        //       directory.path);
                        // }else{
                        //   print('=====permission denied=====');
                        // }
                      }

                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 5),
                      height: 38,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.FONT_SIZE_EXTRA_SMALL),
                          color: Theme.of(context).primaryColor
                      ),
                      alignment: Alignment.center,
                      child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${getTranslated('download', context)}',
                            style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,color: Theme.of(context).cardColor),),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Container(width: Dimensions.ICON_SIZE_DEFAULT,
                              child: Image.asset(Images.download_file, color: Theme.of(context).cardColor,))
                        ],
                      )),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                widget.orderDetailsModel.productDetails.digitalProductType == 'ready_after_sell'?
                Expanded(
                  child: Column(children: [
                    InkWell(
                      onTap: ()async{
                        FilePickerResult result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'zip', 'jpg', 'png', "jpeg", "gif"],
                        );
                        if (result != null) {
                          file = File(result.files.single.path);
                          fileSize = await file.length();
                          fileNamed = result.files.first;
                          orderProvider.setSelectedFileName(file);

                        } else {

                        }
                      },
                      child: Builder(
                          builder: (context) {
                            return Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                widget.orderDetailsModel.digitalFileAfterSell != null && fileNamed == null?
                                Text(widget.orderDetailsModel.digitalFileAfterSell, maxLines: 2,overflow: TextOverflow.ellipsis,
                                    style: robotoRegular.copyWith()):
                                Text(fileNamed != null? fileNamed.name??'':'',maxLines: 2,overflow: TextOverflow.ellipsis,
                                    style: robotoRegular.copyWith()),
                                fileNamed == null?
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  height: 38,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.FONT_SIZE_EXTRA_SMALL),

                                      color: Theme.of(context).primaryColor
                                  ),
                                  alignment: Alignment.center,
                                  child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${getTranslated('choose_file', context)}',
                                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,color: Theme.of(context).cardColor),),
                                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                      RotatedBox(
                                        quarterTurns:2,
                                        child: Container(width: Dimensions.ICON_SIZE_DEFAULT,
                                            child: Image.asset(Images.download_file, color: Theme.of(context).cardColor,)),
                                      )
                                    ],
                                  )),
                                ):SizedBox(),

                              ],);
                          }
                      ),
                    ),

                    fileNamed != null?
                    InkWell(
                      onTap:(){
                        Provider.of<SellerProvider>(context, listen: false).uploadReadyAfterSellDigitalProduct(context, orderProvider.selectedFileForImport,
                            Provider.of<AuthProvider>(context, listen: false).getUserToken(), widget.orderDetailsModel.id.toString());
                        },
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.FONT_SIZE_EXTRA_SMALL),

                            color: Theme.of(context).primaryColor
                        ),
                        alignment: Alignment.center,
                        child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${getTranslated('upload', context)}',
                              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,color: Theme.of(context).cardColor),),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            RotatedBox(
                              quarterTurns:2,
                              child: Container(width: Dimensions.ICON_SIZE_DEFAULT,
                                  child: Image.asset(Images.download_file, color: Theme.of(context).cardColor,)),
                            )
                          ],
                        )),
                      ),
                    ):SizedBox(),
                  ],),
                ):SizedBox()
              ],
            );
          }
      ) : SizedBox(),
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
      CustomDivider(),
      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

    ],
    );
  }
}


Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $_url';
  }
}