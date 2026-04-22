import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmay_application/nav.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              // Logo
              const _StackOneLogo(),
              const SizedBox(height: 64),
              // Title
              const Text(
                'Create An Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 32),
              // Email Field
              _CustomTextField(
                controller: _emailController,
                hintText: 'Your Email Address',
              ),
              const SizedBox(height: 16),
              // Password Field
              _CustomTextField(
                controller: _passwordController,
                hintText: 'You Password',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              // Confirm Password Field
              _CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Your Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 24),
              // Login Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to login
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already An Have an Account? ',
                      style: TextStyle(
                        color: Color(0xFFE57373), // A soft coral/orange color matching the image
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w400, // In the image it's not strictly bolder, just the same color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Sign Up Button
              ElevatedButton(
                onPressed: () {
                  context.push(AppRoutes.welcome);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BFF), // Bright blue
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Divider
              const Center(
                child: Text(
                  'Or Sign Up With',
                  style: TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Google Button
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF333333),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
                  height: 24,
                  width: 24,
                  errorBuilder: (context, error, stackTrace) => const Text(
                    'G',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), // Fallback if network image fails or isn't perfect, we can use a custom G
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Apple Button
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1D20), // Almost black
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.apple, size: 24),
                label: const Text(
                  'Continue with Apple',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const _CustomTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF757575),
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF007BFF)),
        ),
      ),
    );
  }
}

class _StackOneLogo extends StatelessWidget {
  const _StackOneLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Custom Stack Icon
        SizedBox(
          width: 50,
          height: 40,
          child: CustomPaint(
            painter: _StackIconPainter(),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'StackOne',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            letterSpacing: -1.5,
          ),
        ),
      ],
    );
  }
}

class _StackIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // A simplified stacked diamond logo matching the image
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFE0E0E0); // Light grey top diamond

    final path1 = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height * 0.4)
      ..lineTo(size.width / 2, size.height * 0.8)
      ..lineTo(0, size.height * 0.4)
      ..close();
    
    canvas.drawPath(path1, paint);

    final path2 = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width / 2, size.height * 0.9)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width * 0.9, size.height * 0.55)
      ..lineTo(size.width / 2, size.height) // bottom tip
      ..lineTo(size.width * 0.1, size.height * 0.55)
      ..close();

    // Actually, let's make it simpler. A thick black stroke for the bottom layer
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeJoin = StrokeJoin.round;

    final path3 = Path()
      ..moveTo(size.width * 0.05, size.height * 0.55)
      ..lineTo(size.width / 2, size.height * 0.95)
      ..lineTo(size.width * 0.95, size.height * 0.55);

    canvas.drawPath(path3, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
