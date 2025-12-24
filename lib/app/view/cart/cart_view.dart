import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restuarant_app/app/view/dash_board/dash_board_view.dart';
import 'package:restuarant_app/core/extensions/margin_extension.dart';
import 'package:restuarant_app/core/style/colors.dart';
import 'package:restuarant_app/shared/utils/screen_utils.dart';
import 'package:restuarant_app/shared/widgets/app_success_dialog.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [scaffoldBgDark, scaffoldBgLight],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Divider(color: dividerColor, thickness: 1.5),
              Expanded(child: _buildBody(context)),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text("Back to Menu", style: AppTextStyles.textStyle_500_16.copyWith(color: textPrimary)),
      iconTheme: IconThemeData(color: textPrimary),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Summary", style: AppTextStyles.textStyle_700_24.copyWith(color: textPrimary)),
          Text(
            "Review your order sending to kitchen",
            style: AppTextStyles.textStyle_400_12.copyWith(color: textPrimary),
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
                      _showPrepareNoteDialog(context, item);
                    },
                  );
                },
              );
            }),
          ),

              Divider(color: dividerColor, thickness: 2),

          _summaryRow(
            title: "Total Items",
            value: controller.cartItems.length.toString(),
          ),

          10.h.hBox,

          _summaryRow(
            title: "Total Amount",
            value: "₹${controller.totalAmount}",
            isBold: true,
            valueColor: textPrimary,
          ),

          20.h.hBox,

          AppButton(
            bgColor: cardBgLight,
            label: "Send to Kitchen",
            isPrefixIconEnabled: true,
            icon: Icons.send,
            onTap: () {
              SuccessDialog.show(
                context,
                message: "Order sent to kitchen successfully",
                onComplete: () {
                  Screen.openAsNewPage(DashBoardView());
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required String title,
    required String value,
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.textStyle_500_16.copyWith(
            color: textPrimary,
          ),
        ),
        Text(
          value,
          style:
              (isBold
                      ? AppTextStyles.textStyle_700_16.copyWith(fontSize: 20)
                      : AppTextStyles.textStyle_500_16)
                  .copyWith(color: valueColor ?? textPrimary),
        ),
      ],
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onEdit;

  const _CartItemTile({required this.item, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.circle, color: cardBgLight, size: 10),
              8.w.wBox,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.dish.name,
                      style: AppTextStyles.textStyle_600_16.copyWith(
                        color: textPrimary,
                      ),
                    ),
                    4.h.hBox,
                    Text(
                      "₹ ${item.price} x ${item.quantity} = ₹ ${item.price * item.quantity}",
                      style: AppTextStyles.textStyle_400_12.copyWith(
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: cardBgLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.edit, color: textPrimary, size: 14),
                ),
              ),
            ],
          ),

          Obx(() {
            if (item.prepareNote.value.isNotEmpty) {
              return Column(
                children: [
                  16.h.hBox,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: textPrimary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Note: ${item.prepareNote.value}",
                      style: AppTextStyles.textStyle_400_14.copyWith(
                        color: textPrimary,
                      ),
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          }),
        ],
      ),
    );
  }
}

Future<void> _showPrepareNoteDialog(BuildContext context, CartItem item) {
  final TextEditingController noteController = TextEditingController(
    text: item.prepareNote.value,
  );

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Prepare Note",
                style: AppTextStyles.textStyle_600_18.copyWith(color: whiteClr),
              ),

              12.h.hBox,

              AppTextField(
                controller: noteController,
                textInputType: TextInputType.name,
                labelText: "",
                max: 3,
              ),

              16.h.hBox,

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: "Cancel",
                    isFilled: true,
                    onTap: () {
                      Screen.close();
                    },
                  ),
                  8.w.wBox,
                  AppButton(
                    bgColor: cardBgLight,
                    label: "Save",
                    onTap: () {
                      item.prepareNote.value = noteController.text;
                      Screen.close();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
