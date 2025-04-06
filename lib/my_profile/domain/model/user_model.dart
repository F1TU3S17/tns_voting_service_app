import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/entity/user.dart';
import 'package:tns_voting_service_app/core/repository/repository_provider.dart';
import 'package:tns_voting_service_app/core/repository/voting_repository.dart';


class UserModel extends ChangeNotifier{
  VotingRepository repository = RepositoryProvider.getRepository();

  User? _user;
  bool isLoading = true;
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
  User? get getUser => _user;

  
  Future<void> init() async{
    isLoading = true;
    notifyListeners();
    _user = await repository.getUserInfo();
    notifyListeners();
    isLoading = false;
  
  }
  

}