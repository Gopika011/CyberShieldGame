import 'package:flutter/material.dart';

class DigitalTheme {
  // Core Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color cardBackground = Color(0xFF1E293B);
  static const Color surfaceBackground = Color(0xFF334155);
  
  // Primary Colors
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF94A3B8);
  static const Color primaryCyan = Color(0xFF00D9FF);
  static const Color neonGreen = Color(0xFF00FF88);
  static const Color accentBlue = Color(0xFF3B82F6);
  
  // Status Colors
  static const Color dangerRed = Color(0xFFFF4444);
  static const Color warningOrange = Color(0xFFFF8800);
  static const Color successGreen = Color(0xFF00FF88);
  
  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E293B),
      Color(0xFF334155),
    ],
  );
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryCyan, accentBlue],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E293B),
      Color(0xFF334155),
    ],
  );
  
  // Shadows and Effects
  static const List<BoxShadow> neonGlow = [
    BoxShadow(
      color: Color(0x4000D9FF),
      blurRadius: 20,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: Color(0x2000D9FF),
      blurRadius: 40,
      spreadRadius: 4,
    ),
  ];
  
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  // Typography - Mobile Responsive
  static TextStyle get headingStyle => TextStyle(
    fontSize: _getResponsiveFontSize(24, 28, 32),
    fontWeight: FontWeight.bold,
    color: primaryText,
    letterSpacing: 1.2,
  );
  
  static TextStyle get subheadingStyle => TextStyle(
    fontSize: _getResponsiveFontSize(16, 18, 20),
    fontWeight: FontWeight.w600,
    color: primaryText,
    letterSpacing: 0.8,
  );
  
  static TextStyle get bodyStyle => TextStyle(
    fontSize: _getResponsiveFontSize(14, 15, 16),
    color: secondaryText,
    height: 1.5,
  );
  
  static TextStyle get captionStyle => TextStyle(
    fontSize: _getResponsiveFontSize(12, 13, 14),
    color: secondaryText,
    letterSpacing: 0.5,
  );
  
  // Mobile Responsive Helper
  static double _getResponsiveFontSize(double mobile, double tablet, double desktop) {
    // This will be overridden by MediaQuery in actual usage
    return mobile;
  }
  
  // Mobile Responsive Methods
  static double getResponsiveFontSize(BuildContext context, double mobile, double tablet, double desktop) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return mobile;
    if (screenWidth < 1024) return tablet;
    return desktop;
  }
  
  static double getResponsivePadding(BuildContext context, double mobile, double tablet, double desktop) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return mobile;
    if (screenWidth < 1024) return tablet;
    return desktop;
  }
  
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }
  
  // Mobile-specific styles
  static TextStyle getMobileHeadingStyle(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 20, 24, 28),
    fontWeight: FontWeight.bold,
    color: primaryText,
    letterSpacing: 1.0,
  );
  
  static TextStyle getMobileBodyStyle(BuildContext context) => TextStyle(
    fontSize: getResponsiveFontSize(context, 12, 14, 16),
    color: secondaryText,
    height: 1.4,
  );
  
  static EdgeInsets getMobilePadding(BuildContext context) => EdgeInsets.all(
    getResponsivePadding(context, 12, 16, 20),
  );
  
  static double getMobileIconSize(BuildContext context) {
    return getResponsiveFontSize(context, 16, 20, 24);
  }
  
  static double getMobileButtonHeight(BuildContext context) {
    return getResponsiveFontSize(context, 44, 48, 52);
  }
}