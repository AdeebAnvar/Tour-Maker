import 'customer.dart';
import 'supplier.dart';

class Invoice {
  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;
}

class InvoiceInfo {
  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;
}

class InvoiceItem {
  const InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;
}
