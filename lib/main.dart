/// CertPrep Pro
/// A Flutter application for exam preparation.
/// This app provides a platform for users to prepare for various certification exams.
/// It includes features like quizzes, flashcards, and study materials.
/// The app is designed to be user-friendly and efficient, helping users to maximize their study time.
/// 
/// 
/// 
/// Copyright (c) 2025 CertPrep Pro
/// 
/// This program is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
/// 
/// This program is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
/// 
/// You should have received a copy of the GNU General Public License
/// along with this program.  If not, see <http://www.gnu.org/licenses/>.
/// 
/// This project is licensed under the GNU General Public License v3.0.
/// You can find a copy of the license in the LICENSE file in the root directory of this project.
/// 
/// This project is maintained by CertPrep Pro team.
/// For more information, visit our website: https://certpreppro.com
/// 
/// Created by: TonyMontana-dev & ChatGPT 4o 


import 'package:flutter/material.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const CertPrepProApp());
}

class CertPrepProApp extends StatelessWidget {
  const CertPrepProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CertPrep Pro',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('CertPrep Pro')),
        body: const Center(child: Text('Welcome to CertPrep Pro!')),
      ),
    );
  }
}
