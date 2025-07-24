

import '../models/game_models.dart';

class LevelData {
  // Level 1: Inbox Invader - Email Data
  static final List<Email> level1Emails = [
    Email(
      id: 'email_1',
      subject: 'Congratulations! You\'ve Won a Scholarship!',
      sender: 'scholarships@university-grants.org',
      preview: 'Dear Student, You have been selected for our exclusive \$10,000 scholarship program! Click here immediately to claim...',
      isPhishing: true,
      phishingType: 'urgency',
      indicators: ['Urgent language ("immediately")', 'Unsolicited offer', 'Generic greeting', 'Suspicious domain'],
    ),
    Email(
      id: 'email_2',
      subject: 'Your Course Registration Confirmation',
      sender: 'registrar@university.edu',
      preview: 'Dear Arya, Your registration for Computer Science 101 has been confirmed for Fall 2024 semester...',
      isPhishing: false,
      indicators: ['Legitimate university domain', 'Personal greeting', 'Official tone', 'Specific course information'],
    ),
    Email(
      id: 'email_3',
      subject: 'URGENT: Your Account Will Be Suspended',
      sender: 'security@university-portal.com',
      preview: 'Your university account has been compromised. Verify your identity immediately or face permanent suspension...',
      isPhishing: true,
      phishingType: 'urgency',
      indicators: ['Threatening language', 'Fake urgency', 'Slightly different domain', 'Scare tactics'],
    ),
    Email(
      id: 'email_4',
      subject: 'Library Book Renewal Reminder',
      sender: 'library@university.edu',
      preview: 'Hello Arya, This is a friendly reminder that your library book "Data Structures and Algorithms" is due tomorrow...',
      isPhishing: false,
      indicators: ['Legitimate library domain', 'Personal greeting', 'Specific book information', 'Helpful tone'],
    ),
    Email(
      id: 'email_5',
      subject: 'You\'ve Been Selected for an Exclusive Internship!',
      sender: 'careers@techinnovate.co',
      preview: 'Dear Talented Student, TechInnovate is offering you an exclusive internship opportunity worth \$5000/month...',
      isPhishing: true,
      phishingType: 'social_engineering',
      indicators: ['Too good to be true offer', 'Unsolicited opportunity', 'Generic flattery', 'Suspicious domain'],
    ),
  ];

  // Level 2: Link Logic - Link Challenges
  static final List<LinkChallenge> level2Links = [
    LinkChallenge(
      id: 'link_1',
      displayUrl: 'careers.google.com',
      actualUrl: 'https://careers.google.com',
      isLegitimate: true,
      description: 'Google\'s official careers page',
      indicators: ['Official Google domain', 'HTTPS secure connection', 'Matches expected URL structure'],
      category: 'education',
    ),
    LinkChallenge(
      id: 'link_2',
      displayUrl: 'go0gle-careers.net',
      actualUrl: 'http://go0gle-careers.net',
      isLegitimate: false,
      description: 'Fake Google careers site',
      indicators: ['Zero instead of "o" in Google', 'Wrong domain extension (.net)', 'No HTTPS security'],
      category: 'education',
    ),
    LinkChallenge(
      id: 'link_3',
      displayUrl: 'microsoft.com/office',
      actualUrl: 'https://microsoft.com/office',
      isLegitimate: true,
      description: 'Official Microsoft Office page',
      indicators: ['Official Microsoft domain', 'HTTPS secure', 'Correct spelling'],
      category: 'software',
    ),
    LinkChallenge(
      id: 'link_4',
      displayUrl: 'microsft-office.com',
      actualUrl: 'http://microsft-office.com',
      isLegitimate: false,
      description: 'Fake Microsoft Office site',
      indicators: ['Missing "o" in Microsoft', 'Different domain structure', 'No HTTPS'],
      category: 'software',
    ),
    LinkChallenge(
      id: 'link_5',
      displayUrl: 'github.com/login',
      actualUrl: 'https://github.com/login',
      isLegitimate: true,
      description: 'Official GitHub login page',
      indicators: ['Legitimate GitHub domain', 'HTTPS secure', 'Standard login path'],
      category: 'education',
    ),
    LinkChallenge(
      id: 'link_6',
      displayUrl: 'github-secure.org/login',
      actualUrl: 'http://github-secure.org/login',
      isLegitimate: false,
      description: 'Fake GitHub login site',
      indicators: ['Wrong domain (.org)', 'Hyphenated fake domain', 'No HTTPS security'],
      category: 'education',
    ),
    LinkChallenge(
      id: 'link_7',
      displayUrl: 'amazon.com/deals',
      actualUrl: 'https://amazon.com/deals',
      isLegitimate: true,
      description: 'Amazon\'s official deals page',
      indicators: ['Official Amazon domain', 'HTTPS secure', 'Standard URL structure'],
      category: 'shopping',
    ),
    LinkChallenge(
      id: 'link_8',
      displayUrl: 'amaz0n-deals.net',
      actualUrl: 'http://amaz0n-deals.net',
      isLegitimate: false,
      description: 'Fake Amazon deals site',
      indicators: ['Zero instead of "o"', 'Wrong domain extension', 'No HTTPS'],
      category: 'shopping',
    ),
  ];

