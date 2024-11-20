import 'package:flutter/material.dart';

class ViewModelProvider<T> extends InheritedWidget {
  const ViewModelProvider({
    required this.viewModel,
    required super.child,
    super.key,
  });

  final T viewModel;

  static T of<T>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ViewModelProvider<T>>();
    if (provider == null) {
      throw Exception('ViewModelProvider not found in context');
    }
    return provider.viewModel;
  }

  @override
  bool updateShouldNotify(covariant ViewModelProvider<T> oldWidget) {
    if (viewModel != oldWidget.viewModel) {
      return true;
    }
    return false;
  }
}
