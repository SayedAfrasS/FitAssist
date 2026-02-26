import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      "text": "Hello! I'm your FitAssist AI Coach. How can I help you reach your goals today?",
      "isUser": false,
    }
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({"text": text, "isUser": true});
      _isLoading = true;
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
      final userData = userDoc.data();

      // Backend API URL (for Chrome use localhost, for mobile use your local IP)
      const String apiUrl = "http://localhost:5000/chat";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "message": text,
          "goal": userData?['goal'] ?? "Fitness",
          "activityLevel": userData?['activityLevel'] ?? "Moderate",
          "weeklyDays": userData?['weeklyDays'] ?? 4,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.add({"text": data['reply'], "isUser": false});
          _isLoading = false;
        });
      } else {
        final errorBody = response.body;
        String errorMsg = "Status: ${response.statusCode}";
        try {
          final data = jsonDecode(errorBody);
          errorMsg = data['reply'] ?? errorMsg;
        } catch (_) {}

        setState(() {
          _messages.add({"text": "AI Error (V2): $errorMsg", "isUser": false});
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "text": "Connection Error: $e\nEnsure backend is running at http://localhost:5000",
          "isUser": false
        });
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, color: Colors.blue, size: 20),
            SizedBox(width: 12),
            Text(
              "AI COACH",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 2),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessage(msg['text'], msg['isUser']);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                "AI Coach is typing...",
                style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.white.withAlpha(10),
          borderRadius: BorderRadius.circular(24).copyWith(
            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(24),
            bottomLeft: isUser ? const Radius.circular(24) : const Radius.circular(4),
          ),
          border: isUser ? null : Border.all(color: Colors.white.withAlpha(5)),
          boxShadow: isUser ? [
            BoxShadow(color: Colors.blue.withAlpha(30), blurRadius: 10, offset: const Offset(0, 4))
          ] : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.white.withAlpha(220),
            fontWeight: isUser ? FontWeight.w900 : FontWeight.w500,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withAlpha(100),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withAlpha(5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withAlpha(10)),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: "Message FitAssist AI...",
                  hintStyle: TextStyle(color: Colors.white24, fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade800]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.blue.withAlpha(50), blurRadius: 15, offset: const Offset(0, 4))
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
