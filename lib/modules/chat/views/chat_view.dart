import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/primary_button.dart';
import '../controllers/chat_controller.dart';
import 'widgets/chat_bubble.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Chat Support", style: context.textTheme.titleMedium),
            Text(
              "Online • Typically replies in minutes",
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: const NetworkImage(
                "https://i.pravatar.cc/150?img=5",
              ),
              backgroundColor: context.theme.disabledColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];

                  bool showDateHeader = false;
                  if (index == 0) {
                    showDateHeader = true;
                  } else {
                    final prevMessage = controller.messages[index - 1];
                    final prevDate = DateTime.parse(prevMessage.timestamp);
                    final currDate = DateTime.parse(message.timestamp);

                    if (prevDate.day != currDate.day ||
                        prevDate.month != currDate.month ||
                        prevDate.year != currDate.year) {
                      showDateHeader = true;
                    }
                  }

                  return Column(
                    children: [
                      if (showDateHeader)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: context.theme.dividerColor.withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getDateLabel(message.timestamp),
                                style: context.textTheme.bodySmall?.copyWith(
                                  color:
                                      context.theme.textTheme.bodySmall?.color,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ChatBubble(message: message),
                    ],
                  );
                },
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(
              left: 16,
              top: 12,
              right: 16,
              bottom: 24,
            ),
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.image,
                    color: context.theme.colorScheme.primary,
                  ),
                  onPressed: controller.sendImage,
                ),

                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    decoration: InputDecoration(
                      hintText: "Write your message...",
                      filled: true,
                      fillColor: context.theme.inputDecorationTheme.fillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ),

                const SizedBox(width: 8),

                PrimaryButton(
                  icon: Icons.arrow_forward,
                  onPressed: controller.sendMessage,
                  width: 36,
                  height: 36,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDateLabel(String isoDate) {
    final date = DateTime.parse(isoDate);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return "Today";
    } else if (messageDate == yesterday) {
      return "Yesterday";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}
