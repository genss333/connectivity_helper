# Connectivity Helper

## Set up
- connectivity_plus : https://pub.dev/packages/connectivity_plus
- local_session_timeout: https://pub.dev/packages?q=local_session_timeout

## Example

if you use this package and get

```dart
GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'TDD App',
    localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
    ],
    builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: ConnectionHelperWidget(
            child: child!,
            onSessionTimeout: () {},
          ),
        );
    },
);
```
