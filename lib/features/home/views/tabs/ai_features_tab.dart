import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIFeaturesTab extends StatelessWidget {
  const AIFeaturesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Features'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('Chat with AI'),
              subtitle: const Text("Have a conversation with AI assistant (BlenderBot - Meta's) "),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.push('/chat'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.image_search),
              title: const Text('Image Analysis'),
              subtitle: const Text('Analyze images using AI (Vision Transformer)'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.push('/image-analysis'),
            ),
          ),
        ],
      ),
    );
  }
}