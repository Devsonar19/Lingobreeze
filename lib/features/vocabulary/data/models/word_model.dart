import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/word_entity.dart';

class WordModel extends WordEntity {
  const WordModel({
    required super.id,
    required super.word,
    required super.meaning,
    required super.exampleSentence,
  });

  // NEW: Safely extracts data directly from a Firestore Document
  factory WordModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WordModel(
      id: doc.id, // Grabs the auto-generated Firebase ID
      word: data['word'] ?? '',
      meaning: data['meaning'] ?? '',
      exampleSentence: data['exampleSentence'] ?? '',
    );
  }

  // Used for saving TO Firebase
  Map<String, dynamic> toMap(String userId) {
    return {
      'word': word,
      'meaning': meaning,
      'exampleSentence': exampleSentence,
      'userId': userId, // Crucial for keeping data private
      'createdAt': FieldValue.serverTimestamp(), // Sorts newest first
    };
  }

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