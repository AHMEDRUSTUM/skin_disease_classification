import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final bool hasDisease;
  final String? diseaseName;
  final List<String> suggestions;

  const ResultScreen({
    super.key,
    required this.hasDisease,
    this.diseaseName,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    final Color themeColor = hasDisease ? Colors.redAccent : Colors.greenAccent;
    final String titleText = hasDisease ? "Hastalık Tespit Edildi" : "Cildiniz Sağlıklı";
    final IconData iconData = hasDisease ? Icons.warning_amber_rounded : Icons.verified;
    final String statusText = hasDisease
        ? "Maalesef, sistem '${diseaseName ?? 'bir cilt hastalığı'}' tespit etti."
        : "Tebrikler! Cildiniz sağlıklı görünüyor 🌟";

    // Eğer hastalık yoksa gösterilecek sabit öneriler:
    final List<String> healthyTips = [
      "Günde en az 2 litre su içmeyi unutmayın.",
      "Cildinizi her gün nemlendirin.",
      "Güneş koruyucu kullanmak cildinizi korur.",
      "Dengeli beslenmek cilt sağlığına katkı sağlar.",
      "Mutlu bir ruh hali, sağlıklı bir cilt demektir 💚"
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: themeColor),
        title: Text(
          "Tarama Sonucu",
          style: TextStyle(color: themeColor, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Durum İkonu
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [themeColor.withOpacity(0.7), Colors.black],
                  radius: 0.85,
                ),
              ),
              child: Icon(iconData, size: 90, color: Colors.white),
            ),
            const SizedBox(height: 24),

            // Başlık
            Text(
              titleText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Açıklama
            Text(
              statusText,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            // Öneri listesi
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasDisease ? "Dikkat Edilmesi Gerekenler" : "Cilt Sağlığı İçin Öneriler",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  (hasDisease ? suggestions : healthyTips).length,
                  (index) {
                    final item = hasDisease ? suggestions[index] : healthyTips[index];
                    return Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: themeColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 15, color: Colors.white70),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),

            const Spacer(),

            // Ana sayfaya dön butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Ana Sayfaya Dön",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
