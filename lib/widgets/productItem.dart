import 'package:dar_elanaqa/Constant.dart';
import 'package:flutter/material.dart';

import '../logic/models/product.dart';

class ProductItem extends StatelessWidget {
  ProductItem({required this.product});
  Product product;
  List<Widget> badge = [
    Container(
      child: Text(
        "غير متاح",
        style: TextStyle(color: WhiteColor),
      ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: RedColor,
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(15),
        color: GreenColor,
      ),
      child: Text(
        "متاح",
        style: TextStyle(color: WhiteColor),
      ),
      padding: EdgeInsets.all(10),
    ),
    Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(15),
        color: PrimaryColor,
      ),
      child: Text(
        "محجوز",
        style: TextStyle(color: WhiteColor),
      ),
      padding: EdgeInsets.all(10),
    )
  ];
  Widget getBadge() {
    if (product.IsDeleted == true) {
      //un available
      return badge[0];
    } else if (product.IsDeleted == false && product.IsAvailable == true) {
      //available
      return badge[1];
    } else {
      //booking
      return badge[2];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            child: Image.network(product.ImgUrl!),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Card(
            elevation: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.Name,
                  style: TextStyle(fontSize: 20),
                ),
                Text("${product.Code} : الكود"),
                Text("${product.SellingPrice.toString()} : السعٍر ج.م"),
                getBadge()
              ],
            ),
          ),
        )
      ],
    );
  }
}
