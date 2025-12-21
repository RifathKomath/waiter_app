import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restuarant_app/app/view/dash_board/dash_board_view.dart';
import 'package:restuarant_app/core/extensions/margin_extension.dart';
import 'package:restuarant_app/core/style/colors.dart';
import 'package:restuarant_app/shared/utils/screen_utils.dart';
import 'package:restuarant_app/shared/widgets/app_text_field.dart';
import 'package:restuarant_app/shared/widgets/app_toast.dart';

import '../../../core/style/app_text_style.dart';
import '../../../shared/widgets/app_button.dart';
import '../../controller/menu/menu_controller.dart';
import '../menu/menu_view.dart';

class CartView extends StatelessWidget {
  final CategoryController controller = Get.find();

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120A23),
       appBar: AppBar(
        backgroundColor: appBarClr,
        title: Text(
          "Back to Menu",
          style: AppTextStyles.textStyle_500_16.copyWith(color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
           Text(
                    "Order Summary",
                    style: AppTextStyles.textStyle_700_24.copyWith(
                      color: whiteClr,
                    ),
                  ),

                   Text(
                    "Review your order sending to kitchen",
                    style: AppTextStyles.textStyle_400_12.copyWith(
                      color: textColor,
                    ),
                  ),

            20.h.hBox,

            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.cartItems.length,
                  itemBuilder: (_, index) {
                    final item = controller.cartItems[index];

                    return _CartItemTile(
                      item: item,
                      onEdit: () {
                        _showPrepareNoteDialog(
                          context,
                          item,
                        );
                      },
                    );
                  },
                );
              }),
            ),

            const Divider(color: whiteClr),

         
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Items",
                       style: AppTextStyles.textStyle_500_16.copyWith(color: whiteClr)),
                    Text(
                      controller.cartItems.length.toString(),
                      style: AppTextStyles.textStyle_500_16.copyWith(color: whiteClr),
                    ),
                  ],
                )),

            10.h.hBox,

            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Amount",
                        style: AppTextStyles.textStyle_500_16.copyWith(color: whiteClr)),
                    Text(
                      "₹${controller.totalAmount}",
                      style: AppTextStyles.textStyle_700_16.copyWith(color: Color(0xFF8E2DE2))
                    ),
                  ],
                )),

            20.h.hBox,

            AppButton(
              label: "Send to Kitchen",
              isPrefixIconEnabled: true,
              icon: Icons.send,
              onTap: () {
              Screen.openAsNewPage(DashBoardView());
              showToast("Order sent Successfully to kitchen",isError: false);

              },
            )
          ],
        ),
      ),
    );
  }
}
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onEdit;

  const _CartItemTile({
    required this.item,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.circle, color: greenNotColor, size: 10),
              8.w.wBox,
          
              
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.dish.name,
                          style: TextStyle(color: whiteClr)),
                      4.h.hBox,
                      Text(
                        "₹${item.price} x ${item.quantity} = ₹${item.price * item.quantity}",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
          
                      
                    ],
                  ),
                ),
               
          
           
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8E2DE2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.edit,
                      color: Colors.white, size: 14),
                ),
              )
            ],
          ),

          if (item.prepareNote.isNotEmpty)
                    Column(
                      children: [
                        20.h.hBox,
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: textColor),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Note: ${item.prepareNote}",
                              style: AppTextStyles.textStyle_400_14.copyWith(color: whiteClr)
                            ),
                          ),
                        ),
                      ],
                    )
        ],
      ),
    );
  }
}
Future<void> _showPrepareNoteDialog(
  BuildContext context,
  CartItem item,
) {
  final TextEditingController noteController =
      TextEditingController(text: item.prepareNote);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0xFF1E1235),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
         
               Text(
                "Prepare Note",
                style: AppTextStyles.textStyle_600_18.copyWith(color: whiteClr)
              ),

              12.h.hBox,

        
              AppTextField(controller: noteController, textInputType: TextInputType.name, labelText: "",max: 3,),

              16.h.hBox,

              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(label: "Cancel", onTap: () {
                    Screen.close();
                  },isFilled: true,),
                
                  8.w.wBox,
                  AppButton(label: "Save", onTap: () {
                     item.prepareNote = noteController.text;
                       Screen.close();
                   
                   
                  },)
                 
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

