import 'package:coco_task/Models/categories_model.dart';
import 'package:flutter/material.dart';

class CategorySelected extends StatelessWidget {
  final Category category;
  final Function reomveFunction;
  const CategorySelected(
      {required this.category, required this.reomveFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category.name ?? '',
          ),
          GestureDetector(
            onTap: () {
              reomveFunction(category.id);
            },
            child: const Icon(
              Icons.cancel_outlined,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
