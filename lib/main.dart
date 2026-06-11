
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

import 'shared/widgets/glass_container.dart';



void main() {

  runApp(const AlumniApp());

}



class AlumniApp extends StatelessWidget {

  const AlumniApp({super.key});



  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'AMS Alumni',

      theme: AppTheme.darkTheme,

      home: const AuthWrapperScreen(),

    );

  }

}



class AuthWrapperScreen extends StatelessWidget {

  const AuthWrapperScreen({super.key});



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [

              Color(0xFF1E1E1E),

              Color(0xFF000000),

            ],

          ),

        ),

        child: Center(

          child: Padding(

            padding: const EdgeInsets.symmetric(horizontal: 24.0),

            child: GlassContainer(

              child: Column(

                mainAxisSize: MainAxisSize.min,

                children: [

                  const Icon(

                    Icons.school,

                    size: 64,

                    color: AppTheme.primaryPurple,

                  ),

                  const SizedBox(height: 24),

                  const Text(

                    'GPS Alumni Connect',

                    style: TextStyle(

                      fontSize: 24,

                      fontWeight: FontWeight.bold,

                      color: Colors.white,

                    ),

                  ),

                  const SizedBox(height: 8),

                  const Text(

                    'Initializing secure session...',

                    style: TextStyle(color: Colors.white70),

                  ),

                  const SizedBox(height: 32),

                  const CircularProgressIndicator(

                    color: AppTheme.primaryPurple,

                  ),

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }

}

