import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/data/repository/product_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;
  ProductProvider({@required this.productRepo});

  bool _isLoading = false;
  bool _firstLoading = true;
  List<int> _offsetList = [];
  int _offset = 1;

  int _barCodeQuantity = 0;
  int get barCodeQuantity => _barCodeQuantity;

  bool get isLoading => _isLoading;
  bool get firstLoading => _firstLoading;
  int get offset => _offset;


  String _printBarCode = '';
  String get printBarCode =>_printBarCode;


  bool _isGetting = false;
  bool get isGetting => _isGetting;

  List<bool> _isOn = [];
  List<bool> get isOn=>_isOn;


  // Seller products
  List<Product> _sellerProductList = [];
  List<Product> _stockOutProductList = [];
  int _sellerPageSize;
  int _stockOutProductPageSize;
  List<Product> get sellerProductList => _sellerProductList;
  List<Product> get stockOutProductList => _stockOutProductList;
  int get sellerPageSize => _sellerPageSize;
  int get stockOutProductPageSize => _stockOutProductPageSize;


  void initSellerProductList(String sellerId, int offset, BuildContext context, String languageCode, {bool reload = false}) async {
    if(reload || offset == 1) {
      _offset = 1;
          _offsetList = [];
          _sellerProductList = [];
        }
    if(!_offsetList.contains(offset)){
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getSellerProductList(sellerId, offset,languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _sellerProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _sellerPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;

        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();

    }else{
      if(_isLoading) {
        _isLoading = false;
      }

    }

  }
  Future getStockOutProductList(int offset, BuildContext context, String languageCode, {bool reload = false}) async {
    if(reload || offset == 1) {
      _offset = 1;
      _offsetList = [];
      _stockOutProductList = [];
    }
    if(!_offsetList.contains(offset)){
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getStockLimitedProductList(offset,languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _stockOutProductList = [];
        _stockOutProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _stockOutProductPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();

    }else{
      if(_isLoading) {
        _isLoading = false;
      }

    }

  }

  void setOffset(int offset) {
    _offset = offset;
  }


  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }
  Future<int> getLatestOffset(String sellerId, String languageCode) async {
    ApiResponse apiResponse = await productRepo.getSellerProductList(sellerId, 1,languageCode);
    return ProductModel.fromJson(apiResponse.response.data).totalSize;
  }


  void clearSellerData() {
    _sellerProductList = [];
    notifyListeners();
  }

  void setBarCodeQuantity(int quantity){
    _barCodeQuantity = quantity;
    print('Quantity is ==>$_barCodeQuantity');
    notifyListeners();
  }

  Future<void> barCodeDownload(BuildContext context,int id, int quantity) async {
    print('---->barcode');
    _isGetting = true;
    ApiResponse apiResponse = await productRepo.barCodeDownLoad(id, quantity);
    if(apiResponse.response.statusCode == 200) {
      _printBarCode = apiResponse.response.data;
      showCustomSnackBar(getTranslated('barcode_downloaded_successfully', context),context,isError: false);

      _isGetting = false;
    }else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isGetting = false;
    notifyListeners();
  }

  void downloadFile(String url, String dir) async {
    await FlutterDownloader.enqueue(
      url: '$url',
      savedDir: '$dir',
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );
  }


}
