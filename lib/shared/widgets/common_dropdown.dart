import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:restuarant_app/core/extensions/margin_extension.dart';
import '../../core/style/app_text_style.dart';
import '../../core/style/colors.dart';
import 'app_svg.dart';

class CustomDropdown<T> extends StatefulWidget {
  final T? selectedValue;
  final List<T> items;
  final Function(T?) onChanged;
  final String hint;
  final double? w;
  final bool showHeading;
  final String? headingText;
  final double? h;
  final TextStyle? hintStyle;
  final String Function(T)? itemToString;
  final String? Function(T?)? validator;
  final double radius;
  final void Function()? onTap;
  final bool isloading;
  final bool isSelectedValid;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.hint,
    this.showHeading = false,
    this.headingText,
    this.w = 120,
    this.h = 45,
    this.hintStyle,
    this.itemToString,
    this.onTap,
    this.isloading = false,
    this.validator,
    this.radius = 12.47,
    required this.isSelectedValid,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _rotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggle(bool open) {
    setState(() => _isOpen = open);
    open ? _controller.forward() : _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      initialValue: widget.selectedValue,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showHeading && widget.headingText != null) ...[
              Text(widget.headingText!,
                  style: AppTextStyles.textStyle_500_14.copyWith(color: textPrimary)),
              8.hBox,
            ],

            /// 🔥 Animated container
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: widget.w,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: cardBgLight,
                
                borderRadius: BorderRadius.circular(widget.radius),
              ),
              child: InkWell(
  onTap: () => _showDropdown(context, field), 
  child: Row(
    children: [
      Expanded(
        child: Text(
          field.value != null
              ? (widget.itemToString != null
                  ? widget.itemToString!(field.value as T)
                  : field.value.toString())
              : widget.hint,
          style: field.value == null
              ? (widget.hintStyle ??
                  AppTextStyles.textStyle_500_14
                      .copyWith(color: textPrimary))
              : AppTextStyles.textStyle_500_14.copyWith(color: textPrimary),
        ),
      ),

      /// 🔄 Rotating arrow
      RotationTransition(
        turns: _rotation,
        child: AppSvg(assetName: "grey_down_arrow",color: textPrimary,),
      ),
    ],
  ),
),

            ),

            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text(
                  field.errorText ?? '',
                  style: AppTextStyles.textStyle_400_12
                      .copyWith(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }

 void _showDropdown(BuildContext context, FormFieldState<T> field) async {
  _toggle(true);

  final RenderBox box = context.findRenderObject() as RenderBox;
  final Offset position = box.localToGlobal(Offset.zero);
  final double width = box.size.width;

  final selected = await showMenu<T>(
    context: context,
    color: cardBg, 
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(widget.radius),
    ),
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + box.size.height + 6,
      position.dx + width,
      0,
    ),
    constraints: BoxConstraints(
      minWidth: width, // ✅ same width
      maxWidth: width,
      maxHeight: 220,
    ),
    items: widget.items.map((e) {
      return PopupMenuItem<T>(
        value: e,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          widget.itemToString != null
              ? widget.itemToString!(e)
              : e.toString(),
          style: AppTextStyles.textStyle_500_14.copyWith(color: textPrimary),
        ),
      );
    }).toList(),
  );

  if (selected != null) {
    field.didChange(selected);
    widget.onChanged(selected);
    field.validate();
  }

  _toggle(false);
}


}


//Editable Dropdown
Widget editableDropdown({
  required String label,
  required List<String> items,
  required RxString value,
  double? width,
})
{
  return Obx(() {
    return SizedBox(
      width: width ?? 420.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.textStyle_500_14.copyWith(
            color: darkGrey,
          ),),
          8.h.hBox,
          TextFormField(
            controller: TextEditingController(text: value.value)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: value.value.length),
              ),
            decoration: InputDecoration(
              hintText: "Select or type",
              hintStyle: AppTextStyles.textStyle_500_14.copyWith(
                color: darkGrey,
              ),
              suffixIcon: PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down),
                onSelected: (String selected) {
                  value.value = selected;
                },
                itemBuilder: (BuildContext context) {
                  return items.map((String item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList();
                },
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: borderColor, // Normal border color
                  width: 1, // 👈 custom border width
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.deepPurple, // 👈 color when focused
                  width: 2, // 👈 slightly thicker when focused
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
            onChanged: (text) => value.value = text,
          ),
        ],
      ),
    );
  });
}