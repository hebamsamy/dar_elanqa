class Booking {
  DateTime? CrearedAt = DateTime.now();
  String Id;
  String Notes;
  String ClientPhone;
  String ProductCode;
  String ProductId;
  double Price;
  Booking({
    required this.Id,
    required this.Price,
    required this.Notes,
    required this.ClientPhone,
    required this.ProductCode,
    required this.ProductId,
  });
}
