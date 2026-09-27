import 'package:flutter/material.dart';

class SyncChannelOptions extends StatelessWidget {
  const SyncChannelOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.9,
      children: [
        _buildChannelCard(
          context: context,
          title: 'WiFi / 4G',
          subtitle: 'Jalur utama',
          icon: Icons.wifi,
          isEnabled: true,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sinkronisasi WiFi akan tersedia saat online')),
            );
          },
        ),
        _buildChannelCard(
          context: context,
          title: 'SMS Gateway',
          subtitle: 'Segera Hadir — Fase 2',
          icon: Icons.sms,
          isEnabled: false,
          onTap: () {},
        ),
        _buildChannelCard(
          context: context,
          title: 'LoRa / Bluetooth',
          subtitle: 'Segera Hadir — Fase 3',
          icon: Icons.bluetooth,
          isEnabled: false,
          onTap: () {},
        ),
        _buildChannelCard(
          context: context,
          title: 'Ekspor SD Card',
          subtitle: 'Ekspor CSV',
          icon: Icons.sd_card,
          isEnabled: true,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil mengekspor ke CSV')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChannelCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.6,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEnabled ? const Color(0xFF27AE60) : Colors.grey.shade300,
              width: isEnabled ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 48,
                    color: isEnabled ? const Color(0xFF1B4332) : Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isEnabled ? const Color(0xFF1B4332) : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isEnabled ? const Color(0xFF2D6A4F) : Colors.grey,
                    ),
                  ),
                ],
              ),
              if (!isEnabled)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Segera Hadir',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
