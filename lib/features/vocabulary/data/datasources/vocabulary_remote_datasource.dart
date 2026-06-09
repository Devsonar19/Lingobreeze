import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/word_model.dart';

abstract class VocabularyRemoteDataSource {
  Future<List<WordModel>> fetchWordsFromNode();
  Future<void> saveWordToFirebase(WordModel word);
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  final FirebaseFirestore firestore;
  final http.Client client;

  // NOTE: Keep your existing 192.168.x.x IP address here!
  final String nodeBaseUrl = 'http://192.168.29.217:3000';

  VocabularyRemoteDataSourceImpl({required this.firestore, required this.client});

  // Helper method to grab the current user's ID
  String get _currentUserId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User is not logged in");
    return user.uid;
  }

  @override
  Future<List<WordModel>> fetchWordsFromNode() async {
    // Attach the userId to the end of the URL
    final response = await client.get(Uri.parse('$nodeBaseUrl/words?userId=$_currentUserId'));

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
      // Convert the word to a map and inject the userId stamp
      final data = word.toFirestore();
      data['userId'] = _currentUserId;

      await firestore.collection('words').add(data);
    } catch (e) {
      throw Exception('Failed to save word directly to Firebase: $e');
    }
  }
}