import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/env.dart';
import '../../../data/local/database_helper.dart';
import '../../../data/local/models/chat_message.dart';

class ChatController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  late final GenerativeModel _model;
  final _apiKey = Env.geminiApiKay;

  var messages = <ChatMessage>[].obs;
  var isTyping = false.obs;

  String? currentArticleContext;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is String) {
      currentArticleContext = Get.arguments;
    }

    final systemPrompt = Content.system(
      "You are a helpful, polite, and professional Customer Support Agent for a news application called 'Newsflow'. "
      "${currentArticleContext != null ? 'The user is currently reading this article: "$currentArticleContext". Answer questions related to this article if asked.' : ''}"
      "Your goal is to assist users with reading news, account issues, and app navigation. "
      "Keep your answers concise and friendly. If you don't know the answer, ask the user for more details.",
    );

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
      systemInstruction: systemPrompt,
    );
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

    await _generateGeminiResponse(text);
  }

  Future<void> _generateGeminiResponse(String prompt) async {
    try {
      isTyping.value = true;

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final botText = response.text ?? "I'm sorry, I couldn't understand that.";

      final botMsg = ChatMessage(
        text: botText,
        isSender: 0,
        timestamp: DateTime.now().toIso8601String(),
      );
      _addMessage(botMsg);
    } catch (e) {
      final errorMsg = ChatMessage(
        text: "Error: Unable to connect to AI server.",
        isSender: 0,
        timestamp: DateTime.now().toIso8601String(),
      );
      _addMessage(errorMsg);
    } finally {
      isTyping.value = false;
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
