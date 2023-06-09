class Expense {
  DateTime? CrearedAt = DateTime.now();
  String Id;
  String Notes;
  double CostPrice;
  Expense({
    required this.Id,
    required this.CostPrice,
    required this.Notes,
  });
}
