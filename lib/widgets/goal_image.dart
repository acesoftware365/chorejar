import 'package:flutter/material.dart';
import '../models/family.dart';
import '../assets/library.dart';
import 'surfaces.dart';

const goalImages = goalImageIds;
String goalImageFor(ChildData child) {
  if (goalImages.contains(child.goalImage)) return child.goalImage;
  final name = child.goalName.toLowerCase();
  if (RegExp(r'iphone|phone|tel[eé]fono|celular').hasMatch(name)) {
    return 'iphone';
  }
  if (RegExp(r'bicic|bike|cycl').hasMatch(name)) return 'bicycle';
  return 'gift';
}

class GoalImage extends StatelessWidget {
  final String value;
  final double size;
  const GoalImage(this.value, {super.key, this.size = 72});
  @override
  Widget build(BuildContext context) => !AssetLibrary.goals.containsKey(value)
      ? Icon(Icons.card_giftcard_rounded, size: size, color: gold)
      : Image.asset(
          AssetLibrary.goals[value]!.path,
          width: size,
          height: size,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        );
}
