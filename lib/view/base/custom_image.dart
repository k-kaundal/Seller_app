import 'package:flutter/cupertino.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final BoxFit fit;
  final String placeholder;
  CustomImage({@required this.image, this.height, this.width, this.fit = BoxFit.cover, this.placeholder = Images.placeholder_image});

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: Images.placeholder_image, image: image, fit: BoxFit.contain,
      imageErrorBuilder: (c, o, s) => Image.asset(
        Images.placeholder_image, height: height,
        width: width, fit: BoxFit.cover,
      ),
    );
  }
}
