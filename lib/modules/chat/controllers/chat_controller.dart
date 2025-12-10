import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/local/database_helper.dart';
import '../../../data/local/models/chat_message.dart';

class ChatController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  var messages = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadChatHistory();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void loadChatHistory() async {
    final history = await _dbHelper.getChatHistory();
    messages.assignAll(history);
    _scrollToBottom();
  }

  void sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final userMsg = ChatMessage(
      text: text,
      isSender: 1,
      timestamp: DateTime.now().toIso8601String(),
    );

    _addMessage(userMsg);
    textController.clear();

    _simulateBotReply();
  }

  void sendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final userMsg = ChatMessage(
        text: "Sent an image",
        imagePath: image.path,
        isSender: 1,
        timestamp: DateTime.now().toIso8601String(),
      );
      _addMessage(userMsg);
      _simulateBotReply();
    }
  }

  void _simulateBotReply() {
    Future.delayed(const Duration(seconds: 2), () {
      final botMsg = ChatMessage(
        text: "Thanks! I'll check the details for you.",
        isSender: 0,
        timestamp: DateTime.now().toIso8601String(),
      );
      _addMessage(botMsg);
    });
  }

  void _addMessage(ChatMessage msg) async {
    messages.add(msg);
    await _dbHelper.insertMessage(msg);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
