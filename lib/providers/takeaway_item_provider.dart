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

        case GameType.ecommerceScam:
          return [
            TakeawayItem(
              icon: Icons.language,
              title: 'Spot Fake URLs',
              description: 'Look for misspelled or suspicious domains like .tk or .xyz.',
            ),
            TakeawayItem(
              icon: Icons.percent,
              title: 'Ignore Unrealistic Deals',
              description: 'Huge discounts on premium products are usually a trap.',
            ),
            TakeawayItem(
              icon: Icons.timer,
              title: 'Don’t Fall for Pressure',
              description: 'Phrases like "Only 2 left" or "Sale ends soon" are common scam tactics.',
            ),
          ];

        case GameType.appPermissions:
          return [
            TakeawayItem(
              icon: Icons.security_outlined,
              title: 'Question Every Permission',
              description: 'Apps should only request permissions they truly need to function.',
            ),
            TakeawayItem(
              icon: Icons.warning_amber_outlined,
              title: 'Deny Suspicious Requests',
              description: 'Permissions like SMS, Contacts, or Device Admin are red flags for non-essential apps.',
            ),
            TakeawayItem(
              icon: Icons.star_rate,
              title: 'Check Reviews & Ratings',
              description: 'High ratings with very few reviews or vague feedback can indicate a fake or malicious app.',
            ),
          ];

        case GameType.networkRisk:
          return [
            TakeawayItem(
              icon: Icons.wifi_off,
              title: 'Avoid Payments on Public WiFi',
              description: 'Even if it looks safe, public networks can be easily compromised.',
            ),
            TakeawayItem(
              icon: Icons.lock,
              title: 'Use Mobile Data or VPN',
              description: 'For sensitive actions like payments, use mobile data or a trusted VPN.',
            ),
            TakeawayItem(
              icon: Icons.verified,
              title: 'Always Verify Networks',
              description: 'Fake portals can mimic real networks — confirm with staff before entering personal info.',
            ),
          ];

        case GameType.profileDetector:
          return [
            TakeawayItem(
              icon: Icons.account_circle_outlined,
              title: 'Inspect Profile Details',
              description: 'Fake accounts often have no posts, mismatched photos, or vague bios.',
            ),
            TakeawayItem(
              icon: Icons.person_search,
              title: 'Watch Out for Red Flags',
              description: 'Be cautious of usernames with numbers, overly flattering DMs, or friend requests from strangers.',
            ),
            TakeawayItem(
              icon: Icons.report,
              title: 'Report Suspicious Profiles',
              description: 'If something feels off, block and report the profile immediately.',
            ),
          ];

        case GameType.chatDefender:
          return [
            TakeawayItem(
              icon: Icons.privacy_tip,
              title: 'Protect Your Privacy',
              description: 'Never share personal details like phone numbers or photos with strangers online.',
            ),
            TakeawayItem(
              icon: Icons.verified_user_outlined,
              title: 'Verify First',
              description: 'If someone claims to know you, ask questions to confirm their identity.',
            ),
            TakeawayItem(
              icon: Icons.report_gmailerrorred,
              title: 'Don’t Engage With Suspicious Messages',
              description: 'Feeling unsafe? Block and report right away.',
            ),
          ];

        case GameType.secureProfile:
          return [
            TakeawayItem(
              icon: Icons.visibility_off,
              title: 'Control Who Sees You',
              description: 'Be selective about who can view your stories and profile information.',
            ),
            TakeawayItem(
              icon: Icons.location_off_outlined,
              title: 'Hide Your Location',
              description: 'Your real-time location can reveal more than you think — keep it off unless absolutely needed.',
            ),
            TakeawayItem(
              icon: Icons.block,
              title: 'Don’t Engage With Creepy DMs',
              description: 'Block or report messages that feel inappropriate or invasive.',
            ),
          ];

        case GameType.inboxInvader:
          return [
            TakeawayItem(
              icon: Icons.search,
              title: 'Examine Every Detail',
              description: 'Always check sender domains, spelling, and tone. Phishing emails often use subtle tricks to appear real.',
            ),
            TakeawayItem(
              icon: Icons.warning_amber,
              title: 'Beware of Urgency Traps',
              description: 'Scammers use fear and time pressure to make you act fast. Take a moment to verify before responding.',
            ),
            TakeawayItem(
              icon: Icons.shield_outlined,
              title: 'Verify Through Official Channels',
              description: 'When in doubt, contact the organization directly via their official website or phone number instead of using email links.',
            ),
          ];
          
        case GameType.linkLogic:
          return [
            TakeawayItem(
              icon: Icons.https,
              title: 'Trust HTTPS, But Verify',
              description: 'HTTPS and padlock icons are important, but always check the domain spelling and structure for authenticity.',
            ),
            TakeawayItem(
              icon: Icons.find_in_page,
              title: 'Spot Lookalike Domains',
              description: 'Attackers use tricks like replacing letters with numbers (e.g., go0gle.com). Always read URLs carefully.',
            ),
            TakeawayItem(
              icon: Icons.verified,
              title: 'Use Official Sources',
              description: 'Type the address manually or use bookmarks for critical sites like banking, email, and school portals.',
            ),
          ];

        case GameType.replyRight:
          return [
            TakeawayItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Protect Your Personal Data',
              description: 'Never share personal information or credentials unless you are 100% sure of the requester’s identity.',
            ),
            TakeawayItem(
              icon: Icons.report_problem,
              title: 'Don’t Trust Urgency or Fear Tactics',
              description: 'Scammers create panic to make you act without thinking. Pause, verify, and then respond safely.',
            ),
            TakeawayItem(
              icon: Icons.security_outlined,
              title: 'Verify Before You Act',
              description: 'Always use official websites or contact methods to confirm requests instead of following links or pop-ups.',
            ),
          ];


      // default:
      //   return [];
    }
  }
}