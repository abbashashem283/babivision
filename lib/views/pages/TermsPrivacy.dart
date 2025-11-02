import 'package:flutter/material.dart';

/// Terms & Privacy page for Babivision (Flutter)
/// - Responsive: constrained width on large screens, fluid on small screens
/// - Scrollable: long legal text scrolls naturally
/// - Readable typography and spacing for accessibility
/// - Heavily commented so you understand structure and behavior
class TermsPrivacyPage extends StatelessWidget {
  const TermsPrivacyPage({super.key});

  // Last updated date shown in the footer
  static const String _lastUpdated = 'November 2, 2025';

  @override
  Widget build(BuildContext context) {
    // Provide simple theme/colors used inside the page so it's easy to change.
    // You can move these to a shared theme file in a real app.
    const background = Color(0xFFF8F9FB); // soft gray page background
    const cardColor = Colors.white;
    const headingColor = Color(0xFF0F172A); // dark text
    const accentColor = Colors.purple; // clinic blue accent
    const bodyColor = Color(0xFF475569); // muted body text

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Terms & Privacy',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      // SingleChildScrollView wraps entire content so long legal text can scroll.
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          // Center + ConstrainedBox keeps content readable on very wide screens.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Intro card: small logo area + short intro text
                  _buildIntroCard(
                    cardColor: cardColor,
                    headingColor: headingColor,
                    bodyColor: bodyColor,
                    accentColor: accentColor,
                  ),

                  const SizedBox(height: 20),

                  // Terms of Service (main white content card)
                  _buildContentCard(
                    title: 'Terms of Service',
                    paragraphs: _termsParagraphs(),
                    cardColor: cardColor,
                    headingColor: headingColor,
                    bodyColor: bodyColor,
                  ),

                  const SizedBox(height: 16),

                  // Privacy Policy
                  _buildContentCard(
                    title: 'Privacy Policy',
                    paragraphs: _privacyParagraphs(),
                    cardColor: cardColor,
                    headingColor: headingColor,
                    bodyColor: bodyColor,
                  ),

                  const SizedBox(height: 16),

                  // Cookies & Analytics
                  _buildContentCard(
                    title: 'Cookies & Analytics',
                    paragraphs: _cookiesParagraphs(),
                    cardColor: cardColor,
                    headingColor: headingColor,
                    bodyColor: bodyColor,
                  ),

                  const SizedBox(height: 16),

                  // Contact & Data Requests
                  _buildContentCard(
                    title: 'Contact & Data Requests',
                    paragraphs: _contactParagraphs(),
                    cardColor: cardColor,
                    headingColor: headingColor,
                    bodyColor: bodyColor,
                  ),

                  const SizedBox(height: 24),

                  // Footer with small text and Last Updated
                  _buildFooter(cardColor: cardColor, accentColor: accentColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Small intro header card with optional logo placeholder and summary
  Widget _buildIntroCard({
    required Color cardColor,
    required Color headingColor,
    required Color bodyColor,
    required Color accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // logo placeholder — replace with Image.asset or Network image
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.remove_red_eye_rounded,
                size: 34,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Title + one-line summary
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Babivision Optician Clinic',
                  style: TextStyle(
                    color: headingColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Our terms and privacy practices explain how we protect your data and how we operate as a clinic.',
                  style: TextStyle(color: bodyColor, fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Generic card builder for long text sections
  Widget _buildContentCard({
    required String title,
    required List<Widget> paragraphs,
    required Color cardColor,
    required Color headingColor,
    required Color bodyColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section heading
          Text(
            title,
            style: TextStyle(
              color: headingColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          // Paragraphs (pre-built widgets)
          ...paragraphs,
        ],
      ),
    );
  }

  /// Footer with copyright + last updated
  Widget _buildFooter({required Color cardColor, required Color accentColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Babivision Optician Clinic © 2025',
            style: TextStyle(
              color: Colors.black.withOpacity(0.75),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Last updated: $_lastUpdated',
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // -------------------------
  // Section content helpers
  // Each returns a list of Widgets (Text, bullets, spacers) so the
  // _buildContentCard can just spread (...) them into the column.
  // -------------------------

  List<Widget> _termsParagraphs() {
    const bodyColor = Color(0xFF475569);
    return [
      const Text(
        'By using our services (including bookings, consultations, or purchasing eyewear), you agree to these Terms of Service. These terms govern how we provide services at Babivision and your rights as a patient or visitor.',
        style: TextStyle(fontSize: 14, height: 1.6, color: bodyColor),
      ),
      const SizedBox(height: 12),
      _bulletItem(
        'Appointments: Please arrive on time. You may reschedule up to 24 hours in advance.',
      ),
      _bulletItem(
        'Payments: Payment is due at the time of service unless prior arrangements have been made.',
      ),
      _bulletItem(
        'Cancellations & Refunds: Refunds for products follow our refund policy which will be communicated at point of sale.',
      ),
      _bulletItem(
        'Conduct: We reserve the right to refuse service in cases of inappropriate behavior.',
      ),
      const SizedBox(height: 6),
    ];
  }

  List<Widget> _privacyParagraphs() {
    const bodyColor = Color(0xFF475569);
    return [
      const Text(
        'We respect your privacy. This section explains what information we collect, why we collect it, and how we protect it.',
        style: TextStyle(fontSize: 14, height: 1.6, color: bodyColor),
      ),
      const SizedBox(height: 12),
      _subHeading('Information We Collect'),
      const SizedBox(height: 6),
      const Text(
        'When you book an appointment or receive care, we collect basic contact information (name, email, phone), clinical notes related to your vision, and prescription information where applicable.',
        style: TextStyle(fontSize: 14, height: 1.6, color: bodyColor),
      ),
      const SizedBox(height: 10),
      _subHeading('How We Use Your Information'),
      const SizedBox(height: 6),
      const Text(
        'We use patient information to schedule appointments, provide eye exams, issue prescriptions, and communicate important follow-ups. We do not sell your personal data to third parties.',
        style: TextStyle(fontSize: 14, height: 1.6, color: bodyColor),
      ),
      const SizedBox(height: 10),
      _subHeading('Data Protection'),
      const SizedBox(height: 6),
      const Text(
        'Patient records are stored securely. Access is restricted to authorized clinic staff. We use best-practice safeguards to protect data from unauthorized access.',
        style: TextStyle(fontSize: 14, height: 1.6, color: bodyColor),
      ),
      const SizedBox(height: 10),
    ];
  }

  List<Widget> _cookiesParagraphs() {
    const bodyColor = Color(0xFF475569);
    return [
      const Text(
        'Our website may use cookies or analytics tools to understand usage patterns and improve the user experience. These analytics are anonymized and do not include personal health information.',
        style: TextStyle(fontSize: 14, height: 1.6, color: bodyColor),
      ),
      const SizedBox(height: 12),
      _bulletItem(
        'Essential cookies: required for site navigation and security.',
      ),
      _bulletItem(
        'Analytics cookies: help us understand usage and improve our services.',
      ),
      const SizedBox(height: 6),
    ];
  }

  List<Widget> _contactParagraphs() {
    const bodyColor = Color(0xFF475569);
    return [
      const Text(
        'If you have questions about these terms or want to request access to your data, please contact our support team. We handle requests in a timely manner and will respond with required next steps.',
        style: TextStyle(fontSize: 14, height: 1.6, color: bodyColor),
      ),
      const SizedBox(height: 12),
      Row(
        children: const [
          Icon(Icons.email_outlined, size: 18, color: Colors.blueAccent),
          SizedBox(width: 8),
          Text('support@babivision.com', style: TextStyle(fontSize: 14)),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: const [
          Icon(Icons.phone_outlined, size: 18, color: Colors.blueAccent),
          SizedBox(width: 8),
          Text('+961 1 555 123', style: TextStyle(fontSize: 14)),
        ],
      ),
      const SizedBox(height: 12),
      const Text(
        'Mailing address:\nBabivision Clinic, Hamra, Beirut, Lebanon',
        style: TextStyle(fontSize: 14, height: 1.5),
      ),
      const SizedBox(height: 10),
    ];
  }

  // -------------------------
  // Small helper widgets used inside content lists
  // -------------------------

  // Bullet list row
  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8, color: Colors.black54),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section sub-heading used in the privacy card
  Widget _subHeading(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F172A),
      ),
    );
  }
}
