import 'package:flutter/material.dart';

class GameProgressBar extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;

  const GameProgressBar({
    Key? key,
    required this.currentQuestion,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentQuestion + 1} of $totalQuestions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: (currentQuestion + 1) / totalQuestions,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}