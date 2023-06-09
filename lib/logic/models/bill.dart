class Bill {
  DateTime? CrearedAt = DateTime.now();
  String Id;
  String ProductCode;
  String ProductId;
  double ProductPrice;
  double CostPrice;
  double Discount;
  String Notes;
  String ClientPhone;
  Bill({
    required this.Id,
    required this.ProductCode,
    required this.ProductId,
    required this.ProductPrice,
    required this.CostPrice,
    required this.Discount,
    required this.Notes,
    required this.ClientPhone,
  });
}
