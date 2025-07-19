import 'package:claude/enums/games.dart';
import 'package:flutter/material.dart';

class GameInstructionProvider {
  static Map<String, dynamic> getInstructionData(GameType gameType) {
    switch (gameType) {
      case GameType.spamCall:
        return {
          'title': 'Mission: Analyze the Call',
          'icon': Icons.phone_in_talk,
          'overview': 'In this module, you will listen to a series of incoming calls and identify potential scams.',
          'instructions': [
            'Listen carefully to each incoming call',
            'Pay attention to the caller\'s tone and urgency level',
            'Identify whether the call is legitimate or a potential scam',
            'Tap "ACCEPT" if you believe the call is legitimate',
            'Tap "REJECT" if it sounds suspicious',
            'Be quick - you have limited time to decide after audio ends'
          ]
        };
      
      case GameType.phishing:
        return {
          'title': 'Mission: Detect Phishing Emails',
          'icon': Icons.email,
          'overview': 'Analyze incoming emails to identify phishing attempts and protect sensitive information.',
          'instructions': [
            'Review each email carefully for suspicious content',
            'Check sender addresses for authenticity',
            'Look for urgent language or pressure tactics',
            'Identify requests for personal or financial information',
            'Mark emails as "SAFE" or "PHISHING" based on your analysis',
            'Consider the context and legitimacy of requests'
          ]
        };
      
      case GameType.socialEngineering:
        return {
          'title': 'Mission: Take the Right Action',
          'icon': Icons.checklist,
          'overview': 'Read real-life situations and choose the most secure action to stay safe online.',
          'instructions': [
            'Read each scenario carefully before answering',
            'Choose the option that best protects your privacy and data',
            'Use your judgment to detect scams or suspicious behavior',
            'Tap your answer to see if it’s correct and learn why',
            'Complete all scenarios to finish the mission',
            'Try again if you want to improve your score or learn more'
          ]
        };
      
      case GameType.malware:
        return {
          'title': 'Mission: Avoid Malware Threats',
          'icon': Icons.security,
          'overview': 'Identify and avoid malicious software that could compromise your system.',
          'instructions': [
            'Examine files and downloads for suspicious characteristics',
            'Check file extensions and sources carefully',
            'Avoid clicking on unknown or suspicious links',
            'Recognize fake software update prompts',
            'Identify potentially harmful attachments',
            'Make safe decisions about downloads and installations'
          ]
        };
    }
  }
}