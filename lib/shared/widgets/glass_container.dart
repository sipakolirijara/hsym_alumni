
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';



class GlassContainer extends StatelessWidget {

  final Widget child;

  final EdgeInsetsGeometry? padding;

  final double borderRadius;



  const GlassContainer({

    super.key,

    required this.child,

    this.padding = const EdgeInsets.all(16.0),

    this.borderRadius = 16.0,

  });



  @override

  Widget build(BuildContext context) {

    return ClipRRect(

      borderRadius: BorderRadius.circular(borderRadius),

      child: BackdropFilter(

        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

        child: Container(

          padding: padding,

          decoration: BoxDecoration(

            color: AppTheme.glassBackground,

            borderRadius: BorderRadius.circular(borderRadius),

            border: Border.all(

              color: AppTheme.glassBorder,

              width: 1.5,

            ),

          ),

          child: child,

        ),

      ),

    );

  }

}

