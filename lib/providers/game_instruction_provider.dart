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
      case GameType.ecommerceScam:
        return {
          'title': 'Mission: Spot the Fake Deal',
          'icon': Icons.shopping_cart_outlined,
          'overview': 'Analyze online shopping deals to detect scams and avoid getting tricked.',
          'instructions': [
            'Carefully examine the product listing details',
            'Look out for red flags like suspicious URLs, huge discounts, or urgency tactics',
            'Decide whether the listing is SAFE or FAKE',
            'Tap "SAFE" if the deal looks legitimate',
            'Tap "FAKE" if you suspect it’s a scam',
            'Be alert – scammers use tricks to make fake offers look real'
          ]
        };
        case GameType.appPermissions:
          return {
            'title': 'Mission: Control App Permissions',
            'icon': Icons.privacy_tip_outlined,
            'overview': 'In this module, you will review apps and the permissions they request. Your job is to allow only what makes sense.',
            'instructions': [
              'Carefully review the app name, type, and permissions it requests',
              'Analyze whether the requested permissions match the app’s purpose',
              'Tap "ALLOW" if all permissions seem reasonable',
              'Tap "DENY" if any permissions look suspicious or unnecessary',
              'Trust your instincts – not all apps are what they claim to be'
            ]
          };
          
        case GameType.networkRisk:
          return {
            'title': 'Mission: Stay Safe on Public Networks',
            'icon': Icons.wifi_outlined,
            'overview': 'In this module, you will face realistic situations involving public WiFi and decide the safest course of action.',
            'instructions': [
              'Read each real-world scenario carefully',
              'Consider the network, location, and urgency involved',
              'Choose the safest action to protect your personal and payment data',
              'Tap the option you believe is safest',
              'Learn from each situation with explanations provided',
              'Stay alert — attackers love unsafe networks!'
            ]
          };
          
        case GameType.profileDetector:
          return {
            'title': 'Mission: Identify Fake Profiles',
            'icon': Icons.account_box_outlined,
            'overview': 'In this module, you will examine user profiles and decide whether they seem real or suspicious.',
            'instructions': [
              'Review each profile’s photo, username, bio, and activity',
              'Look for signs of fake behavior like vague bios or mismatched photos',
              'Tap "REAL" if the profile seems trustworthy',
              'Tap "FAKE" if the profile raises any red flags',
              'Think critically — scammers often disguise fake accounts well',
              'Stay alert and trust your instincts!'
            ]
          };


        case GameType.chatDefender:
          return {
            'title': 'Mission: Stay Safe in Chats',
            'icon': Icons.chat_bubble_outline,
            'overview': 'In this module, you’ll navigate direct messages and choose the safest way to respond.',
            'instructions': [
              'Read each message carefully and think before you reply',
              'Watch for signs of manipulation, pressure, or identity faking',
              'Choose the response that keeps you safe and cautious',
              'Tap on the safest reply among the given choices',
              'Learn from feedback after each decision',
              'Stay alert — not everyone online is who they claim to be!'
            ]
          };

          
        case GameType.secureProfile:
          return {
            'title': 'Secure Your Profile',
            'icon': Icons.lock_outline,
            'overview': 'In this game, protect your social media profile from unwanted attention and risky behavior.',
            'instructions': [
              'Decide who should be allowed to view your story — block strangers.',
              'If someone suspicious views your location, choose whether to remove it.',
              'Review direct messages carefully — block or report if they seem unsafe.',
              'Think critically and choose the most secure option each time.',
              'Learn from instant feedback to improve your online safety habits.',
              'Your digital privacy is in your hands — play smart!'
            ]
          };

        case GameType.inboxInvader:
          return {
            'title': 'Mission: Stop the Inbox Invaders',
            'icon': Icons.mail_outline,
            'overview': 'Learn to spot phishing emails by identifying red flags and sorting legit messages from scams.',
            'instructions': [
              'Read each email carefully before making a decision',
              'Look for suspicious domains, urgent language, or generic greetings',
              'Identify if the email is legitimate or a phishing attempt',
              'Drag or tap to classify the email correctly',
              'Pay attention to feedback to learn key phishing indicators',
              'Stay alert — phishing emails often mimic trusted sources!',
            ]
          };

        case GameType.linkLogic:
          return {
            'title': 'Mission: Master the Link Logic',
            'icon': Icons.link,
            'overview': 'Test your ability to identify legitimate and fake URLs by spotting subtle red flags.',
            'instructions': [
              'Inspect each URL carefully before deciding',
              'Check for spelling mistakes, extra characters, or strange domain extensions',
              'Decide whether the link is safe or a phishing attempt',
              'Be cautious — fake links are designed to look almost identical to the real thing!',
            ]
          };
          
        case GameType.replyRight:
          return {
            'title': 'Mission: Reply the Right Way',
            'icon': Icons.message_outlined,
            'overview': 'Practice making safe decisions in tricky online scenarios involving emails, social media, and pop-ups.',
            'instructions': [
              'Read each scenario carefully and understand the situation',
              'Analyze the message for red flags like urgency or personal info requests',
              'Select the safest and most secure response from the options',
              'Think like a security expert — scammers prey on quick reactions',
              'Remember: When in doubt, verify through trusted channels.',
            ]
          };


    }
  }
}