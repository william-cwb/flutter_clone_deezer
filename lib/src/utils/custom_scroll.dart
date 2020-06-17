import 'package:flutter/material.dart';

class CustomScroll extends ScrollPhysics {
  CustomScroll({ScrollPhysics parent}) : super(parent: parent);

  bool doSwipeLeftToRight = false;

  @override
  CustomScroll applyTo(ScrollPhysics ancestor) {
    return CustomScroll(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (position.pixels > 0) {
      doSwipeLeftToRight = true;
      print(position.pixels);
      print(doSwipeLeftToRight);
    }
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (doSwipeLeftToRight) {
      return 0.0;
    }

    return value;
  }
}
