class Product {
  String? Id;
  String Name;
  String Description;
  String? ImgUrl = "https://picsum.photos/200";
  String Category;
  String Code;
  double BuyingPrice;
  double SellingPrice;
  DateTime? CreationDate = DateTime.now();
  bool IsAvailable = true;
  bool IsDeleted = false;
  Product({
    required this.Id,
    required this.Name,
    required this.Description,
    required this.Code,
    required this.Category,
    required this.BuyingPrice,
    required this.SellingPrice,
    required this.ImgUrl,
    required this.IsAvailable,
    required this.IsDeleted,
  });
}
