class Blackmail {
  final String id;
  final String title;
  final String description;
  final String consequenceText;
  final String iconEmoji;

  Blackmail({
    required this.id,
    required this.title,
    required this.description,
    required this.consequenceText,
    required this.iconEmoji,
  });
}

final List<Blackmail> blackmailOptions = [
  Blackmail(
    id: 'social_shame',
    title: 'La Honte Sociale',
    description: 'Si tu ne dors pas, je publie "J\'aime écouter du Nickelback en secret" sur tes réseaux.',
    consequenceText: 'TWEET ENVOYÉ : "J\'aime écouter du Nickelback en secret et je pleure devant des pubs de lessive."',
    iconEmoji: '🐦',
  ),
  Blackmail(
    id: 'money_loss',
    title: 'Le Don Douloureux',
    description: 'Je vire 50€ à une association que tu détestes (ex: "Ligue de protection des moustiques").',
    consequenceText: 'VIREMENT EFFECTUÉ : 50€ envoyés à la "Ligue de Protection des Moustiques Tigres".',
    iconEmoji: '💸',
  ),
  Blackmail(
    id: 'ex_text',
    title: 'Le SMS à l\'Ex',
    description: 'J\'envoie "Tu me manques trop..." à ton ex toxique.',
    consequenceText: 'SMS ENVOYÉ À "EX TOXIQUE" : "Tu me manques trop, on peut se revoir ?"',
    iconEmoji: '💔',
  ),
  Blackmail(
    id: 'browser_history',
    title: 'L\'Historique Public',
    description: 'J\'envoie ton historique de navigation à ta mère.',
    consequenceText: 'EMAIL ENVOYÉ À MAMAN : "Regarde ce que ton enfant cherche sur Google..."',
    iconEmoji: '🫣',
  ),
];
