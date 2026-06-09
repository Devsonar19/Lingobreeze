import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/word_model.dart';

abstract class VocabularyRemoteDataSource {
  Future<List<WordModel>> getWords();
  Future<void> addWord(String word, String meaning, String exampleSentence);
  Future<void> updateWord(String id, String word, String meaning, String exampleSentence);
  Future<void> deleteWord(String id);
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Helper to ensure user is logged in
  String get _userId {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  @override
  Future<List<WordModel>> getWords() async {
    try {
      // Only fetch words belonging to the current user, sorted by newest
      final snapshot = await firestore
          .collection('words')
          .where('userId', isEqualTo: _userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => WordModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch words from Firebase: $e');
    }
  }

  @override
  Future<void> addWord(String word, String meaning, String exampleSentence) async {
    try {
      final newWord = WordModel(id: '', word: word, meaning: meaning, exampleSentence: exampleSentence);
      await firestore.collection('words').add(newWord.toMap(_userId));
    } catch (e) {
      throw Exception('Failed to add word to Firebase: $e');
    }
  }

  @override
  Future<void> updateWord(String id, String word, String meaning, String exampleSentence) async {
    try {
      await firestore.collection('words').doc(id).update({
        'word': word,
        'meaning': meaning,
        'exampleSentence': exampleSentence,
      });
    } catch (e) {
      throw Exception('Failed to update word in Firebase: $e');
    }
  }

  @override
  Future<void> deleteWord(String id) async {
    try {
      await firestore.collection('words').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete word from Firebase: $e');
    }
  }
}