import 'package:flutter/material.dart';

class ViewUtils {
  static Widget loader() {
    return const Center(child: CircularProgressIndicator(strokeWidth: 1));
  }
}
