import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uni_match/app/api/likes_api.dart';
import 'package:uni_match/app/api/matches_api.dart';
import 'package:uni_match/app/api/messages_api.dart';
import 'package:uni_match/app/api/notifications_api.dart';
import 'package:uni_match/app/app_controller.dart';
import 'package:uni_match/app/datas/user.dart';
import 'package:uni_match/app/models/user_model.dart';
import 'package:uni_match/app/modules/chat/store/chat_store.dart';
import 'package:uni_match/app/modules/chat/widgets/reply_message_widget.dart';
import 'package:uni_match/app/modules/profile/view/profile_screen.dart';
import 'package:uni_match/constants/constants.dart';
import 'package:uni_match/dialogs/common_dialogs.dart';
import 'package:uni_match/dialogs/progress_dialog.dart';
import 'package:uni_match/widgets/chat_message.dart';
import 'package:uni_match/widgets/image_source_sheet.dart';
import 'package:uni_match/widgets/my_circular_progress.dart';
import 'package:uni_match/widgets/show_lost_connection.dart';
import 'package:uni_match/widgets/svg_icon.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ChatScreen extends StatefulWidget {
  /// Get user object
  final Usuario user;

  ChatScreen({required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ModularState<ChatScreen, ChatStore> {
  // Variables
  final _messagesController = ScrollController();
  final _messagesApi = MessagesApi();
  final _matchesApi = MatchesApi();
  final _likesApi = LikesApi();
  final _notificationsApi = NotificationsApi();
  final String replyMessage = '';

  _testerede() async {
    try {
      await FirebaseFirestore.instance
          .runTransaction((Transaction tx) async {})
          .timeout(Duration(milliseconds: 1500));

    } on PlatformException catch (_) {
      showDialog(
          context: context,
          builder: (context) {
            return ShowDialogLostConnection();
          });

    } on TimeoutException catch (_) {
      showDialog(
          context: context,
          builder: (context) {
            return ShowDialogLostConnection();
          });
    }
  }

  void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  void showKeyboard(BuildContext context) {
    final focusScope = FocusScope.of(context);
    focusScope.requestFocus(FocusNode());
    Future.delayed(
        Duration.zero, () => focusScope.requestFocus(controller.focusNode));
  }

  late Stream<QuerySnapshot> _messages;
  bool _isComposing = false;
  AppController _i18n = Modular.get();
  late ProgressDialog _pr;

  void _scrollMessageList() {
    /// Scroll to button
    _messagesController.animateTo(0.0,
        duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  ///build of the ReplyMessage layout
  Widget buildReply() => ReplyMessageWidget(
        context: context,
        message: controller.replyMessage,
        otherUser: controller.comparationWhoSendM(
            UserModel().user.userFullname, widget.user.userFullname),
        onCancelReply: controller.cancelReply,
        isImage: controller.isImage,
      );

  /// Get image from camera / gallery
  Future<void> _getImage() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => ImageSourceSheet(
              tipoImagem: "chat",
              onImageSelected: (image) async {
                if (image != null) {
                  Navigator.of(context).pop();
                  await _sendMessage(
                    type: 'image',
                    imgFile: image,
                    replyText: controller.replyMessage,
                    replyType: controller.isImage ? 'image' : 'text',
                    userReplyMsg: controller.comparationWhoSendM(
                        UserModel().user.userFullname,
                        widget.user.userFullname),
                    likeMsg: controller.likeMsg,
                  );
                  // close modal
                }
              },
            ));
  }

  // Send message
  Future<void> _sendMessage({
    required String type,
    String? text,
    File? imgFile,
    required replyText,
    required String replyType,
    required userReplyMsg,
    required likeMsg,
  }) async {
    String textMsg = '';
    String imageUrl = '';

    // Check message type
    switch (type) {
      case 'text':
        textMsg = text!;
        break;

      case 'image':
        // Show processing dialog
        _pr.show(_i18n.translate("sending")!);

        /// Upload image file
        imageUrl = await UserModel().uploadFile(
            file: imgFile!,
            path: 'uploads/messages',
            userId: UserModel().user.userId);

        _pr.hide();
        break;
    }
    String idDoc = _messagesApi.getId(
        senderId: UserModel().user.userId, receiverId: widget.user.userId);

    /// Save message for current user
    await _messagesApi.saveMessage(
      idDoc: idDoc,
      type: type,
      replyType: replyType,
      fromUserId: UserModel().user.userId,
      senderId: UserModel().user.userId,
      receiverId: widget.user.userId,
      userPhotoLink: widget.user.userProfilePhoto, // other user photo
      userFullName: widget.user.userFullname, // other user ful name
      textMsg: textMsg,
      imgLink: imageUrl,
      replyMsg: replyText,
      likeMsg: likeMsg,
      userReplyMsg: userReplyMsg,
      isRead: true,
    );

    /// Save copy message for receiver
    await _messagesApi.saveMessage(
      idDoc: idDoc,
      type: type,
      replyType: replyType,
      fromUserId: UserModel().user.userId,
      senderId: widget.user.userId,
      receiverId: UserModel().user.userId,
      userPhotoLink: UserModel().user.userProfilePhoto, // current user photo
      userFullName: UserModel().user.userFullname, // current user ful name
      textMsg: textMsg,
      replyMsg: replyText,
      likeMsg: likeMsg,
      imgLink: imageUrl,
      userReplyMsg: userReplyMsg,
      isRead: false,
    );

    /// Send push notification
    await _notificationsApi.sendPushNotification(
        nTitle: UserModel().user.userFullname.split(' ')[0],
        nBody: '${_i18n.translate("sent_a_message_to_you")}',
        nType: 'message',
        nSenderId: UserModel().user.userId,
        nUserDeviceToken: widget.user.userDeviceToken);
  }

  Future<void> _updateMenssage({
    required likeMsg,
    required idDoc,
  }) async {
    /// Save message for current user
    await _messagesApi.updateMessage(
      senderId: UserModel().user.userId,
      receiverId: widget.user.userId,
      likeMsg: likeMsg,
      idDoc: idDoc,
    );

    /// Save copy message for receiver
    await _messagesApi.updateMessage(
      senderId: widget.user.userId,
      receiverId: UserModel().user.userId,
      likeMsg: likeMsg,
      idDoc: idDoc,
    );
  }

  _updateConnectionStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        controller.statusConnection = 'online';
      }
    } on SocketException catch (_) {
      print('not connected');
      controller.statusConnection = 'offiline';
    }
  }

  late StreamSubscription<bool> subscription;
  var subscriptionConect;
  @override
  void initState() {
    super.initState();
    _testerede();

    subscriptionConect = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        _updateConnectionStatus();
      } else {
        setState(() {
          controller.statusConnection = 'offiline';
        });
      }
    });
    subscription =
        KeyboardVisibilityController().onChange.listen((isVisible) {});
    _messages = _messagesApi.getMessages(widget.user.userId);
    controller.focusNode.addListener(() {
      controller.textController.text = controller.textController.text;
      if (controller.focusNode.hasFocus) {
        controller.showEmoji = false;
      }
    });
  }

  @override
  void dispose() {
    _messages.drain();
    subscription.cancel();
    controller.textController.dispose();
    _messagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Initialization
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    _pr = ProgressDialog(context);
    return Scaffold(
      ///AppBar.
      appBar: AppBar(
        // Show User profile info
        title: GestureDetector(
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 0),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.userProfilePhoto),
            ),
            title:
                Text(widget.user.userFullname, style: TextStyle(fontSize: 18)),
          ),
          onTap: () {
            /// Go to profile screen
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(user: widget.user, showButtons: false)));
          },
        ),
        actions: <Widget>[
          /// Actions list
          PopupMenuButton<String>(
            initialValue: "",
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              /// Delete Chat
              PopupMenuItem(
                  value: "delete_chat",
                  child: Row(
                    children: <Widget>[
                      SvgIcon("assets/icons/trash_icon.svg",
                          width: 20,
                          height: 20,
                          color: Theme.of(context).primaryColor),
                      SizedBox(width: 5),
                      Text(_i18n.translate("delete_conversation")!),
                    ],
                  )),

              /// Delete Match
              PopupMenuItem(
                  value: "delete_match",
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.highlight_off,
                          color: Theme.of(context).primaryColor),
                      SizedBox(width: 5),
                      Text(_i18n.translate("delete_match")!)
                    ],
                  )),
            ],
            onSelected: (val) {
              /// Control selected value
              switch (val) {
                case "delete_chat":

                  /// Delete chat
                  confirmDialog(context,
                      title: _i18n.translate("delete_conversation"),
                      message: _i18n.translate("conversation_will_be_deleted")!,
                      negativeAction: () => Navigator.of(context).pop(),
                      positiveText: _i18n.translate("DELETE"),
                      positiveAction: () async {
                        // Close the confirm dialog
                        Navigator.of(context).pop();

                        // Show processing dialog
                        _pr.show(_i18n.translate("processing")!);

                        /// Delete chat
                        await _messagesApi.deleteChat(widget.user.userId);
                        // Hide progress
                        await _pr.hide();
                      });
                  break;

                case "delete_match":
                  errorDialog(context,
                      title: _i18n.translate("delete_match"),
                      message:
                          "${_i18n.translate("are_you_sure_you_want_to_delete_your_match_with")}: "
                          "${widget.user.userFullname}?\n\n"
                          "${_i18n.translate("this_action_cannot_be_reversed")}",
                      positiveText: _i18n.translate("DELETE"),
                      negativeAction: () => Navigator.of(context).pop(),
                      positiveAction: () async {
                        // Show processing dialog
                        _pr.show(_i18n.translate("processing")!);

                        /// Delete match
                        await _matchesApi.deleteMatch(widget.user.userId);

                        /// Delete chat
                        await _messagesApi.deleteChat(widget.user.userId);

                        /// Delete like
                        await _likesApi.deleteLike(widget.user.userId);

                        // Hide progress
                        _pr.hide();
                        // Hide dialog
                        Navigator.of(context).pop();
                        // Close chat screen
                        Navigator.of(context).pop();
                      });
                  break;
              }
              print("Selected action: $val");
            },
          ),
        ],
      ),

      ///FimAppBar.

      ///Column das mensagens.
      body: WillPopScope(
        onWillPop: () {
          if (controller.showEmoji == true) {
            controller.showEmoji = false;
          } else {
            Navigator.pop(context);
          }
          return Future.value(false);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            /// how message list
            Expanded(child: Container(child: _showMessages())),

            /// Text Composer
            ///
          Observer(
              builder: (_) =>ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FadeInUp(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  if (controller.replyMessage != '')
                                    Container(child: buildReply()),
                                  TextFormField(
                                    autofocus: true,
                                    textInputAction: TextInputAction.newline,
                                    focusNode: controller.focusNode,
                                    cursorColor: Colors.pinkAccent.shade200,
                                    cursorWidth: 2,
                                    controller: controller.textController,
                                    maxLines: 4,
                                    minLines: 1,
                                    style: GoogleFonts.nunito(
                                        color: Colors.black, fontSize: 17),
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.only(
                                          topLeft: controller.replyMessage != ''
                                              ? Radius.zero
                                              : Radius.circular(25),
                                          topRight:
                                              controller.replyMessage != ''
                                                  ? Radius.zero
                                                  : Radius.circular(25),
                                          bottomLeft: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        ),
                                      ),
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                bottom: 0),
                                        child: IconButton(
                                            iconSize: 30,
                                            icon: Icon(
                                                controller.showEmoji == true
                                                    ? Icons.keyboard
                                                    : Icons.insert_emoticon),
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            color: Colors.grey,
                                            onPressed: () {
                                              controller.focusNode.unfocus();
                                              controller.showEmojiKeyboard();
                                            }),
                                      ),
                                      suffixIcon: IconButton(
                                          icon: SvgIcon(
                                              "assets/icons/camera_icon.svg",
                                              width: 20,
                                              height: 20),
                                          onPressed: () async {
                                            /// Send image file
                                            await _getImage();
                                            controller.cancelReply();
                                            controller.focusNode.nextFocus();
                                            controller.focusNode.hasFocus;

                                            /// Update scroll
                                            _scrollMessageList();
                                          }),
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      hintText:
                                          _i18n.translate("type_a_message"),
                                      hintMaxLines: 1,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.only(
                                          topLeft: controller.replyMessage != ''
                                              ? Radius.zero
                                              : Radius.circular(25),
                                          topRight:
                                              controller.replyMessage != ''
                                                  ? Radius.zero
                                                  : Radius.circular(25),
                                          bottomLeft: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        ),
                                      ),
                                    ),
                                    onChanged: (text) {
                                      setState(() {
                                        if (text == ' ') {
                                          controller.textController.clear();
                                        }
                                        _isComposing = text.trim().isNotEmpty;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: IconButton(
                                  icon: Icon(Icons.send,
                                      color: _isComposing
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: _isComposing
                                      ? () async {
                                          final text = controller.textController.text.trim();

                                          final replyText = controller.replyMessage;
                                          final replyType = controller.isImage
                                              ? 'image'
                                              : 'text';

                                          /// clear input text
                                          controller.textController.clear();
                                          setState(() {
                                            controller.cancelReply();
                                            _isComposing = false;
                                          });

                                          /// Send text message
                                          await _sendMessage(
                                            type: 'text',
                                            text: text,
                                            replyType: replyType,
                                            replyText: replyText,
                                            userReplyMsg:
                                                controller.comparationWhoSendM(
                                                    UserModel()
                                                        .user
                                                        .userFullname,
                                                    widget.user.userFullname),
                                            likeMsg: controller.likeMsg,
                                          );

                                          /// Update scroll
                                          _scrollMessageList();
                                        }
                                      : null),
                            ),
                          ],
                        ),
                      ),
                    ),
                    !isKeyboard && controller.showEmoji == true
                        ? FadeInUp(
                            child: Container(
                                height: 250,
                                width: double.maxFinite,
                                child: emojibuilder()))
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      ///Column das mensagens.
    );
  }

  Widget emojibuilder() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          controller.onEmojiSelected(emoji);
          setState(() {
            if (controller.textController.text != '') {
              _isComposing = true;
            }
          });
        },
        onBackspacePressed: () {
          controller.textController.text =
              controller.textController.text.characters.skipLast(1).toString();
          setState(() {
            if (controller.textController.text == '') {
              _isComposing = false;
            }
          });
        },
        config: Config(
          columns: 7,
          emojiSizeMax: 32.0 * (Platform.isIOS ? 1.30 : 1.0),
          verticalSpacing: 0,
          horizontalSpacing: 0,
          initCategory: Category.RECENT,
          bgColor: Theme.of(context).cardColor,
          indicatorColor: Colors.pinkAccent,
          iconColor: Colors.pink.shade100,
          iconColorSelected: Colors.pink,
          progressIndicatorColor: Colors.pink.shade100,
          showRecentsTab: true,
          backspaceColor: Colors.pink,
          recentsLimit: 28,
          noRecentsText: "Nada recente",
          noRecentsStyle: const TextStyle(
            fontSize: 18,
            color: Colors.pink,
          ),
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
      ),
    );
  }

  /// Responder mensagem

  /// _showMessages
  Widget _showMessages() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _messages,
          builder: (context, snapshot) {
            // Check data
            if (!snapshot.hasData)
              return MyCircularProgress();
            else {
              return ListView.builder(
                controller: _messagesController,
                reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  // Get message list
                  final List<DocumentSnapshot> messages =
                      snapshot.data!.docs.reversed.toList();
                  // Get message doc map
                  final Map<dynamic, dynamic> msg =
                      messages[index].data()! as Map;

                  /// Variables
                  bool isUserSender;
                  String userPhotoLink;

                  final bool isImage = msg[MESSAGE_TYPE] == 'image';
                  final bool likeMsgBool = msg[LIKE_MSG];
                  final bool isReplyImage = msg[REPLY_TYPE] == 'image';
                  final String textMessage =
                      msg[MESSAGE_TEXT] == null ? '' : msg[MESSAGE_TEXT];
                  final String replyMsg =
                      msg[REPLY_TEXT] == null ? '' : msg[REPLY_TEXT];
                  final String userReply =
                      msg[USER_REPLY_TEXT] == null ? '' : msg[USER_REPLY_TEXT];
                  final String idDoc =
                      msg['id_doc'] == null ? '' : msg['id_doc'];
                  final String? imageLink = msg[MESSAGE_IMG_LINK];
                  final String timeAgo =
                      timeago.format(msg[TIMESTAMP].toDate(), locale: 'pt_BR');

                  /// Check user id to get info
                  if (msg[USER_ID] == UserModel().user.userId) {
                    isUserSender = true;
                    userPhotoLink = UserModel().user.userProfilePhoto;
                  } else {
                    isUserSender = false;
                    userPhotoLink = widget.user.userProfilePhoto;
                  }

                  // Show chat bubble
                  return GestureDetector(
                    onDoubleTap: () async {
                      //controller.userLikedId = UserModel().user.userId;
                      if (likeMsgBool && !isUserSender) {
                        await _updateMenssage(likeMsg: false, idDoc: idDoc);
                      }
                      if (!likeMsgBool && !isUserSender)
                        await _updateMenssage(likeMsg: true, idDoc: idDoc);
                    },
                    child: SwipeTo(
                      iconColor: Colors.transparent,
                      offsetDx: 0.2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 8.0),
                        child: ChatMessage(
                          isUserSender: isUserSender,
                          isImage: isImage,
                          isReplyImage: isReplyImage,
                          userPhotoLink: userPhotoLink,
                          textMessage: textMessage,
                          imageLink: imageLink,
                          timeAgo: timeAgo,
                          replyMessage: replyMsg,
                          userReply: userReply,
                          likeMsg: likeMsgBool,
                        ),
                      ),
                      onRightSwipe: () {
                        controller.showEmoji = false;
                        if (window.viewInsets.bottom <= 0.0) {
                          showKeyboard(context);
                        }
                        controller.replyToMessage(
                            textMessage, isUserSender, imageLink!, isImage);
                      },
                    ),
                  );
                },
              );
            }
          }),
    );
  }

  /// showMessages
}
