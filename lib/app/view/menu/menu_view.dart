import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restuarant_app/core/extensions/margin_extension.dart';
import 'package:restuarant_app/shared/utils/screen_utils.dart';
import 'package:restuarant_app/shared/widgets/app_button.dart';
import 'package:restuarant_app/shared/widgets/app_search_field.dart';

import '../../../core/style/app_text_style.dart';
import '../../../core/style/colors.dart';
import '../../../shared/widgets/common_dropdown.dart';
import '../../controller/menu/menu_controller.dart';
import '../cart/cart_view.dart';

class CartItem {
  final Dish dish;
  final PortionType portion;
  int quantity;
  final double price;
  String prepareNote;

  CartItem({
    required this.dish,
    required this.portion,
    required this.quantity,
    required this.price,
    this.prepareNote = "",
  });
}

enum PortionType { quarter, half, full }

class Portion {
  final PortionType type;
  final double price;

  Portion({required this.type, required this.price});
}

class Dish {
  final String name;
  final String image;
  final bool isVeg;
  final String category;
  final List<Portion> portions;

  Dish({
    required this.name,
    required this.image,
    required this.isVeg,
    required this.category,
    required this.portions,
  });
}

class MenuView extends StatelessWidget {
  final String section;
  final List<int> tableList;
  const MenuView({super.key, required this.section, required this.tableList});

