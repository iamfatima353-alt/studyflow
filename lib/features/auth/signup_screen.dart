import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  
  // CREATE ACCOUNT
  

  Future<void> _createAccount() async {
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

    // Temporary simulated signup.
    // Firebase Authentication will replace this later.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Temporary behavior.
    // Later Firebase will determine where the user goes.
    context.go('/home');
  }

  
  // NAME VALIDATION
  

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Please enter your name.';
    }

    if (name.length < 2) {
      return 'Name must be at least 2 characters.';
    }

    return null;
  }

  
  // EMAIL VALIDATION
  

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

  
  // PASSWORD VALIDATION
  

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please enter a password.';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    return null;
  }

  
  // CONFIRM PASSWORD VALIDATION
  

  String? _validateConfirmPassword(String? value) {
    final confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'Please confirm your password.';
    }

    if (confirmPassword != _passwordController.text) {
      return 'Passwords do not match.';
    }

    return null;
  }

// GO TO LOGIN
  

  void _goToLogin() {
    if (_isLoading) return;

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallHeight = constraints.maxHeight < 700;

            return SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                24,
                isSmallHeight ? 8 : 14,
                24,
                20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight -
                      (isSmallHeight ? 28 : 34),
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
                        
                          // BACK BUTTON
                        

                         

                          SizedBox(
                            height: isSmallHeight ? 2 : 6,
                          ),

                        
                          // LOGO
                        

                          _buildLogo(),

                          SizedBox(
                            height: isSmallHeight ? 14 : 18,
                          ),

                        
                          // TITLE
                        

                          Text(
                            'Create your account',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                              letterSpacing: -0.6,
                              height: 1.15,
                            ),
                          ),

                          const SizedBox(height: 8),

                        
                          // DESCRIPTION
                        

                          Text(
                            'Start organizing your studies and make every day more productive.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 1.45,
                              color: colorScheme.onSurface
                                  .withValues(alpha: 0.60),
                            ),
                          ),

                          SizedBox(
                            height: isSmallHeight ? 22 : 26,
                          ),

                        
                          // ERROR MESSAGE
                        

                          if (_errorMessage != null) ...[
                            _buildErrorMessage(colorScheme),
                            const SizedBox(height: 14),
                          ],

                        
                          // FULL NAME
                        

                          _buildFieldLabel(
                            'Full name',
                            colorScheme,
                          ),

                          const SizedBox(height: 6),

                          TextFormField(
                            controller: _nameController,
                            textCapitalization:
                                TextCapitalization.words,
                            keyboardType: TextInputType.name,
                            textInputAction:
                                TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.name,
                            ],
                            validator: _validateName,
                            enabled: !_isLoading,
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              color: colorScheme.onSurface,
                            ),
                            decoration: _inputDecoration(
                              context: context,
                              hintText: 'Enter your full name',
                              prefixIcon:
                                  Icons.person_outline_rounded,
                            ),
                          ),

                          const SizedBox(height: 14),

                        
                          // EMAIL
                        

                          _buildFieldLabel(
                            'Email address',
                            colorScheme,
                          ),

                          const SizedBox(height: 6),

                          TextFormField(
                            controller: _emailController,
                            keyboardType:
                                TextInputType.emailAddress,
                            textInputAction:
                                TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.email,
                            ],
                            validator: _validateEmail,
                            enabled: !_isLoading,
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              color: colorScheme.onSurface,
                            ),
                            decoration: _inputDecoration(
                              context: context,
                              hintText: 'Enter your email',
                              prefixIcon:
                                  Icons.email_outlined,
                            ),
                          ),

                          const SizedBox(height: 14),

                        
                          // PASSWORD
                        

                          _buildFieldLabel(
                            'Password',
                            colorScheme,
                          ),

                          const SizedBox(height: 6),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            textInputAction:
                                TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.newPassword,
                            ],
                            validator: _validatePassword,
                            enabled: !_isLoading,
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              color: colorScheme.onSurface,
                            ),
                            decoration: _inputDecoration(
                              context: context,
                              hintText: 'Create a password',
                              prefixIcon:
                                  Icons.lock_outline_rounded,
                              suffixIcon: IconButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                tooltip: _isPasswordVisible
                                    ? 'Hide password'
                                    : 'Show password',
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons
                                          .visibility_off_outlined
                                      : Icons
                                          .visibility_outlined,
                                  size: 21,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                        
                          // CONFIRM PASSWORD
                        

                          _buildFieldLabel(
                            'Confirm password',
                            colorScheme,
                          ),

                          const SizedBox(height: 6),

                          TextFormField(
                            controller:
                                _confirmPasswordController,
                            obscureText:
                                !_isConfirmPasswordVisible,
                            textInputAction:
                                TextInputAction.done,
                            autofillHints: const [
                              AutofillHints.newPassword,
                            ],
                            validator:
                                _validateConfirmPassword,
                            enabled: !_isLoading,
                            onFieldSubmitted: (_) {
                              if (!_isLoading) {
                                _createAccount();
                              }
                            },
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              color: colorScheme.onSurface,
                            ),
                            decoration: _inputDecoration(
                              context: context,
                              hintText:
                                  'Confirm your password',
                              prefixIcon:
                                  Icons.lock_outline_rounded,
                              suffixIcon: IconButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          _isConfirmPasswordVisible =
                                              !_isConfirmPasswordVisible;
                                        });
                                      },
                                tooltip:
                                    _isConfirmPasswordVisible
                                        ? 'Hide password'
                                        : 'Show password',
                                icon: Icon(
                                  _isConfirmPasswordVisible
                                      ? Icons
                                          .visibility_off_outlined
                                      : Icons
                                          .visibility_outlined,
                                  size: 21,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: isSmallHeight ? 18 : 22,
                          ),

                        
                          // CREATE ACCOUNT BUTTON
                        

                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _createAccount,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.primary,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                    AppColors.primary
                                        .withValues(alpha: 0.55),
                                disabledForegroundColor:
                                    Colors.white
                                        .withValues(alpha: 0.85),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape:
                                    RoundedRectangleBorder(
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
                                          'Create Account',
                                          style:
                                              GoogleFonts.inter(
                                            fontSize: 15.5,
                                            fontWeight:
                                                FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 9),
                                        const Icon(
                                          Icons
                                              .arrow_forward_rounded,
                                          size: 19,
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                        
                          // LOGIN LINK
                        

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'Already have an account?',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.60),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : _goToLogin,
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      AppColors.primary,
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize
                                          .shrinkWrap,
                                ),
                                child: Text(
                                  'Sign in',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
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

  
  // LOGO
  

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

  
  // FIELD LABEL
  

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

  
  // INPUT DECORATION
  

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

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

      suffixIcon: suffixIcon,

      filled: true,

      fillColor: colorScheme.surfaceContainerHighest
          .withValues(alpha: 0.30),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: colorScheme.onSurface.withValues(
            alpha: 0.10,
          ),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: colorScheme.onSurface.withValues(
            alpha: 0.10,
          ),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: AppColors.error.withValues(
            alpha: 0.75,
          ),
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: AppColors.error.withValues(
            alpha: 0.85,
          ),
          width: 1.5,
        ),
      ),
    );
  }

  
  // ERROR MESSAGE
  

  Widget _buildErrorMessage(
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(13),
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
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}