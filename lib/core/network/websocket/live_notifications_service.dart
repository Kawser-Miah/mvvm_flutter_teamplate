import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sp_service/secure_storage_service.dart';
import '../api_endpoints.dart';
import 'active_chat_tracker.dart';
import 'websocket_client.dart';
import 'websocket_token_helper.dart';

final liveNotificationsServiceProvider =
    Provider<LiveNotificationsService>((ref) {
  final storageService = ref.watch(secureStorageServiceProvider);
  final tokenHelper = WebSocketTokenHelper(storageService);
  final service = LiveNotificationsService(
    storageService: storageService,
    tokenHelper: tokenHelper,
  )..onUnreadCountChanged = (count) {
      ref.read(unreadMessagesCountProvider.notifier).setCount(count);
    };
  ref.onDispose(() => service.dispose());
  return service;
});

class LiveNotificationsService {
  final SecureStorageService storageService;
  final WebSocketTokenHelper tokenHelper;
  Function(int count)? onUnreadCountChanged;

  WebSocketClient? _client;
  bool _isStarted = false;
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();

  LiveNotificationsService({
    required this.storageService,
    required this.tokenHelper,
  });

  bool get isConnected => _client?.isConnected ?? false;
  Stream<Map<String, dynamic>> get stream => _eventController.stream;

  Future<void> init() async {
    if (_isStarted) return;
    final token = await storageService.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('[LiveNotifications] No access token. Waiting for sign in.');
      return;
    }

    _isStarted = true;
    _setupClient();
    await _client?.connect();
  }

  void _setupClient() {
    _client?.dispose();
    _client = WebSocketClient(
      debugName: 'LiveNotifications',
      urlBuilder: () async {
        final token = await tokenHelper.getAccessToken();
        if (token == null || token.isEmpty) return null;
        return ApiEndpoints.wsNotificationsUrl(token);
      },
      onRefreshToken: () => tokenHelper.refreshAccessToken(),
      onConnected: () {
        debugPrint('[LiveNotifications] Connected. Requesting unread count...');
        _client?.send({'action': 'get_unread_count'});
      },
      onReconnected: () {
        debugPrint('[LiveNotifications] Reconnected. Syncing unread count...');
        _client?.send({'action': 'get_unread_count'});
      },
      onError: (msg) => debugPrint('[LiveNotifications] Error: $msg'),
    );

    _client!.stream.listen((event) {
      _handleEvent(event);
      _eventController.add(event);
    });
  }

  void _handleEvent(Map<String, dynamic> event) async {
    final type = event['type']?.toString();
    debugPrint('[LiveNotifications] Event received: $type');

    switch (type) {
      case 'unread_count':
      case 'new_message_notification':
        final totalUnread =
            ((event['total_unread'] ?? event['unread_count']) as num?)?.toInt();
        if (totalUnread != null) {
          onUnreadCountChanged?.call(totalUnread);
        }
        break;

      case 'notification':
        break;
    }
  }

  void refreshUnreadCount() {
    _client?.send({'action': 'get_unread_count'});
  }

  Future<void> disconnect() async {
    _isStarted = false;
    await _client?.disconnect();
  }

  void dispose() {
    _client?.dispose();
    _client = null;
    _isStarted = false;
    _eventController.close();
  }
}
