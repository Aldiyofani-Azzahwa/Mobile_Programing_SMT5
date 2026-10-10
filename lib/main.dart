import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// Palet warna gentle & modern
class AppColors {
  static const bg1 = Color(0xFFEAF0F7);
  static const bg2 = Color(0xFFF7EFE9);
  static const primary = Color(0xFF5B7DB1);
  static const primarySoft = Color(0xFFE3EBF6);
  static const sage = Color(0xFF7FA38B);
  static const sageSoft = Color(0xFFE5F0E8);
  static const textDark = Color(0xFF2D3748);
  static const textGrey = Color(0xFF7A8699);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kartu Profil',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
      ),
      home: const ProfileCardPage(),
    );
  }
}

class ProfileCardPage extends StatelessWidget {
  const ProfileCardPage({super.key});

  static const String nama = 'Aldiyofani Az-Zahwa';
  static const String prodi = 'Mahasiswa Sistem Informasi';
  static const String nim = '4124025';
  static const String asal = 'Mancar';
  static const String deskripsi =
      'Mahasiswa Sistem Informasi yang antusias belajar pemrograman mobile '
      'dan pengembangan aplikasi. Aktif berorganisasi, suka berkolaborasi, '
      'dan senang membangun hal yang bermanfaat.';
  static const List<String> skills = [
    'Flutter',
    'Dart',
    'UI Design',
    'Problem Solving',
    'Teamwork',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bg1, AppColors.bg2],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: const ProfileCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      // Responsif: > 600 = Row (berdampingan), <= 600 = Column (bertumpuk)
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = MediaQuery.of(context).size.width > 600;

          if (isWide) {
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfilePhoto(size: 170),
                SizedBox(width: 36),
                Expanded(child: ProfileInfo(centered: false)),
              ],
            );
          }
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfilePhoto(size: 150),
              SizedBox(height: 24),
              ProfileInfo(centered: true),
            ],
          );
        },
      ),
    );
  }
}

/// Avatar cowok + badge "Available" memakai Stack & Positioned
class ProfilePhoto extends StatelessWidget {
  final double size;
  const ProfilePhoto({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 16,
      height: size + 16,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.primarySoft, width: 4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: MaleAvatar(size: size - 18),
          ),
          Positioned(
            bottom: 8,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.sage,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'Available',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar cowok digambar dengan CustomPaint (tanpa file gambar)
class MaleAvatar extends StatelessWidget {
  final double size;
  const MaleAvatar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _MaleAvatarPainter()),
      ),
    );
  }
}

