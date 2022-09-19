import 'package:flutter/material.dart';

Color EvaluateRatingColor(double rating) {
  if (rating < 3) return Colors.red;
  if (rating < 5) return Colors.deepOrange;
  if (rating < 6.5) return Colors.yellow;
  if (rating < 7.5) return Colors.lightGreen;
  if (rating < 8.5) return Colors.green;
  return Colors.greenAccent;
}
