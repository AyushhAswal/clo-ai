import 'package:flutter/material.dart';

abstract class AppColors {
  // Background Tones
  static const Color backgroundDark = Color(0xFF09090C);
  static const Color surfaceDark = Color(0xFF121217);
  static const Color cardDark = Color(0xFF14141B);

  // Brand Accents
  static const Color primaryAccent = Color(0xFFFF6E7F);
  static const Color secondaryAccent = Color(0xFFC743BD);

  // Home Screen Specific Colors
  static const Color bottomNavBg = Color(0xFF181820);
  static const Color bottomNavActiveBg = Color(0xFFFFFFFF);
  static const Color bottomNavActiveText = Color(0xFF0C0D12);
  static const Color fabBg = Color(0xFFC743BD);
  static const Color relationshipRing = Color(0xFFC743BD);
  static const Color addRelationshipBg = Color(0xFF1D1D26);
  static const Color addRelationshipBorder = Color(0xFF2A2A38);

  // Login Gradient Button Palette
  static const Color loginGradientStart = Color(0xFF8A3C9B); // Violet / Purple
  static const Color loginGradientEnd = Color(0xFFE8706D); // Coral / Pink

  static const LinearGradient loginButtonGradient = LinearGradient(
    colors: [loginGradientStart, loginGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Text Field Styling
  static const Color inputFieldFill = Color(0xFF121217);
  static const Color inputFieldBorder = Color(0xFF24242F);
  static const Color inputFieldHint = Color(0xFF5E6573);

  // Animated Glowing Orb Palette
  static const Color orbCore = Color(0xFFFFF6E5);
  static const Color orbGold = Color(0xFFFFC766);
  static const Color orbCoral = Color(0xFFFF6E7F);
  static const Color orbMagenta = Color(0xFFC743BD);
  static const Color orbPurple = Color(0xFF6B1B8A);
  static const Color orbDeepViolet = Color(0xFF38084B);

  // Controls & Buttons
  static const Color topBarIconBg = Color(0x1AFFFFFF);
  static const Color skipButtonBg = Color(0x2B2A3340);

  static const Color backButtonBg = Color(
    0x3B3A3945,
  ); // Dark circular back button
  static const Color backButtonIcon = Color(0xFFE2E8F0);

  static const Color circularButtonBg = Color(
    0xFFFFFFFF,
  ); // White circular next button
  static const Color circularButtonIcon = Color(0xFF0C0D12);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A8B8);

  // Indicator
  static const Color indicatorActive = Color(0xFFFFFFFF);
  static const Color indicatorInactive = Color(0x3DFFFFFF);
}
