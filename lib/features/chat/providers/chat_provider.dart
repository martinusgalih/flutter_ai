import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

final chatServiceProvider = Provider((ref) => ChatService());

final chatLoadingProvider = StateProvider<bool>((ref) => false);

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatService _chatService;
  final StateController<bool> _loadingController;

  ChatMessagesNotifier(this._chatService, this._loadingController) : super([]);

  Future<void> sendMessage(String content) async {
    state = [...state, ChatMessage(content: content, isUser: true)];

    try {
      _loadingController.state = true;
      final response = await _chatService.sendMessage(content);
      state = [...state, ChatMessage(content: response, isUser: false)];
    } catch (e) {
      state = [...state, ChatMessage(content: 'Error: $e', isUser: false)];
    } finally {
      _loadingController.state = false;
    }
  }
}

final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  final loadingController = ref.watch(chatLoadingProvider.notifier);
  return ChatMessagesNotifier(
      ref.watch(chatServiceProvider), loadingController);
});
