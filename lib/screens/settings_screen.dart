import 'package:flutter/material.dart';
import '../services/theme_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = "English (US)";
  String _heightUnit = "Centimeters (cm)";
  String _weightUnit = "Kilograms (kg)";

  void _showSelectionDialog(String title, List<String> options, String currentValue, Function(String) onSelect) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: theme.textTheme.titleLarge?.color, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
              const SizedBox(height: 24),
              ...options.map((option) {
                bool isSelected = option == currentValue;
                return GestureDetector(
                  onTap: () {
                    onSelect(option);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.withAlpha(40) : theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? Colors.blue : theme.dividerColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(option, style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
                        if (isSelected) const Icon(Icons.check_circle_rounded, color: Colors.blue),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SETTINGS",
            style: TextStyle(color: theme.textTheme.titleLarge?.color, fontWeight: FontWeight.w900, fontSize: 32, letterSpacing: -1.5),
          ),
          const SizedBox(height: 32),
          
          _section("APPLICATION", [
            _settingTile(Icons.language_rounded, "Language", _language, onTap: () {
              _showSelectionDialog("Select Language", ["English (US)", "Spanish", "French", "German", "Japanese"], _language, (val) {
                setState(() => _language = val);
              });
            }),
            _settingTile(Icons.dark_mode_rounded, "Appearance", ThemeManager().currentThemeName, onTap: () {
              _showSelectionDialog("Select Theme", ["Neo Dark", "Light Mode", "Amoled"], ThemeManager().currentThemeName, (val) {
                ThemeManager().setTheme(val);
              });
            }),
          ]),

          const SizedBox(height: 32),
          _section("UNITS", [
            _settingTile(Icons.straighten_rounded, "Height Unit", _heightUnit, onTap: () {
              _showSelectionDialog("Height Metric", ["Centimeters (cm)", "Inches (in)"], _heightUnit, (val) {
                setState(() => _heightUnit = val);
              });
            }),
            _settingTile(Icons.monitor_weight_rounded, "Weight Unit", _weightUnit, onTap: () {
              _showSelectionDialog("Weight Metric", ["Kilograms (kg)", "Pounds (lbs)"], _weightUnit, (val) {
                setState(() => _weightUnit = val);
              });
            }),
          ]),

          const SizedBox(height: 32),
          _section("PREMIUM", [
            _settingTile(Icons.star_rounded, "Subscription", "Active Pro Plan", active: true, onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Member since Oct 2025")));
            }),
            _settingTile(Icons.cloud_done_rounded, "Cloud Sync", "Last sync: Just now", onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cloud backup successful!")));
            }),
          ]),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white24, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _settingTile(IconData icon, String title, String value, {bool active = false, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: active ? Colors.blue : theme.hintColor),
              const SizedBox(width: 20),
              Text(title, style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              Text(value, style: TextStyle(color: active ? Colors.blue : theme.hintColor, fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
