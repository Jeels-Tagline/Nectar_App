import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/model/quantity_model.dart';

class QuantityProvider extends ChangeNotifier {
  QuantityModel quantityModel = QuantityModel(quantity: 1);

  void increseQuantity({required int quantity}) {
    quantity++;
    quantityModel.quantity = quantity;
    notifyListeners();
  }

  void decreseQuantity({required int quantity}) {
    if (quantity > 1) {
      quantity--;
      quantityModel.quantity = quantity;
      notifyListeners();
    }
  }
}
