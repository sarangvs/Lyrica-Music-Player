import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

  CustomAppBar({required this.onTap, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: appBar);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
