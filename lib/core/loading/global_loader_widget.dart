import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Provider klassingizni import qiling

class GlobalLoader extends StatelessWidget {
  final Widget child;
  const GlobalLoader({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalLoadingProvider>(
      builder:(context,value,s)=> Stack(
        children: [
          child,
          if (value.isLoading)
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (value.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class GlobalLoadingProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}