class _MaleAvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final fill = Paint()..style = PaintingStyle.fill;

    // Latar
    fill.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFDCE8F5), Color(0xFFF1E9F5)],
    ).createShader(Rect.fromLTWH(0, 0, w, w));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, w), fill);
    fill.shader = null;

    // Badan / kemeja
    fill.color = const Color(0xFF6F8FBF);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.5, w * 1.02),
          width: w * 0.80,
          height: w * 0.62),
      fill,
    );

    // Leher
    fill.color = const Color(0xFFE0AE86);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(w * 0.5, w * 0.68),
            width: w * 0.15,
            height: w * 0.16),
        Radius.circular(w * 0.04),
      ),
      fill,
    );

    // Kerah putih
    fill.color = Colors.white;
    final collar = Path()
      ..moveTo(w * 0.42, w * 0.73)
      ..lineTo(w * 0.5, w * 0.83)
      ..lineTo(w * 0.58, w * 0.73)
      ..lineTo(w * 0.54, w * 0.72)
      ..lineTo(w * 0.5, w * 0.77)
      ..lineTo(w * 0.46, w * 0.72)
      ..close();
    canvas.drawPath(collar, fill);

    // Telinga
    fill.color = const Color(0xFFEBBB94);
    canvas.drawCircle(Offset(w * 0.325, w * 0.48), w * 0.035, fill);
    canvas.drawCircle(Offset(w * 0.675, w * 0.48), w * 0.035, fill);

    // Wajah
    fill.color = const Color(0xFFF3C9A5);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.5, w * 0.47),
          width: w * 0.35,
          height: w * 0.42),
      fill,
    );

    // Rambut
    fill.color = const Color(0xFF2F2F3D);
    final hair = Path()
      ..moveTo(w * 0.32, w * 0.46)
      ..quadraticBezierTo(w * 0.28, w * 0.16, w * 0.5, w * 0.15)
      ..quadraticBezierTo(w * 0.72, w * 0.16, w * 0.68, w * 0.46)
      ..quadraticBezierTo(w * 0.65, w * 0.34, w * 0.56, w * 0.31)
      ..quadraticBezierTo(w * 0.46, w * 0.35, w * 0.37, w * 0.31)
      ..quadraticBezierTo(w * 0.33, w * 0.36, w * 0.32, w * 0.46)
      ..close();
    canvas.drawPath(hair, fill);

    // Alis
    final brow = Paint()
      ..color = const Color(0xFF2F2F3D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.013
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(w * 0.40, w * 0.425), Offset(w * 0.46, w * 0.42), brow);
    canvas.drawLine(
        Offset(w * 0.54, w * 0.42), Offset(w * 0.60, w * 0.425), brow);

    // Mata
    fill.color = const Color(0xFF2F2F3D);
    canvas.drawCircle(Offset(w * 0.43, w * 0.47), w * 0.017, fill);
    canvas.drawCircle(Offset(w * 0.57, w * 0.47), w * 0.017, fill);

    // Hidung
    final nose = Paint()
      ..color = const Color(0xFFD9A57F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.01
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(w * 0.5, w * 0.48), Offset(w * 0.49, w * 0.52), nose);

    // Senyum
    final smile = Paint()
      ..color = const Color(0xFFB5654A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.014
      ..strokeCap = StrokeCap.round;
    final mouth = Path()
      ..moveTo(w * 0.44, w * 0.57)
      ..quadraticBezierTo(w * 0.5, w * 0.62, w * 0.56, w * 0.57);
    canvas.drawPath(mouth, smile);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Nama, prodi, deskripsi, organisasi, kontak (Row), dan skill (Wrap + Chip)
class ProfileInfo extends StatelessWidget {
  final bool centered;
  const ProfileInfo({super.key, required this.centered});

  @override
  Widget build(BuildContext context) {
    final align =
    centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;
    final wrapAlign = centered ? WrapAlignment.center : WrapAlignment.start;

    return Column(
      crossAxisAlignment: align,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ProfileCardPage.nama,
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          ProfileCardPage.prodi,
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: wrapAlign,
          spacing: 16,
          runSpacing: 6,
          children: const [
            InfoText(icon: Icons.badge_outlined, text: 'NIM ${ProfileCardPage.nim}'),
            InfoText(
                icon: Icons.location_on_outlined, text: ProfileCardPage.asal),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          ProfileCardPage.deskripsi,
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 20),

        // Organisasi
        Wrap(
          alignment: wrapAlign,
          spacing: 10,
          runSpacing: 10,
          children: const [
            OrgTile(
              icon: Icons.account_balance_rounded,
              title: 'Anggota DPM',
              color: AppColors.primary,
              softColor: AppColors.primarySoft,
            ),
            OrgTile(
              icon: Icons.groups_rounded,
              title: 'Aktif di UKM PN',
              color: AppColors.sage,
              softColor: AppColors.sageSoft,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 3 ikon kontak memakai Row
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContactIcon(icon: Icons.email_rounded),
            SizedBox(width: 12),
            ContactIcon(icon: Icons.phone_rounded),
            SizedBox(width: 12),
            ContactIcon(icon: Icons.code_rounded),
          ],
        ),
        const SizedBox(height: 20),

        // Skill memakai Wrap + Chip (otomatis pindah baris)
        Wrap(
          alignment: wrapAlign,
          spacing: 8,
          runSpacing: 8,
          children: ProfileCardPage.skills
              .map(
                (s) => Chip(
              label: Text(s),
              backgroundColor: AppColors.primarySoft,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              labelStyle: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textGrey),
        const SizedBox(width: 5),
        Text(text,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
      ],
    );
  }
}

class OrgTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color softColor;
  const OrgTile({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.softColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class ContactIcon extends StatelessWidget {
  final IconData icon;
  const ContactIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: AppColors.primary, size: 22),
    );
  }
}