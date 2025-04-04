import 'dart:io';
import '../client/api/voting_client.dart';
import '../models/login_model.dart';
import '../models/question_model.dart';
import 'voting_repository.dart';

class VotingRepositoryImpl implements VotingRepository {
  final VotingClient _client;

  VotingRepositoryImpl({required VotingClient client}) : _client = client;

  @override
  Future<LoginResponse> login(String username, String password) async {
    return await _client.login(username, password);
  }

  @override
  Future<List<QuestionShort>> getQuestions() async {
    return await _client.getQuestions();
  }

  @override
  Future<QuestionDetail> getQuestionDetails(String questionId) async {
    return await _client.getQuestionDetails(questionId);
  }

  @override
  Future<File> downloadFile(String fileId, String savePath) async {
    return await _client.downloadFile(fileId, savePath);
  }

  @override
  Future<void> vote(String questionId, int answerId) async {
    await _client.vote(questionId, answerId);
  }

  @override
  bool get isAuthenticated => _client.isAuthenticated;

  @override
  void logout() {
    _client.logout();
  }
}
