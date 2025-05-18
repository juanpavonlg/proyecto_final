import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_final/data/library_database.dart';
import 'package:proyecto_final/domain/sale.dart';

class SaleNotifier extends StateNotifier<List<Sale>> {
  SaleNotifier() : super([]) {
    loadSales();
  }

  Future<void> loadSales() async {
    state = await LibraryDatabase.instance.getSales();
  }

  Future<void> addSale(Sale sale) async {
    await LibraryDatabase.instance.addSale(sale);
    await loadSales();
  }

  Future<void> updateSale(Sale sale) async {
    await LibraryDatabase.instance.updateSale(sale);
    await loadSales();
  }

  Future<void> deleteSale(int id) async {
    await LibraryDatabase.instance.deleteSale(id);
    await loadSales();
  }
}

final saleListProvider = StateNotifierProvider((ref) => SaleNotifier());
