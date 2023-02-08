import 'package:flutter/material.dart';

import '../constants/colors.dart';

class AddableWidget extends StatelessWidget {
  final String label;
  final void Function()? onClick;
  final bool isSelected;
  const AddableWidget({
    required this.label,
    this.isSelected = false,
    this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            width: 50,
            color: ConstantColors.primaryColor.withOpacity(.5),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: isSelected ? ConstantColors.green : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            color: ConstantColors.primaryColor.withOpacity(.25),
            width: MediaQuery.of(context).size.width * .4,
            height: 50,
            alignment: Alignment.centerLeft,
            child: Text(
              "$label Widget",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
