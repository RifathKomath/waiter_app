import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view/menu/menu_view.dart';

class CategoryController extends GetxController {
  

  final TextEditingController searchCntrl = TextEditingController();

  var selectedIndex = 0.obs;

  void selectCategory(int index) {
    selectedIndex.value = index;
  }

  RxString selectedFoodType = "ALL Items".obs;

  RxMap<int, PortionType> selectedPortions = <int, PortionType>{}.obs;

  final List<String> categories = [
    "All",
    "Curry",
    "Bread",
    "Beverages",
    "Rice",
    "Noodles"
  ];

  final List<Dish> allDishes = [
    Dish(
      name: "Chicken Biriyani",
      image: "assets/images/login_plate.png",
      isVeg: false,
      category: "Rice",
      portions: [
        Portion(type: PortionType.quarter, price: 70),
        Portion(type: PortionType.half, price: 140),
        Portion(type: PortionType.full, price: 240),
      ],
    ),
     Dish(
      name: "Mutton Curry",
      image: "assets/images/mutton_curry.png",
      isVeg: false,
      category: "Curry",
      portions: [
        Portion(type: PortionType.quarter, price: 70),
        Portion(type: PortionType.half, price: 140),
        Portion(type: PortionType.full, price: 240),
      ],
    ),
       Dish(
      name: "Porotta",
      image: "assets/images/parotta.png",
      isVeg: true,
      category: "Bread",
      portions: [
       Portion(type: PortionType.quarter, price: 70),
        Portion(type: PortionType.half, price: 140),
        Portion(type: PortionType.full, price: 240),
      ],
    ),
         
    Dish(
      name: "Paneer Butter Masala",
      image: "assets/images/paneer_butter.png",
      isVeg: true,
      category: "Curry",
      portions: [
        Portion(type: PortionType.quarter, price: 90),
        Portion(type: PortionType.half, price: 180),
        Portion(type: PortionType.full, price: 320),
      ],
    ),
  ];

 List<Dish> get filteredDishes {
  return allDishes.where((dish) {
    final foodTypeMatch =
        selectedFoodType.value == "ALL Items" ||
        (selectedFoodType.value == "Veg" && dish.isVeg) ||
        (selectedFoodType.value == "Non-Veg" && !dish.isVeg);

    final categoryMatch =
        selectedIndex.value == 0 ||
        dish.category == categories[selectedIndex.value];

    final searchMatch = dish.name
        .toLowerCase()
        .contains(searchQuery.value.toLowerCase());

    return foodTypeMatch && categoryMatch && searchMatch;
  }).toList();
}


  void selectPortion(int index, PortionType type) {
    selectedPortions[index] = type;
  }
  

    RxMap<String, int> quantities = <String, int>{}.obs;

  String quantityKey(int index, PortionType portion) {
    return '$index-${portion.name}';
  }

  void addItem(int index, PortionType portion) {
    final key = quantityKey(index, portion);
    quantities[key] = (quantities[key] ?? 0) + 1;
  }

  void removeItem(int index, PortionType portion) {
    final key = quantityKey(index, portion);
    if ((quantities[key] ?? 0) > 1) {
      quantities[key] = quantities[key]! - 1;
    } else {
      quantities.remove(key);
    }
  }

  RxDouble price = 0.0.obs;

  var cartItems = <CartItem>[].obs;

  void addToCart({
    required Dish dish,
    required PortionType portion,
    required double price,
    required int quantity,
  }) {
    if (quantity == 0) return;

    final index = cartItems.indexWhere(
      (e) => e.dish.name == dish.name && e.portion == portion,
    );

    if (index >= 0) {
      cartItems[index].quantity += quantity;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          dish: dish,
          portion: portion,
          quantity: quantity,
          price: price,
        ),
      );
    }
  }

 void removeAllFromCart({
  required int index,
  required Dish dish,
  required PortionType portion,
}) {
  
  final key = quantityKey(index, portion);
  quantities.remove(key);


  cartItems.removeWhere(
    (e) => e.dish.name == dish.name && e.portion == portion,
  );
}




  double get totalAmount {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }


  RxString searchQuery = ''.obs;

}
