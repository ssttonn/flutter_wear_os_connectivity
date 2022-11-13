import 'package:flutter/material.dart';
import '../extensions.dart';

class SpacingColumn extends Column {
  SpacingColumn(
      {super.key,
      super.mainAxisAlignment,
      super.mainAxisSize,
      super.crossAxisAlignment,
      super.textDirection,
      super.verticalDirection,
      super.textBaseline,
      bool leadSpacing = false,
      bool tailSpacing = false,
      required List<Widget> children,
      double spacing = 0})
      : super(children: [
          if (leadSpacing) SizedBox(height: spacing),
          ...spacing > 0
              ? children.addBetweenItems(SizedBox(height: spacing))
              : children,
          if (tailSpacing) SizedBox(height: spacing)
        ]);
}