  // Level 3: Reply Right - Dialogue Challenges
  static final List<DialogueChallenge> level3Dialogues = [
    DialogueChallenge(
      id: 'dialogue_1',
      scenario: 'Arya receives a text from an unknown number claiming to be her bank',
      message: 'URGENT: Your account has been compromised. Reply with your PIN to verify your identity and secure your account immediately.',
      options: [
        DialogueOption(id: '1a', text: 'Reply with PIN number', isCorrect: false, feedback: 'Never share your PIN!', riskLevel: 5),
        DialogueOption(id: '1b', text: 'Call the bank directly', isCorrect: true, feedback: 'Perfect! Always verify by calling the official number.', riskLevel: 1),
        DialogueOption(id: '1c', text: 'Ignore the message', isCorrect: false, feedback: 'Good instinct, but calling to verify is better.', riskLevel: 2),
      ],
      explanation: 'Banks never ask for PINs or passwords via text. Always verify by calling the official number.',
      category: 'phishing',
    ),
    DialogueChallenge(
      id: 'dialogue_2',
      scenario: 'Arya gets an email asking her to update her university password',
      message: 'Dear Student, Your university password will expire in 24 hours. Click here to update: http://university-login.com',
      options: [
        DialogueOption(id: '2a', text: 'Click the link immediately', isCorrect: false, feedback: 'Never click suspicious links!', riskLevel: 5),
        DialogueOption(id: '2b', text: 'Go directly to the university website', isCorrect: true, feedback: 'Excellent! Always use official websites.', riskLevel: 1),
        DialogueOption(id: '2c', text: 'Reply asking for more information', isCorrect: false, feedback: 'This could confirm your email to scammers.', riskLevel: 4),
      ],
      explanation: 'Always navigate to official websites directly rather than clicking links in emails.',
      category: 'phishing',
    ),
    DialogueChallenge(
      id: 'dialogue_3',
      scenario: 'Arya receives a friend request on social media from someone she doesn\'t recognize',
      message: 'Hi! I\'m Sarah from your Computer Science class. I got your profile from a mutual friend. Can you help me with the assignment? Please share your student ID so I can add you to the study group.',
      options: [
        DialogueOption(id: '3a', text: 'Share student ID immediately', isCorrect: false, feedback: 'Never share personal info with strangers!', riskLevel: 5),
        DialogueOption(id: '3b', text: 'Ask which mutual friend and verify in class', isCorrect: true, feedback: 'Smart! Always verify unknown contacts.', riskLevel: 1),
        DialogueOption(id: '3c', text: 'Ignore the request', isCorrect: false, feedback: 'Good instinct, but verification is better.', riskLevel: 2),
      ],
      explanation: 'Social engineering often uses fake familiarity. Always verify unknown contacts through trusted channels.',
      category: 'social_engineering',
    ),
    DialogueChallenge(
      id: 'dialogue_4',
      scenario: 'Arya gets a pop-up message while browsing saying her computer is infected',
      message: 'WARNING! Your computer has 5 viruses! Download our security software immediately or your files will be deleted in 10 minutes!',
      options: [
        DialogueOption(id: '4a', text: 'Download the software quickly', isCorrect: false, feedback: 'This is malware! Never download from pop-ups.', riskLevel: 5),
        DialogueOption(id: '4b', text: 'Close the pop-up and run legitimate antivirus', isCorrect: true, feedback: 'Perfect! Use trusted security software only.', riskLevel: 1),
        DialogueOption(id: '4c', text: 'Call the number provided for help', isCorrect: false, feedback: 'These numbers lead to scammers.', riskLevel: 4),
      ],
      explanation: 'Legitimate antivirus software doesn\'t use scary pop-ups. Use only trusted security tools.',
      category: 'malware',
    ),
    DialogueChallenge(
      id: 'dialogue_5',
      scenario: 'Arya receives a call claiming to be from tech support about her WiFi',
      message: 'Hello, this is tech support. We\'ve detected suspicious activity on your WiFi. We need remote access to your computer to fix the security issue immediately.',
      options: [
        DialogueOption(id: '5a', text: 'Allow remote access', isCorrect: false, feedback: 'Never give remote access to unknown callers!', riskLevel: 5),
        DialogueOption(id: '5b', text: 'Hang up and contact your ISP directly', isCorrect: true, feedback: 'Excellent! Always verify through official channels.', riskLevel: 1),
        DialogueOption(id: '5c', text: 'Ask for their company details first', isCorrect: false, feedback: 'Scammers can fake credentials. Better to hang up.', riskLevel: 3),
      ],
      explanation: 'Legitimate tech support doesn\'t make unsolicited calls asking for remote access.',
      category: 'social_engineering',
    ),
    DialogueChallenge(
      id: 'dialogue_6',
      scenario: 'Arya finds a USB drive in the university parking lot',
      message: 'You found a USB drive labeled "Confidential Student Records - Return to Admin Office". What do you do?',
      options: [
        DialogueOption(id: '6a', text: 'Plug it into your computer to see what\'s on it', isCorrect: false, feedback: 'USB drives can contain malware! Never plug in unknown devices.', riskLevel: 5),
        DialogueOption(id: '6b', text: 'Take it directly to the admin office without plugging it in', isCorrect: true, feedback: 'Perfect! This is the safest approach.', riskLevel: 1),
        DialogueOption(id: '6c', text: 'Ignore it and leave it there', isCorrect: false, feedback: 'Better to report it, but don\'t plug it in anywhere.', riskLevel: 2),
      ],
      explanation: 'USB drops are a common attack method. Never plug unknown devices into your computer.',
      category: 'malware',
    ),
  ];

