import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef TokenRefreshCallback = Future<String?> Function();
typedef UrlBuilder = Future<String?> Function();

class WebSocketClient {
  final String debugName;
  final UrlBuilder urlBuilder;
  final TokenRefreshCallback? onRefreshToken;
  final VoidCallback? onConnected;
  final VoidCallback? onReconnected;
  final Function(int? closeCode)? onClosed;
  final Function(String message)? onError;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _isManualDisconnect = false;
  bool _isConnected = false;
  int _reconnectAttempts = 0;
  DateTime? _lastPongReceived;
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();

  WebSocketClient({
    required this.debugName,
    required this.urlBuilder,
    this.onRefreshToken,
    this.onConnected,
    this.onReconnected,
    this.onClosed,
    this.onError,
  });

  bool get isConnected => _isConnected;
  DateTime? get lastPongReceived => _lastPongReceived;
  Stream<Map<String, dynamic>> get stream => _eventController.stream;

  Future<void> connect({bool isReconnect = false}) async {
    _isManualDisconnect = false;
    _reconnectTimer?.cancel();

    try {
      final url = await urlBuilder();
      if (url == null || url.isEmpty) {
        debugPrint('[$debugName] Cannot connect: URL or token is null.');
        return;
      }

      final sanitized =
          url.replaceAll(RegExp(r'token=[^&]+'), 'token=[REDACTED]');
      debugPrint('[$debugName] Connecting to: $sanitized');
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _isConnected = true;
      _reconnectAttempts = 0;

      if (isReconnect) {
        onReconnected?.call();
      } else {
        onConnected?.call();
      }

      _startPingTimer();

      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: (err) {
          debugPrint('[$debugName] Error: $err');
          onError?.call(err.toString());
          _handleDisconnect();
        },
        onDone: () {
          final closeCode = _channel?.closeCode;
          debugPrint('[$debugName] Closed (code: $closeCode)');
          if (!_isManualDisconnect) onClosed?.call(closeCode);
          _handleDisconnect(closeCode: closeCode);
        },
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('[$debugName] Connection failed: $e');
      onError?.call(e.toString());
      _handleDisconnect();
    }
  }

  void _handleMessage(dynamic data) {
    try {
      final decoded = jsonDecode(data.toString());
      if (decoded is Map<String, dynamic>) {
        if (decoded['type'] == 'pong') {
          _lastPongReceived = DateTime.now();
        } else if (decoded['type'] == 'error') {
          onError?.call(decoded['message']?.toString() ?? 'WebSocket error');
        }
        _eventController.add(decoded);
      }
    } catch (e) {
      debugPrint('[$debugName] Failed to decode: $e');
    }
  }

  bool send(Map<String, dynamic> data) {
    if (!_isConnected || _channel == null) return false;
    try {
      _channel!.sink.add(jsonEncode(data));
      return true;
    } catch (e) {
      debugPrint('[$debugName] Failed to send: $e');
      return false;
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_isConnected) send({'action': 'ping'});
    });
  }

  void _handleDisconnect({int? closeCode}) async {
    _isConnected = false;
    _pingTimer?.cancel();
    _subscription?.cancel();
    _subscription = null;

    if (_isManualDisconnect || closeCode == 4003) return;

    if (closeCode == 4001 && onRefreshToken != null) {
      try {
        final newToken = await onRefreshToken!();
        if (newToken != null && newToken.isNotEmpty) {
          connect(isReconnect: true);
          return;
        }
        onError?.call('Session expired. Please sign in again.');
        return;
      } catch (e) {
        onError?.call('Session expired. Please sign in again.');
        return;
      }
    }

    _reconnectAttempts++;
    final delay = min(pow(2, _reconnectAttempts - 1).toInt(), 30);
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delay), () {
      if (!_isManualDisconnect) connect(isReconnect: true);
    });
  }

  Future<void> disconnect() async {
    _isManualDisconnect = true;
    _isConnected = false;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _subscription = null;
    try {
      await _channel?.sink.close();
    } catch (_) {}
    _channel = null;
  }

  void dispose() {
    disconnect();
    _eventController.close();
  }
}
