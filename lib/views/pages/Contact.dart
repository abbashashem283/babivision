import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/Utils/popups/Utils.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/forms/LaraForm.dart';
import 'package:babivision/views/popups/Snackbars.dart';
import 'package:flutter/material.dart';

/// A modern, responsive "Contact Us" page
/// where users can enter their name, email, and message.
/// This version does not validate locally — validation is expected
/// to happen on your backend (server-side).
class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  // --- Text controllers for each input field ---
  // They let us read what's typed in the text fields.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  GlobalKey<LaraformState> _formKey = GlobalKey<LaraformState>();

  @override
  void dispose() {
    // Always dispose controllers when the widget is destroyed
    // to prevent memory leaks.
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// This function runs when the "Send Message" button is pressed.
  /// In a real app, you'd send the data to your server here.
  void _submitForm() {
    // For now, just show a small popup message (SnackBar)

    // Print to console — helpful during debugging.
    _formKey.currentState!.submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Light gray background to contrast the white card
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5, // thin shadow for separation
        // --- Back button on the top left ---
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),

        // --- App bar title ---
        title: Text(
          "Contact Us",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            //!
            fontSize: context.responsiveExplicit(
              fallback: 16,
              onHeight: {1024: 24},
            ),
          ),
        ),
        centerTitle: true,
      ),

      // The page body: scrollable and centered content
      body: Center(
        // SingleChildScrollView allows scrolling if keyboard appears
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),

          // --- The white card container ---
          child: Laraform(
            key: _formKey,
            fetcher:
                () => Http.post("/api/feedback/add", {
                  "name": _nameController.text,
                  "email": _emailController.text,
                  "message": _messageController.text,
                }),
            onFetched: (response) {
              final data = response.data;
              if (data["type"] == "success") {
                return {"type": MessageType.error};
              } else if (data["type"] == "error") {
                showSnackbar(
                  context: context,
                  snackBar: TextSnackBar.error(
                    message: "Couldn't send feedback!",
                  ),
                );
              }
            },
            builder:
                (errors) => Container(
                  height: context.percentageOfHeight(.5),
                  width: double.infinity.clamp(
                    0,
                    (context.responsiveExplicit(
                          fallback: 500,
                          onHeight: {1024: context.percentageOfWidth(.7)},
                        )
                        as double),
                  ),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      // subtle shadow for a card-like effect
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  // --- Inside the card: the form content ---
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Page title
                      Text(
                        "We’d love to hear from you 👋",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Subtitle text
                      const Text(
                        "Send us a message and we’ll get back to you as soon as possible.",
                        style: TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // --- Name input field ---
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        errorText: errors("name"),
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 16),

                      // --- Email input field ---
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        errorText: errors("email"),
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 16),

                      // --- Message input field ---
                      _buildTextField(
                        controller: _messageController,
                        label: 'Message',
                        errorText: errors("message"),
                        icon: Icons.message_outlined,
                        maxLines: 5,
                      ),

                      const SizedBox(height: 24),

                      // --- Send button ---
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text("Send Message"),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }

  /// Builds a styled text input field.
  ///
  /// [controller] → manages the text
  /// [label] → floating label text above the input
  /// [icon] → small icon at the start of the input
  /// [keyboardType] → lets you use email/number keyboards
  /// [maxLines] → for message fields or multi-line text
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        // Icon shown on the left side
        prefixIcon: Icon(icon, color: Colors.purple),

        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),

        errorText: errorText,

        // This label automatically "jumps" up when focused or not empty
        labelText: label,

        // Adds a filled background (light gray)
        filled: true,
        fillColor: const Color(0xFFF5F6FA),

        // Rounded corners and no border lines
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        // Adjusts internal spacing
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
      ),
    );
  }
}