  // Badges
  static final List<Badge> badges = [
    Badge(id: 'email_guardian', name: 'Email Guardian', description: 'Identified all phishing emails in Level 1', icon: '🛡️'),
    Badge(id: 'link_detective', name: 'Link Detective', description: 'Spotted all fake URLs in Level 2', icon: '🔍'),
    Badge(id: 'response_master', name: 'Response Master', description: 'Made all correct choices in Level 3', icon: '💬'),
  ];

  // All Levels
  static final List<Level> levels = [
    Level(
      id: 'level_1',
      name: 'Inbox Invader',
      description: 'Sort legitimate emails from phishing attempts',
      type: 'inbox_invader',
      challenges: level1Emails,
      timeLimit: 300,
      passingScore: 80,
      badge: badges[0],
    ),
    Level(
      id: 'level_2',
      name: 'Link Logic',
      description: 'Identify legitimate URLs from fake ones',
      type: 'link_logic',
      challenges: level2Links,
      timeLimit: 240,
      passingScore: 75,
      badge: badges[1],
    ),
    Level(
      id: 'level_3',
      name: 'Reply Right',
      description: 'Choose the safest responses to cyber threats',
      type: 'reply_right',
      challenges: level3Dialogues,
      timeLimit: 360,
      passingScore: 85,
      badge: badges[2],
    ),
  ];
}