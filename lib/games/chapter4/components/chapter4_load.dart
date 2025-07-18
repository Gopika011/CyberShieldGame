import 'package:flutter/material.dart';

class Chapter4LoadBar extends StatelessWidget {
  final Animation<double> animation;
  final double cardWidth; 
  final double maxCardWidth; 
  const Chapter4LoadBar({super.key, required this.animation, required this.cardWidth, required this.maxCardWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxCardWidth),
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[600]!),
        boxShadow: [
          BoxShadow(
            color: const Color(0x4D000000),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Container(
                    width: (animation.value * cardWidth).clamp(0.0, cardWidth),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.blue[600]!],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(10, (index){
                if (index == 0 || index == 9) return const SizedBox.shrink();
                return Container(
                  height: double.infinity,
                  width: 1,
                  color: Colors.grey[800],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}