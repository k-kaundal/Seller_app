
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/review_model.dart';
import 'package:sixvalley_vendor_app/data/repository/product_review_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';

class ProductReviewProvider extends ChangeNotifier{
  final ProductReviewRepo productReviewRepo;
  ProductReviewProvider({@required this.productReviewRepo});


  List<ReviewModel> _reviewList;
  List<ReviewModel> get reviewList => _reviewList != null ? _reviewList.reversed.toList() : _reviewList;

  List<bool> _isOn = [];
  List<bool> get isOn=>_isOn;


  Future<void> getReviewList(BuildContext context) async{
    ApiResponse apiResponse = await productReviewRepo.productReviewList();

    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _reviewList = [];
      apiResponse.response.data.forEach((review) {
        ReviewModel reviewModel = ReviewModel.fromJson(review);
        _reviewList.add(reviewModel);
        _isOn.add(reviewModel.status == 1? true:false);
      });
      print(reviewList);

    }else{
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }



  void setToggleSwitch(int index){
    _isOn[index] = !_isOn[index];
    notifyListeners();

  }


  Future<void> reviewStatusOnOff(BuildContext context, int reviewId, int status, int index) async{
    ApiResponse apiResponse = await productReviewRepo.reviewStatusOnOff(reviewId,status);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      // getReviewList(context);
      showCustomSnackBar(getTranslated('review_status_updated_successfully', context), context, isError: false);
    }else{
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

}