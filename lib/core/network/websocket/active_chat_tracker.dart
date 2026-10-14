import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Class that safely tracks the currently active conversation ID in memory.
class ActiveChatTracker {
  static dynamic _activeConversationId;
  static final Set<String> _recentlyReadIds = {};

  static dynamic get activeConversationId => _activeConversationId;

  static void setActiveId(dynamic id) {
    _activeConversationId = id;
    if (id != null) {
      _recentlyReadIds.add('$id');
    }
  }

  static void markAsRecentlyRead(dynamic id) {
    if (id != null) {
      _recentlyReadIds.add('$id');
    }
  }

  static bool isRecentlyRead(dynamic id) {
    if (id == null) return false;
    return _recentlyReadIds.contains('$id');
  }

  static void clearIfMatch(dynamic id) {
    if (id != null && '$_activeConversationId' == '$id') {
      _activeConversationId = null;
    }
  }

  static bool isConversationActive(dynamic conversationId) {
    if (_activeConversationId == null || conversationId == null) return false;
    return '$_activeConversationId' == '$conversationId';
  }
}

/// Holds the conversation ID that is currently open on screen.
final activeChatConversationIdProvider =
    NotifierProvider<ActiveChatConversationIdNotifier, dynamic>(
  ActiveChatConversationIdNotifier.new,
);

class ActiveChatConversationIdNotifier extends Notifier<dynamic> {
  @override
  dynamic build() => ActiveChatTracker.activeConversationId;

  void setActiveId(dynamic id) {
    ActiveChatTracker.setActiveId(id);
    state = id;
  }

  void clearIfMatch(dynamic id) {
    ActiveChatTracker.clearIfMatch(id);
    state = ActiveChatTracker.activeConversationId;
  }
}

/// Holds the total unread message count across all conversations.
final unreadMessagesCountProvider =
    NotifierProvider<UnreadMessagesCountNotifier, int>(
  UnreadMessagesCountNotifier.new,
);

class UnreadMessagesCountNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setCount(int count) {
    state = count < 0 ? 0 : count;
  }

  void decrement([int by = 1]) {
    final next = state - by;
    state = next < 0 ? 0 : next;
  }

  void clear() {
    state = 0;
  }
}
