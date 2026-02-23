import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SETTINGS",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32, letterSpacing: -1.5),
          ),
          const SizedBox(height: 32),
          
          _settingGroup("Application", [
            _settingTile(Icons.language_rounded, "Language", "English (US)"),
            _settingTile(Icons.dark_mode_rounded, "Appearance", "Neo Dark"),
          ]),
          
          const SizedBox(height: 32),
          
          _settingGroup("Units", [
            _settingTile(Icons.straighten_rounded, "Height Unit", "Centimeters (cm)"),
            _settingTile(Icons.monitor_weight_rounded, "Weight Unit", "Kilograms (kg)"),
          ]),
          
          const SizedBox(height: 32),
          
          _settingGroup("Premium", [
            _settingTile(Icons.star_rounded, "Subscription", "Active Pro Plan", active: true),
            _settingTile(Icons.restore_rounded, "Cloud Sync", "Last sync: 2m ago"),
          ]),
        ],
      ),
    );
  }

  Widget _settingGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _settingTile(IconData icon, String title, String value, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withAlpha(5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: active ? Colors.blue : Colors.white38),
          const SizedBox(width: 20),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          Text(value, style: TextStyle(color: active ? Colors.blue : Colors.white38, fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
