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
        backgroundColor: scaffoldBgDark,
        title: Text(
          "Back to Dashboard",
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section,
                  style: AppTextStyles.textStyle_700_24.copyWith(
                    color: textPrimary,
                  ),
                ),
                8.h.hBox,
                Container(
                   decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: textPrimary.withOpacity(0.08)),
                          
                    ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 15,
                      children: [
                        customText(
                          key: "Total:",
                          value: "10",
                          color: textPrimary,
                          icon: Icons.restaurant,
                          iconColor: textPrimary,
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
                  ),
                ),
                10.h.hBox,
                Obx(() {
                  if (controller.selectedTables.isEmpty) {
                    return const SizedBox();
                  }

                  return Text(
                    "${controller.selectedTables.length} tables selected",
                    style: AppTextStyles.textStyle_700_16.copyWith(
                      color: textPrimary,
                    ),
                  );
                }),
              ],
            ).paddingSymmetricHorizontal(20),

            10.h.hBox,
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
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
      bottomNavigationBar: Obx(
        () => controller.selectedCount == 0
            ? SizedBox()
            : Container(
                color: scaffoldBgLight,
                padding: const EdgeInsets.all(15.0),
                child: SafeArea(
                  child: AppButton(
                    bgColor: cardBgLight,

                    label: "Continue with ${controller.selectedCount} tables",
                    onTap: controller.selectedCount == 0
                        ? null
                        : () {
                            Screen.open(
                              MenuView(
                                section: section,
                                tableList: controller.selectedTables,
                              ),
                            );
                          },
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
  final Color bgColor = isSelected
      ? const Color(0xFF071C14).withOpacity(0.65)
      : isAvailable
      ? cardBgLight.withOpacity(0.55)
      : const Color(0xFF1A0505).withOpacity(0.65);

  final Color statusColor = isSelected
      ? Colors.greenAccent.withOpacity(0.65)
      : isAvailable
      ? textPrimary
      : Colors.redAccent.withOpacity(0.6);

  return Container(
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: bgColor.withOpacity(0.7),
        width: isSelected ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: bgColor.withOpacity(0.25),
          blurRadius: isSelected ? 14 : 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Stack(
      children: [
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
        style: AppTextStyles.textStyle_400_12.copyWith(color: textPrimary),
      ),
      8.w.wBox,

      Text(
        value,
        textAlign: TextAlign.end,
        style: AppTextStyles.textStyle_600_18.copyWith(color: color),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
