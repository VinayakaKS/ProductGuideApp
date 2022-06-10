// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Allergen {
  Allergen({required this.name, required this.checked});
  final String name;
  bool checked;
}

class AllergensItem extends StatelessWidget {
  AllergensItem({
    required this.allergens,
    required this.onAListChanged,
  }) : super(key: ObjectKey(allergens));

  final Allergen allergens;
  final onAListChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onAListChanged(allergens);
      },
      leading: CircleAvatar(
        child: Text(
          allergens.name[0].toUpperCase(),
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.redAccent,
      ),
      title: Text(allergens.name, style: _getTextStyle(allergens.checked)),
    );
  }
}
