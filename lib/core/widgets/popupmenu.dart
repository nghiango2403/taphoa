import 'package:flutter/material.dart';
import 'package:taphoa/core/ultils/PopupItemModel.dart';

class CustomPopupMenu extends StatelessWidget {
  final List<PopupItemModel> items;
  final Function(int) onSelected;
  final IconData? mainIcon;
  final Color? mainIconColor;
  const CustomPopupMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.mainIcon,
    this.mainIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(mainIcon, color: mainIconColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      offset: const Offset(0, 50),
      onSelected: onSelected,
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<int>(
            value: item.id,
            child: Row(
              children: [
                Icon(item.icon, color: item.color ?? Colors.blueGrey, size: 20),
                const SizedBox(width: 12),
                Text(
                  item.title,
                  style: TextStyle(
                    color: item.color ?? Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
