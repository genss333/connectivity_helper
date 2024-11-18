import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

class ConnectionHelperWidget extends StatefulWidget {
  const ConnectionHelperWidget({
    super.key,
    required this.child,
    this.onSessionTimeout,
    this.onRetry,
  });
  final Widget child;
  final VoidCallback? onSessionTimeout;
  final VoidCallback? onRetry;

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
            body: NoConnectionWidget(onRetry: widget.onRetry),
          );
  }
}

class NoConnectionWidget extends StatefulWidget {
  const NoConnectionWidget({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  State<NoConnectionWidget> createState() => _NoConnectionWidgetState();
}

class _NoConnectionWidgetState extends State<NoConnectionWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              child: Column(
                children: [
                  Text(
                    'ขออภัย',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Icon(Icons.wifi_off, size: 100),
                  SizedBox(height: 20),
                  Text(
                    'ไม่มีการเชื่อมต่ออินเทอร์เน็ต กรุณาตรวจสอบว่าอุปกรณ์ของคุณเชื่อมต่ออินเทอร์เน็ตอยู่หรือไม่',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onRetry?.call();
                },
                child: const Text('ตกลง'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
