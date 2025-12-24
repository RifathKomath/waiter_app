import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restuarant_app/core/extensions/margin_extension.dart';
import 'package:restuarant_app/shared/utils/screen_utils.dart';
import 'package:restuarant_app/shared/widgets/app_button.dart';
import 'package:restuarant_app/shared/widgets/app_search_field.dart';
import 'package:restuarant_app/shared/widgets/app_success_dialog.dart';

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
  RxString prepareNote;

  CartItem({
    required this.dish,
    required this.portion,
    required this.quantity,
    required this.price,
    String? prepareNote,
  }) : prepareNote = (prepareNote ?? "").obs;
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
        backgroundColor: scaffoldBgDark,
        title: Text(
          "Back to Tables",
          style: AppTextStyles.textStyle_500_16.copyWith(color: textPrimary),
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          colors: [scaffoldBgDark, scaffoldBgLight],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: dividerColor, thickness: 1.5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Table ${tableList.join(', ')}",
                        style: AppTextStyles.textStyle_700_24.copyWith(
                          fontSize: 20,color: textPrimary
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
                              Icon(Icons.shopping_cart, color: textPrimary),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  top: 10,
                                ),
                                child: countBox(
                                  countValue: controller.cartItems.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  Text(
                    section,
                    style: AppTextStyles.textStyle_500_14.copyWith(
                      color: textPrimary,
                    ),
                  ),
                  10.h.hBox,
                  CustomDropdown(
                    selectedValue: branchList.first,
                    items: branchList,
                    w: double.infinity,
                    radius: 8,
                  
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
            ),
            15.h.hBox,
            Text(
              "Food Type",
              style: AppTextStyles.textStyle_500_14.copyWith(
                color: textPrimary,
              ),
            ).paddingSymmetricHorizontal(20),
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
                                ? textSecondary
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
                              style: AppTextStyles.textStyle_500_12.copyWith(
                                color: isSelected ? Colors.black : textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ).paddingSymmetricHorizontal(10);
              }
              return SizedBox();
            }),
            20.h.hBox,
            AppSearchField(
              controller: controller.searchCntrl,
              onChanged: (value) {
                controller.searchQuery.value = value;
              },
            ).paddingSymmetricHorizontal(20),
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

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                          //  index ==0 ?0.wBox :    ClipRRect(
                          //         borderRadius: BorderRadius.circular(8),
                          //         child: Image.asset(
                          //           dish.image,
                          //           width: 70,
                          //           height: 70,
                          //           fit: BoxFit.fill,
                          //         ),
                          //       ),

                          //       6.w.wBox,

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
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 15,
                                            color: dish.isVeg
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          Text(
                                            dish.isVeg ? "Veg" : "Non-Veg",
                                            style: TextStyle(
                                              color: dish.isVeg
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
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
                                                      horizontal: 15,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? textSecondary
                                : whiteClr.withOpacity(0.10),
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
                                                  style: AppTextStyles.textStyle_500_12.copyWith(color:isSelected
                                                        ? Colors.black
                                                        : whiteClr, ) 
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
                                            .copyWith(color: textPrimary),
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
                                          border: Border.all(color: textPrimary),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
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
                                                  color: textPrimary,
                                                ),
                                              ),
                                              8.w.wBox,
                                              Text(
                                                quantity.toString(),
                                                style: const TextStyle(
                                                  color: textPrimary,
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
                                                  color: textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
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
                                             bgColor: textPrimary,
                                            label: "Remove",
                                            textColor: Colors.black,
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
                                            bgColor: cardBgLight,
                                            label: controller.cartItems.isEmpty
                                                ? "Add"
                                                : "Added",
                                            onTap: () {
                                              SuccessDialog.show(
                                                context,
                                                message:
                                                    "Order added to cart successfully",
                                                onComplete: () {
                                                  controller.addToCart(
                                                    dish: dish,
                                                    portion: selectedPortion,
                                                    price: price,
                                                    quantity: quantity,
                                                  );
                                                },
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
                      ),
                    );
                  },
                );
              }),
            ),
          ],
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
    decoration: BoxDecoration(shape: BoxShape.circle, color: textPrimary),
    child: Text(
      countValue.toString(),
      style: TextStyle(fontSize: 14, color: scaffoldBgDark),
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
