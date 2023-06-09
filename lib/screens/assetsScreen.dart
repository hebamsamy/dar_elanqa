import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dar_elanaqa/Constant.dart';
import 'package:dar_elanaqa/logic/models/product.dart';
import 'package:dar_elanaqa/widgets/loader.dart';
import 'package:dar_elanaqa/widgets/placeholder.dart';
import 'package:dar_elanaqa/widgets/productItem.dart';
import 'package:flutter/material.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("products").snapshots(),
      builder: (context, snapshot) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pushNamed("/add-product");
            },
            icon: Icon(Icons.add),
            label: Text("منتج جديد"),
            foregroundColor: WhiteColor,
            backgroundColor: PrimaryColor,
            elevation: 5,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))),
          ),
          body: (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done)
              ? snapshot.data?.docs.length == 0
                  ? PlaceHolder(
                      msg: "لا يوجد اصول بعد",
                    )
                  : GridView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1 / .5,
                      ),
                      children: snapshot.data?.docs
                              .where((element) => !element.data()["IsDeleted"])
                              .map((item) {
                            var product = Product(
                              Id: item.id,
                              Code: item.data()["Code"],
                              Name: item.data()["Name"],
                              SellingPrice: item.data()["SellingPrice"],
                              BuyingPrice: item.data()["BuyingPrice"],
                              Category: item.data()["Category"],
                              ImgUrl: item.data()["ImgUrl"],
                              Description: item.data()["Description"],
                              IsAvailable: item.data()["IsAvailable"],
                              IsDeleted: item.data()["IsDeleted"],
                            );
                            var temp = item.data()["CreationDate"] as Timestamp;
                            product.CreationDate = temp.toDate();
                            return ProductItem(
                              product: product,
                            );
                          }).toList() ??
                          [])
              : Loader(msg: "برجاء الانتظار"),
        );
      },
    );
  }
}
