import 'package:flutter/material.dart';

class DepartmentImageWidget extends StatelessWidget {
  const DepartmentImageWidget({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: Image.asset(
        imageUrl,
      ),
    );
  }
}
