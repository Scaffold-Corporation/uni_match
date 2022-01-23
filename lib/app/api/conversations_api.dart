import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uni_match/app/models/user_model.dart';
import 'package:uni_match/constants/constants.dart';

class ConversationsApi {
  /// Get firestore instance
  ///
  final _firestore = FirebaseFirestore.instance;

  /// Save last conversation in database
  Future<void> saveConversation({
    required String type,
    required String senderId,
    required String receiverId,
    required String userPhotoLink,
    required String userFullName,
    required String textMsg,
    required bool isRead,
    required bool likeMsg,
    required String replyMsg,
    required String replyType,
    required String userReplyMsg,
    required String idDoc,
  }) async {
    await _firestore
        .collection(C_CONNECTIONS)
        .doc(senderId)
        .collection(C_CONVERSATIONS)
        .doc(receiverId)
        .set(<String, dynamic>{
      ID_DOC:idDoc,
      USER_ID: receiverId,
      USER_PROFILE_PHOTO: userPhotoLink,
      USER_FULLNAME: userFullName,
      MESSAGE_TYPE: type,
      LAST_MESSAGE: textMsg,
      REPLY_TEXT: replyMsg,
      REPLY_TYPE: replyType,
      LIKE_MSG: likeMsg,
      MESSAGE_READ: isRead,
      USER_REPLY_TEXT: userReplyMsg,
      TIMESTAMP: DateTime.now(),
    }).then((value) {
      debugPrint('saveConversation() -> succes');
    }).catchError((e) {
      print('saveConversation() -> error: $e');
    });
  }

  ///Update Conversation

  Future<void> updateConversation({
    required String senderId,
    required String receiverId,
    required bool likeMsg,
  }) async {
    await _firestore
        .collection(C_CONNECTIONS)
        .doc(senderId)
        .collection(C_CONVERSATIONS)
        .doc(receiverId)
        .update(<String, dynamic>{
      USER_ID: receiverId,
      LIKE_MSG: likeMsg,
    }).then((value) {
      debugPrint('updateConversation() -> succes');
    }).catchError((e) {
      print('updateConversation() -> error: $e');
    });
  }

  /// Get stream conversations for current user
  Stream<QuerySnapshot> getConversations() {
    return _firestore
        .collection(C_CONNECTIONS)
        .doc(UserModel().user.userId)
        .collection(C_CONVERSATIONS)
        .orderBy(TIMESTAMP, descending: true)
        .snapshots();
  }

  /// Delete current user conversation
  Future<void> deleteConverce(String withUserId,
      {bool isDoubleDel = false}) async {
    // For current user
    await _firestore
        .collection(C_CONNECTIONS)
        .doc(UserModel().user.userId)
        .collection(C_CONVERSATIONS)
        .doc(withUserId)
        .delete();
    // Delete the current user id from onother user conversation list
    if (isDoubleDel) {
      await _firestore
          .collection(C_CONNECTIONS)
          .doc(withUserId)
          .collection(C_CONVERSATIONS)
          .doc(UserModel().user.userId)
          .delete();
    }
  }
}
