import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restuarant_app/app/view/menu/menu_view.dart';
import 'package:restuarant_app/core/extensions/margin_extension.dart';
import 'package:restuarant_app/core/style/app_text_style.dart';
import 'package:restuarant_app/shared/utils/screen_utils.dart';

import '../../../core/style/colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../controller/table/table_controller.dart';

class TableModel {
  final String tableNo;
  final bool isAvailable;

  TableModel(this.tableNo, this.isAvailable);
}

final List<TableModel> tableList = [
  TableModel("Table 3", false),
  TableModel("Table 4", false),
  TableModel("Table 5", false),
  TableModel("Table 6", false),
  TableModel("Table 7", true),
  TableModel("Table 8", true),
  TableModel("Table 9", true),
  TableModel("Table 10", true),
];

class TableView extends StatelessWidget {
  final String section;
  const TableView({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final TableController controller = Get.put(TableController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarClr,
        title: Text(
          "Back to Dashboard",
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
              Text(
                section,
                style: AppTextStyles.textStyle_700_24.copyWith(color: whiteClr),
              ),
              8.h.hBox,
              Row(
                spacing: 15,
                children: [
                  customText(
                    key: "Total:",
                    value: "10",
                    color: whiteClr,
                    icon: Icons.restaurant,
                    iconColor: textColor,
                  ),
                  customText(
                    key: "Available:",
                    value: "4",
                    color: greenNotColor,
                    icon: Icons.circle,
                    iconColor: greenNotColor,
                  ),
                  customText(
                    key: "Occupied:",
                    value: "6",
                    color: darkRed,
                    icon: Icons.circle,
                    iconColor: darkRed,
                  ),
                ],
              ),
              10.h.hBox,
              Obx(() {
                if (controller.selectedTables.isEmpty) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "${controller.selectedTables.length} tables selected",
                    style: AppTextStyles.textStyle_500_14.copyWith(
                      color: greenNotColor,
                    ),
                  ),
                );
              }),

              10.h.hBox,
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: tableList.length,
                  itemBuilder: (context, index) {
                    final table = tableList[index];

                    return Obx(() {
                      final isSelected = controller.selectedTables.contains(
                        index,
                      );

                      return GestureDetector(
                        onTap: () {
                          controller.toggleTable(index, table.isAvailable);
                        },
                        child: tableCard(
                          tableNo: table.tableNo,
                          isAvailable: table.isAvailable,
                          isSelected: isSelected,
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => controller.selectedCount == 0
            ? SizedBox()
            : Container(
                color: appBarClr,
                padding: const EdgeInsets.all(15.0),
                child: SafeArea(
                  child: AppButton(
                    label: "Continue with ${controller.selectedCount} tables",
                    onTap: controller.selectedCount == 0 ? null : () {Screen.open(MenuView(section: section, tableList: controller.selectedTables));},
                  ),
                ),
              ),
      ),
    );
  }
}

Widget tableCard({
  required String tableNo,
  required bool isAvailable,
  required bool isSelected,
}) {
  final Color statusColor = isSelected
      ? Colors.deepPurpleAccent
      : isAvailable
      ? Colors.greenAccent
      : Colors.redAccent;

  final Color bgColor = isSelected
      ? const Color(0xFF2A0A3D)
      : isAvailable
      ? const Color(0xFF071C14)
      : const Color(0xFF1A0505);

  return Container(
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: statusColor.withOpacity(0.7),
        width: isSelected ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: statusColor.withOpacity(0.4),
          blurRadius: isSelected ? 14 : 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const Positioned(
          top: 8,
          right: 8,
          child: Icon(Icons.circle_outlined, size: 18, color: Colors.white38),
        ),

        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.restaurant, size: 30, color: statusColor),
              const SizedBox(height: 8),
              Text(
                tableNo,
                style: AppTextStyles.textStyle_600_16.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isSelected
                    ? "Selected"
                    : isAvailable
                    ? "Available"
                    : "Occupied",
                style: AppTextStyles.textStyle_400_12.copyWith(
                  color: statusColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget customText({
  required String key,
  required String value,
  required Color color,
  required IconData icon,
  required Color iconColor,
}) {
  return Row(
    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: iconColor, size: 15),
      3.w.wBox,

      Text(
        key,
        style: AppTextStyles.textStyle_400_12.copyWith(color: textColor),
      ),
      8.w.wBox,

      Text(
        value,
        textAlign: TextAlign.end,
        style: AppTextStyles.textStyle_600_16.copyWith(color: color),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
