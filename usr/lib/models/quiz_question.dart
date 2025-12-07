class QuizQuestion {
  final String text;
  final int intensity; // 1-10

  QuizQuestion({required this.text, required this.intensity});
}

final List<QuizQuestion> embarrassingQuestions = [
  QuizQuestion(text: "Quelle est ta recherche Google la plus honteuse des 7 derniers jours ?", intensity: 5),
  QuizQuestion(text: "Montre la dernière photo de ta galerie (sans tricher).", intensity: 7),
  QuizQuestion(text: "Qui est la personne que tu détestes le plus ici ?", intensity: 9),
  QuizQuestion(text: "As-tu déjà stalké un(e) ex cette semaine ?", intensity: 6),
  QuizQuestion(text: "Quel est le pire mensonge que tu as dit à tes parents ?", intensity: 8),
  QuizQuestion(text: "Si tu devais coucher avec un collègue, qui serait-ce ?", intensity: 10),
  QuizQuestion(text: "As-tu déjà fait pipi dans une piscine adulte ?", intensity: 4),
  QuizQuestion(text: "Quel est ton mot de passe le plus utilisé ?", intensity: 10),
];
