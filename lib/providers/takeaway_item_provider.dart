import 'package:claude/enums/games.dart';
import 'package:claude/models/takeaway_item.dart';
import 'package:flutter/material.dart';

class GameTakeawayProvider {
  static List<TakeawayItem> getTakeaways(GameType gameType) {
    switch (gameType) {
      case GameType.spamCall:
        return [
          TakeawayItem(
            icon: Icons.help_outline,
            title: 'Unknown Numbers',
            description: 'Be cautious of calls from unknown or suspicious numbers',
          ),
          TakeawayItem(
            icon: Icons.phone_outlined,
            title: 'Repeated Calls',
            description: 'Multiple calls from same number can indicate spam attempts',
          ),
          TakeawayItem(
            icon: Icons.shield_outlined,
            title: 'Spoofed Caller IDs',
            description: 'Scammers often disguise their identity with fake caller information',
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
            icon: Icons.person_outline,
            title: 'Identity Verification',
            description: 'Always verify who you\'re talking to before sharing information',
          ),
          TakeawayItem(
            icon: Icons.psychology_outlined,
            title: 'Emotional Manipulation',
            description: 'Be aware of attempts to manipulate your emotions',
          ),
          TakeawayItem(
            icon: Icons.info_outline,
            title: 'Information Gathering',
            description: 'Limit personal information shared with strangers',
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