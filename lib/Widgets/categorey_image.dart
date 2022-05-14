import 'package:flutter/material.dart';

class CategoryImage extends StatelessWidget {
  final int id;
  final bool selected;
  const CategoryImage({required this.id, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 2.0, color: selected ? Colors.green : Colors.transparent),
          image: DecorationImage(
              image: NetworkImage(
                  'https://cocodataset.org/images/cocoicons/$id.jpg'))),
    );
  }
}
