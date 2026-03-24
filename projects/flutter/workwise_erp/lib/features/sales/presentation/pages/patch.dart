import 'dart:io';
void main() {
  final f = File('lib/features/sales/presentation/pages/sales_order_create_page.dart');
  String content = f.readAsStringSync();
  print(content.length);
}
