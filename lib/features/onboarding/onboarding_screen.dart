import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.calendar_month_rounded,
      'title': 'Organize Your Day',
      'description':
          'Plan your tasks, classes, and important activities in one simple workspace.',
    },
    {
      'icon': Icons.check_circle_rounded,
      'title': 'Stay Productive',
      'description':
          'Track your tasks, stay focused, and make meaningful progress every day.',
    },
    {
      'icon': Icons.track_changes_rounded,
      'title': 'Achieve Your Goals',
      'description':
          'Build better habits, manage your priorities, and turn your goals into progress.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ==========================================
  // NEXT / GET STARTED
  // ==========================================

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.go('/login');
    }
  }

  // ==========================================
  // SKIP
  // ==========================================

  void _skipOnboarding() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // ==========================================
            // BACKGROUND DECORATION
            // ==========================================

            Positioned(
              top: -120,
              left: -110,
              child: _buildBackgroundCircle(
                size: 260,
                color: AppColors.primary.withValues(
                  alpha: 0.07,
                ),
              ),
            ),

            Positioned(
              top: 80,
              right: -100,
              child: _buildBackgroundCircle(
                size: 190,
                color: AppColors.secondary.withValues(
                  alpha: 0.06,
                ),
              ),
            ),

            Positioned(
              bottom: -130,
              right: -110,
              child: _buildBackgroundCircle(
                size: 270,
                color: AppColors.secondary.withValues(
                  alpha: 0.08,
                ),
              ),
            ),

            // ==========================================
            // PAGE VIEW
            // ==========================================

            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final page = _pages[index];

                return _buildOnboardingPage(
                  context: context,
                  icon: page['icon'] as IconData,
                  title: page['title'] as String,
                  description: page['description'] as String,
                  pageIndex: index,
                );
              },
            ),

            // ==========================================
            // SKIP BUTTON
            //
            // IMPORTANT:
            // This is AFTER PageView so it stays
            // above the PageView and can receive taps.
            // ==========================================

            Positioned(
              top: 6,
              right: 20,
              child: _currentPage < _pages.length - 1
                  ? TextButton(
                      onPressed: _skipOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onSurface.withValues(
                          alpha: 0.60,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // ==========================================
            // BOTTOM CONTROLS
            // ==========================================

            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: Column(
                children: [
                  // ======================================
                  // PAGE INDICATORS
                  // ======================================

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildIndicator(index),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ======================================
                  // NEXT / GET STARTED BUTTON
                  // ======================================

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ONBOARDING PAGE
  // ==========================================

  Widget _buildOnboardingPage({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required int pageIndex,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                78,
                24,
                160,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ======================================
                  // MAIN VISUAL
                  // ======================================

                  _buildMainVisual(
                    context: context,
                    icon: icon,
                    pageIndex: pageIndex,
                  ),

                  const SizedBox(height: 44),

                  // ======================================
                  // TITLE
                  // ======================================

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.5,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ======================================
                  // DESCRIPTION
                  // ======================================

                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 350,
                    ),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(
                          alpha: 0.62,
                        ),
                        height: 1.6,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // MAIN VISUAL
  // ==========================================

  Widget _buildMainVisual({
    required BuildContext context,
    required IconData icon,
    required int pageIndex,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      key: ValueKey(pageIndex),
      tween: Tween<double>(
        begin: 0.88,
        end: 1.0,
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ======================================
            // OUTER SOFT GLOW
            // ======================================

            Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: 0.06,
                ),
                shape: BoxShape.circle,
              ),
            ),

            // ======================================
            // PURPLE + TEAL BRAND GRADIENT
            // ======================================

            Container(
              width: 225,
              height: 225,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryLight,
                    AppColors.secondary.withValues(
                      alpha: 0.22,
                    ),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),

            // ======================================
            // INNER SOFT CIRCLE
            // ======================================

            Container(
              width: 175,
              height: 175,
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(
                  alpha: 0.72,
                ),
                shape: BoxShape.circle,
              ),
            ),

            // ======================================
            // MAIN ICON CONTAINER
            // ======================================

            Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: 0.16,
                    ),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.primary,
              ),
            ),

            // ======================================
            // TEAL ACCENT
            // ======================================

            Positioned(
              top: 32,
              right: 34,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(
                        alpha: 0.25,
                      ),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),

            // ======================================
            // PURPLE ACCENT
            // ======================================

            Positioned(
              bottom: 38,
              left: 32,
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.45,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ======================================
            // SMALL TEAL DOT
            // ======================================

            Positioned(
              bottom: 58,
              right: 48,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(
                    alpha: 0.55,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BACKGROUND CIRCLE
  // ==========================================

  Widget _buildBackgroundCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  // ==========================================
  // PAGE INDICATOR
  // ==========================================

  Widget _buildIndicator(int index) {
    final isActive = _currentPage == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 30 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : AppColors.primary.withValues(
                alpha: 0.18,
              ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}