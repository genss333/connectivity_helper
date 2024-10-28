import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionHelperWidget extends StatefulWidget {
  const ConnectionHelperWidget({
    super.key,
    required this.child,
    this.noConnectionWidget,
  });
  final Widget child;
  final Widget? noConnectionWidget;

  @override
  State<ConnectionHelperWidget> createState() => _ConnectionHelperWidgetState();
}

class _ConnectionHelperWidgetState extends State<ConnectionHelperWidget> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result.last;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _connectivityResult != ConnectivityResult.none
        ? widget.child
        : Scaffold(
            body: widget.noConnectionWidget ??
                const Center(
                  child: Text("No Connection"),
                ),
          );
  }
}
