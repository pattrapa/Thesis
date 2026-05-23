import 'package:flutter/material.dart';

import 'websocket_service.dart';

class VoiceCommandPage extends StatefulWidget {
  const VoiceCommandPage({super.key});

  @override
  State<VoiceCommandPage> createState() => _VoiceCommandPageState();
}

class _VoiceCommandPageState extends State<VoiceCommandPage> {
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void sendVoiceText() {
  final text = textController.text.trim();

  if (text.isEmpty) {
    webSocketService.statusText.value = 'กรุณาพิมพ์ข้อความก่อนส่ง';
    return;
  }

  print('Sending INPUT_TEXT: $text');

  webSocketService.sendCommand(
    command: 'INPUT_TEXT',
    text: text,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Command'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.mic,
              size: 80,
            ),

            const SizedBox(height: 24),

            const Text(
              'หน้าป้อนคำสั่งด้วยเสียง',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'ตอนนี้ใช้การพิมพ์ข้อความจำลองก่อน ภายหลังค่อยเปลี่ยนเป็น Voice-to-Text',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'ข้อความคำสั่ง',
                hintText: 'เช่น machine learning',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(237, 243, 114, 88),
                foregroundColor: Colors.white,
              ),
              onPressed: sendVoiceText,
              icon: const Icon(Icons.send),
              label: const Text('Send Text'),
            ),

            const SizedBox(height: 20),

            ValueListenableBuilder<String>(
              valueListenable: webSocketService.statusText,
              builder: (context, status, child) {
                return Text(
                  status,
                  textAlign: TextAlign.center,
                );
              },
            ),

            const SizedBox(height: 8),

            ValueListenableBuilder<String>(
              valueListenable: webSocketService.lastAck,
              builder: (context, ack, child) {
                return Text(
                  'Last ACK: $ack',
                  textAlign: TextAlign.center,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}