import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController();

  bool _isLoading = false;
  bool _isSuccess = false;

  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEND RESET LINK
  // ============================================================

  Future<void> _sendResetLink() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Temporary simulated password reset.
    // Firebase Authentication will replace this later.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isSuccess = true;
    });
  }

  // ============================================================
  // EMAIL VALIDATION
  // ============================================================

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email.';
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email.';
    }

    return null;
  }

  // ============================================================
  // GO TO LOGIN
  // ============================================================

  void _goToLogin() {
    if (_isLoading) return;

    context.go('/login');
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallHeight =
                constraints.maxHeight < 700;

            return SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                24,
                isSmallHeight ? 10 : 14,
                24,
                20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight -
                      (isSmallHeight ? 30 : 34),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 430,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          // ==================================================
                          // LOGO
                          // ==================================================

                          _buildLogo(),

                          SizedBox(
                            height:
                                isSmallHeight ? 14 : 16,
                          ),

                          // ==================================================
                          // CONTENT
                          // ==================================================

                          if (_isSuccess)
                            _buildSuccessContent(
                              colorScheme,
                            )
                          else
                            _buildResetForm(
                              colorScheme,
                              isSmallHeight,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // RESET FORM
  // ============================================================

  Widget _buildResetForm(
    ColorScheme colorScheme,
    bool isSmallHeight,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        // ==========================================================
        // TITLE
        // ==========================================================

        Text(
          'Forgot your password?',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: -0.7,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 6),

        // ==========================================================
        // DESCRIPTION
        // ==========================================================

        Text(
          'No worries. Enter your email and we’ll help you get back into your account.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            height: 1.45,
            color: colorScheme.onSurface.withValues(
              alpha: 0.60,
            ),
          ),
        ),

        SizedBox(
          height: isSmallHeight ? 20 : 24,
        ),

        // ==========================================================
        // ERROR MESSAGE
        // ==========================================================

        if (_errorMessage != null) ...[
          _buildErrorMessage(colorScheme),
          const SizedBox(height: 12),
        ],

        // ==========================================================
        // EMAIL LABEL
        // ==========================================================

        _buildFieldLabel(
          'Email address',
          colorScheme,
        ),

        const SizedBox(height: 6),

        // ==========================================================
        // EMAIL FIELD
        // ==========================================================

        TextFormField(
          controller: _emailController,
          keyboardType:
              TextInputType.emailAddress,
          textInputAction:
              TextInputAction.done,
          autofillHints: const [
            AutofillHints.email,
          ],
          validator: _validateEmail,
          enabled: !_isLoading,
          onFieldSubmitted: (_) {
            if (!_isLoading) {
              _sendResetLink();
            }
          },
          style: GoogleFonts.inter(
            fontSize: 14,
            color: colorScheme.onSurface,
          ),
          decoration: _inputDecoration(
            context: context,
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
          ),
        ),

        SizedBox(
          height: isSmallHeight ? 18 : 22,
        ),

        // ==========================================================
        // SEND RESET BUTTON
        // ==========================================================

        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed:
                _isLoading ? null : _sendResetLink,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  AppColors.primary.withValues(
                alpha: 0.55,
              ),
              disabledForegroundColor:
                  Colors.white.withValues(
                alpha: 0.85,
              ),
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 21,
                    height: 21,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        'Send Reset Link',
                        style:
                            GoogleFonts.inter(
                          fontSize: 15.5,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 19,
                      ),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 16),

        // ==========================================================
        // BACK TO LOGIN
        // ==========================================================

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'Remember your password?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: colorScheme.onSurface
                      .withValues(alpha: 0.60),
                ),
              ),
            ),
            TextButton(
              onPressed:
                  _isLoading ? null : _goToLogin,
              style: TextButton.styleFrom(
                foregroundColor:
                    AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                minimumSize: Size.zero,
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Sign in',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // SUCCESS CONTENT
  // ============================================================

  Widget _buildSuccessContent(
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        // ==========================================================
        // SUCCESS ICON
        // ==========================================================

        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(
                alpha: 0.12,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_rounded,
              size: 37,
              color: AppColors.success,
            ),
          ),
        ),

        const SizedBox(height: 18),

        // ==========================================================
        // SUCCESS TITLE
        // ==========================================================

        Text(
          'Check your email',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: -0.7,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 7),

        // ==========================================================
        // SUCCESS DESCRIPTION
        // ==========================================================

        Text(
          'We’ve sent a password reset link to your email address.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            height: 1.45,
            color: colorScheme.onSurface.withValues(
              alpha: 0.60,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ==========================================================
        // EMAIL DISPLAY
        // ==========================================================

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryLight
                .withValues(alpha: 0.55),
            borderRadius:
                BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.email_outlined,
                size: 19,
                color: AppColors.primary,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  _emailController.text.trim(),
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ==========================================================
        // BACK TO LOGIN BUTTON
        // ==========================================================

        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _goToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_back_rounded,
                  size: 19,
                ),
                const SizedBox(width: 9),
                Text(
                  'Back to Sign In',
                  style: GoogleFonts.inter(
                    fontSize: 15.5,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ==========================================================
        // HELPFUL MESSAGE
        // ==========================================================

        Text(
          'If you don’t see the email, check your spam or junk folder.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.4,
            color: colorScheme.onSurface
                .withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(
                alpha: 0.12,
              ),
              blurRadius: 20,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: const Icon(
          Icons.school_rounded,
          size: 32,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ============================================================
  // FIELD LABEL
  // ============================================================

  Widget _buildFieldLabel(
    String label,
    ColorScheme colorScheme,
  ) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hintText,
    required IconData prefixIcon,
  }) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        fontSize: 13.5,
        color: colorScheme.onSurface.withValues(
          alpha: 0.40,
        ),
      ),
      prefixIcon: Icon(
        prefixIcon,
        size: 20,
        color: colorScheme.onSurface.withValues(
          alpha: 0.50,
        ),
      ),
      filled: true,
      fillColor: colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.30),
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: BorderSide(
          color: colorScheme.onSurface
              .withValues(alpha: 0.10),
        ),
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: BorderSide(
          color: colorScheme.onSurface
              .withValues(alpha: 0.10),
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide:
            const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
      errorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: BorderSide(
          color: AppColors.error.withValues(
            alpha: 0.75,
          ),
        ),
      ),
      focusedErrorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: BorderSide(
          color: AppColors.error.withValues(
            alpha: 0.85,
          ),
          width: 1.5,
        ),
      ),
    );
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  Widget _buildErrorMessage(
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(
          alpha: 0.10,
        ),
        borderRadius:
            BorderRadius.circular(13),
        border: Border.all(
          color: AppColors.error.withValues(
            alpha: 0.20,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 19,
            color: AppColors.error,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                height: 1.35,
                color:
                    colorScheme.onSurface,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}