  @override
  Widget build(BuildContext context) {
    final List branchList = ["ALL Items", "Non-Veg", "Veg"];
    final List<String> categories = [
      "All",
      "Curry",
      "Bread",
      "Beverages",
      "Rice",
      "Noodles",
    ];
    final CategoryController controller = Get.put(CategoryController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarClr,
        title: Text(
          "Back to Tables",
          style: AppTextStyles.textStyle_500_16.copyWith(color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF120A23), Color.fromARGB(255, 73, 56, 100)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Table ${tableList.join(', ')}",
                        style: AppTextStyles.textStyle_700_24.copyWith(
                          color: whiteClr,
                        ),
                      ),
                      Spacer(),
                      Obx(() {
                        if (controller.cartItems.isEmpty) {
                          return SizedBox();
                        }
                        return GestureDetector(
                          onTap: () {
                            Screen.open(CartView());
                          },
                          child: Stack(
                            children: [
                              Icon(Icons.shopping_cart, color: whiteClr),
                              countBox(countValue: controller.cartItems.length),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  Text(
                    section,
                    style: AppTextStyles.textStyle_500_14.copyWith(
                      color: whiteClr,
                    ),
                  ),
                  10.h.hBox,
                  CustomDropdown(
                    selectedValue: branchList.first,
                    items: branchList,
                    w: double.infinity,
                    onChanged: (value) {
                      controller.selectedFoodType.value = value!;
                    },
                    hint: "",
                    isSelectedValid: true,
                    headingText: "Category",
                    showHeading: true,
                    validator: (p0) {
                      if (p0 == null) {
                        return "Field is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
              15.h.hBox,
              Text(
                "Food Type",
                style: AppTextStyles.textStyle_500_14.copyWith(
                  color: textColor,
                ),
              ),
              10.h.hBox,
              Obx(() {
                if (controller.selectedIndex.value >= 0) {
                  return SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final isSelected =
                            controller.selectedIndex.value == index;

                        return GestureDetector(
                          onTap: () => controller.selectCategory(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0xFF8E2DE2)
                                  : whiteClr.withOpacity(0.10),

                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 3,
                            ),
                            child: Center(
                              child: Text(
                                categories[index],
                                style: AppTextStyles.textStyle_400_12.copyWith(
                                  color: isSelected ? Colors.white : textColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return SizedBox();
              }),
              20.h.hBox,
              AppSearchField(
                controller: controller.searchCntrl,
                onChanged: (value) {
                  controller.searchQuery.value = value;
                },
              ),
              20.h.hBox,
              Expanded(
                child: Obx(() {
                  final dishes = controller.filteredDishes;

                  return ListView.builder(
                    itemCount: dishes.length,
                    itemBuilder: (context, index) {
                      final dish = dishes[index];
                      final selectedPortion =
                          controller.selectedPortions[index] ??
                          dish.portions.first.type;

                      final price = dish.portions
                          .firstWhere((p) => p.type == selectedPortion)
                          .price;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    dish.image,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.fill,
                                  ),
                                ),

                                6.w.wBox,

                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dish.name,
                                        style: AppTextStyles.textStyle_600_16
                                            .copyWith(color: whiteClr),
                                      ),
                                      Text(
                                        dish.isVeg ? "Veg" : "Non-Veg",
                                        style: TextStyle(
                                          color: dish.isVeg
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),

                                      6.h.hBox,

                                      Obx(() {
                                        final selectedPortion =
                                            controller
                                                .selectedPortions[index] ??
                                            dish.portions.first.type;

                                        return Wrap(
                                          spacing: 6,
                                          children: dish.portions.map((p) {
                                            final isSelected =
                                                selectedPortion == p.type;

                                            return GestureDetector(
                                              onTap: () {
                                                controller.selectPortion(
                                                  index,
                                                  p.type,
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? const Color(0xFF8E2DE2)
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? Colors.transparent
                                                        : whiteClr,
                                                  ),
                                                ),
                                                child: Text(
                                                  p.type.name,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : whiteClr,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      }),
                                    ],
                                  ),
                                ),

                                Obx(() {
                                  final quantity =
                                      controller.quantities[controller
                                          .quantityKey(
                                            index,
                                            selectedPortion,
                                          )] ??
                                      0;
                                  return Column(
                                    children: [
                                      Text(
                                        "₹$price",
                                        style: AppTextStyles.textStyle_600_16
                                            .copyWith(color: whiteClr),
                                      ),
                                      6.h.hBox,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                        
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(color: textColor),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                controller.removeItem(
                                                  index,
                                                  selectedPortion,
                                                );
                                              },
                                              child: const Icon(
                                                Icons.remove,
                                                size: 24,
                                                color: Colors.white,
                                              ),
                                            ),
                                            8.w.wBox,
                                            Text(
                                              quantity.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                              ),
                                            ),
                                            8.w.wBox,
                                            GestureDetector(
                                              onTap: () {
                                                controller.addItem(
                                                  index,
                                                  selectedPortion,
                                                );
                                              },
                                              child: const Icon(
                                                Icons.add,
                                                size: 24,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                            15.h.hBox,
                            Obx(() {
                              final quantity =
                                  controller.quantities[controller.quantityKey(
                                    index,
                                    selectedPortion,
                                  )] ??
                                  0;

                              return quantity >= 1
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: AppButton(
                                            label: "Remove",
                                            isFilled: true,
                                            onTap: () {
                                              controller.removeAllFromCart(
                                                index: index,
                                                dish: dish,
                                                portion: selectedPortion,
                                              );
                                            },
                                          ),
                                        ),
                                        10.w.wBox,
                                        Expanded(
                                          child: AppButton(
                                            label: "Add",
                                            onTap: () {
                                              // controller.addItem(index, selectedPortion);

                                              controller.addToCart(
                                                dish: dish,
                                                portion: selectedPortion,
                                                price: price,
                                                quantity: quantity,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink();
                            }),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),

      //     bottomNavigationBar: Obx(() {
      //   if (controller.cartItems.isEmpty) {
      //     return const SizedBox.shrink();
      //   }

      //   return _BottomOrderBar(controller);
      // }),
    );
  }
}

Widget countBox({required int countValue}) {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: const Color(0xFF8E2DE2),
    ),
    child: Text(
      countValue.toString(),
      style: TextStyle(fontSize: 12, color: Colors.white),
    ),
  );
}
// Widget _BottomOrderBar(CategoryController controller) {
//   return Container(
  
//     decoration: BoxDecoration(
//     color: appBarClr
     
//     ),
//     child: Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
         
//           SizedBox(
//             height: 50,
//             child: ListView.builder(
//               itemCount: controller.cartItems.length,
//               itemBuilder: (_, index) {
//                 final item = controller.cartItems[index];
        
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "${item.dish.name} (${item.portion.name}) x${item.quantity}",
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                       Text(
//                         "₹${item.price * item.quantity}",
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
        
//           const Divider(color: whiteClr),
        
       
//           Text(
//             "Total Amount ₹${controller.totalAmount}",
//             style: AppTextStyles.textStyle_600_16
//                 .copyWith(color: Colors.white),
//           ),
//           10.h.hBox,
//           AppButton(
//                 label: "Show Order Summary",
//                 onTap: () {
//                   // Navigate to summary page
//                 },
//               ),
//         ],
//       ),
//     ),
//   );
// }
