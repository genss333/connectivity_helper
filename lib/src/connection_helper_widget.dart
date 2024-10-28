import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

class ConnectionHelperWidget extends StatefulWidget {
  const ConnectionHelperWidget({
    super.key,
    required this.child,
    this.onSessionTimeout,
    this.noConnectionWidget,
  });
  final Widget child;
  final VoidCallback? onSessionTimeout;
  final Widget? noConnectionWidget;

  @override
  State<ConnectionHelperWidget> createState() => _ConnectionHelperWidgetState();
}

class _ConnectionHelperWidgetState extends State<ConnectionHelperWidget> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 10),
      invalidateSessionForUserInactivity: const Duration(minutes: 15));

  @override
  void initState() {
    super.initState();

    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        widget.onSessionTimeout?.call();
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        widget.onSessionTimeout?.call();
      }
    });

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result.last;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _connectivityResult != ConnectivityResult.none
        ? SessionTimeoutManager(
            sessionConfig: sessionConfig,
            child: widget.child,
          )
        : Scaffold(
            body: widget.noConnectionWidget ??
                const Center(
                  child: Text("No Connection"),
                ),
          );
  }
}
