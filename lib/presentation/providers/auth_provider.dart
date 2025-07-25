// providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahayak_ai2/data/models/teacher/teacher_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  Teacher? _teacher;
  bool _isLoading = false;

  User? get user => _user;
  Teacher? get teacher => _teacher;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    if (user != null) {
      await _loadTeacherProfile();
    } else {
      _teacher = null;
    }
    notifyListeners();
  }

  Future<void> _loadTeacherProfile() async {
    if (_user == null) return;

    try {
      final doc = await _firestore.collection('teachers').doc(_user!.uid).get();
      if (doc.exists) {
        _teacher = Teacher.fromMap(doc.data()!);
      }
    } catch (e) {
      print('Error loading teacher profile: $e');
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUpWithEmail(
      String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        await _createTeacherProfile(credential.user!, name);
        return true;
      }
      return false;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _createTeacherProfile(User user, String name) async {
    final teacher = Teacher(
      id: user.uid,
      name: name,
      email: user.email!,
      classesHandling: [],
      subjects: [],
      syllabusType: '',
      medium: '',
      schoolContext: '',
      stressProfile: {},
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );

    await _firestore.collection('teachers').doc(user.uid).set(teacher.toMap());
    _teacher = teacher;
  }

  Future<void> updateTeacherProfile(Map<String, dynamic> updates) async {
    if (_user == null) return;

    try {
      await _firestore.collection('teachers').doc(_user!.uid).update(updates);
      await _loadTeacherProfile();
    } catch (e) {
      print('Error updating teacher profile: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
