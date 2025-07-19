import 'package:claude/enums/games.dart';
import 'package:claude/models/takeaway_item.dart';
import 'package:flutter/material.dart';

class GameTakeawayProvider {
  static List<TakeawayItem> getTakeaways(GameType gameType) {
    switch (gameType) {
      case GameType.spamCall:
        return [
          TakeawayItem(
            icon: Icons.phone_forwarded,
            title: 'Verify Caller Identity',
           description: 'Don’t trust calls claiming to be from your bank—always verify via official channels.',
          ),
          TakeawayItem(
            icon: Icons.sms_failed,
            title: 'Never Share OTP',
            description: 'OTP is meant for you only. Banks never ask for it over calls.',
          ),
          TakeawayItem(
            icon: Icons.warning_amber_outlined,
            title: 'Beware of Urgency',
            description: 'Scammers create panic to make you act fast. Take a moment to think.',
        ),
        ];
      
      case GameType.phishing:
        return [
          TakeawayItem(
            icon: Icons.email_outlined,
            title: 'Suspicious Links',
            description: 'Never click on links from untrusted email sources',
          ),
          TakeawayItem(
            icon: Icons.security_outlined,
            title: 'Verify Sender',
            description: 'Always verify the sender\'s identity before sharing information',
          ),
          TakeawayItem(
            icon: Icons.warning_outlined,
            title: 'Urgency Tactics',
            description: 'Be wary of emails that create false urgency or fear',
          ),
        ];
      
      case GameType.socialEngineering:
        return [
          TakeawayItem(
            icon: Icons.security,
            title: 'Protect Sensitive Info',
            description: 'Never share PINs, passwords, or full card details in pop-ups or calls.',
          ),
          TakeawayItem(
            icon: Icons.public_off,
            title: 'Avoid Public Networks',
            description: 'Don’t access banking services over public WiFi. Use mobile data or VPN.',
          ),
          TakeawayItem(
            icon: Icons.emoji_objects,
            title: 'Think Before You Click',
            description: 'Phishing emails and fake quizzes can steal your personal data. Stay alert.',
          ),
        ];
      
      case GameType.malware:
        return [
          TakeawayItem(
            icon: Icons.download_outlined,
            title: 'Unknown Downloads',
            description: 'Avoid downloading software from untrusted sources',
          ),
          TakeawayItem(
            icon: Icons.update_outlined,
            title: 'Keep Updated',
            description: 'Regularly update your software and antivirus protection',
          ),
          TakeawayItem(
            icon: Icons.folder_outlined,
            title: 'File Extensions',
            description: 'Be cautious of executable files (.exe, .bat, .scr)',
          ),
        ];
      
      // default:
      //   return [];
    }
  }
}