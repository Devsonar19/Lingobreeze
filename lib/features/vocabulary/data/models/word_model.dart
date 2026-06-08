import '../../domain/entities/word_entity.dart';

class WordModel extends WordEntity {
  const WordModel({
    required super.id,
    required super.word,
    required super.meaning,
    required super.exampleSentence,
  });

  // Parse JSON from Node.js Express Server
  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] ?? '',
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? json['translation'] ?? '',
      exampleSentence: json['exampleSentence'] ?? '',
    );
  }

  // Convert to map for direct Firebase save
  Map<String, dynamic> toFirestore() {
    return {
      'word': word,
      'meaning': meaning,
      'exampleSentence': exampleSentence,
      'createdAt': DateTime.now().toIso8601String(), // Good practice for sorting
    };
  }
}