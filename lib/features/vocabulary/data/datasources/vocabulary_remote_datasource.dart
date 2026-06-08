import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word_model.dart';

abstract class VocabularyRemoteDataSource {
  Future<List<WordModel>> fetchWordsFromNode();
  Future<void> saveWordToFirebase(WordModel word);
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  final FirebaseFirestore firestore;
  final http.Client client;

  // Use 10.0.2.2 for Android Emulator, or localhost / IP for Linux desktop build
  final String nodeBaseUrl = 'http://10.0.2.2:3000';

  VocabularyRemoteDataSourceImpl({required this.firestore, required this.client});

  @override
  Future<List<WordModel>> fetchWordsFromNode() async {
    final response = await client.get(Uri.parse('$nodeBaseUrl/words'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => WordModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load words from Node API');
    }
  }

  @override
  Future<void> saveWordToFirebase(WordModel word) async {
    try {
      await firestore.collection('words').add(word.toFirestore());
    } catch (e) {
      throw Exception('Failed to save word directly to Firebase: $e');
    }
  }
}