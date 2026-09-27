import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary Palette
  static const deepGreen = Color(0xFF1B4332);
  static const forestGreen = Color(0xFF2D6A4F);
  static const mintAccent = Color(0xFFD8F3DC);
  
  // Status Triage
  static const safeGreen = Color(0xFF27AE60);
  static const warningYellow = Color(0xFFF39C12);
  static const criticalRed = Color(0xFFE74C3C);
  
  // Containers for status badges
  static const safeContainer = Color(0xFFE8F8F0);
  static const warningContainer = Color(0xFFFEF5E7);
  static const criticalContainer = Color(0xFFFDEDEC);
  
  // Text & Surface
  static const textPrimary = Color(0xFF1A202C);
  static const textSecondary = Color(0xFF4A5568);
  static const surface = Color(0xFFF7FAFC);
  static const border = Color(0xFF718096);
}
