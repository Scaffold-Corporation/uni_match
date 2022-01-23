import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uni_match/app/modules/chat/widgets/reply_conversation_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessage extends StatelessWidget {
  // Variables
  final bool isUserSender;
  final String userPhotoLink;
  final bool isImage;
  final String? imageLink;
  final String? textMessage;
  final String timeAgo;
  final String replyMessage;
  final String userReply;
  final bool isReplyImage;
  final bool likeMsg;

  ChatMessage({
    required this.isUserSender,
    required this.userPhotoLink,
    required this.timeAgo,
    required this.isImage,
    this.imageLink,
    this.textMessage,
    required this.replyMessage,
    required this.userReply,
    required this.isReplyImage,
    required this.likeMsg,
  });

  Widget buildReply() => ReplyConversationWidget(
        message: replyMessage,
        userName: userReply,
        userSend: isUserSender,
        isImage: isReplyImage,
        imageLink: imageLink!,
      );

  @override
  Widget build(BuildContext context) {
    /// User profile photo
    final _userProfilePhoto = CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      backgroundImage: NetworkImage(userPhotoLink),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child: Row(
        children: <Widget>[
          /// User receiver photo Left
          !isUserSender
              ? Column(
                  children: [
                    _userProfilePhoto,
                    if (likeMsg)
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      )
                  ],
                )
              : Container(width: 0, height: 0),

          SizedBox(width: 10),

          /// User message
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isUserSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                /// Message container
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          isUserSender
                              ? Colors.pink.shade300
                              : Colors.purple.shade900,
                          isUserSender
                              ? Colors.pink.shade300
                              : Color(0xFF871F78),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    children: [
                      replyMessage.isNotEmpty
                          ? Container(
                              width: replyMessage.isNotEmpty
                                  ? MediaQuery.of(context).size.width * 0.65
                                  : null,
                              child: buildReply())
                          : Container(
                              width: 0,
                            ),
                      isImage
                          ? Container(
                              child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            _ShowFullImage(imageLink!)));
                              },
                              child: Card(
                                /// Image
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                margin: const EdgeInsets.all(2),
                                color: Colors.grey.withAlpha(70),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                    width: 200,
                                    height: 200,
                                    child: Hero(
                                        tag: imageLink!,
                                        child: Image.network(imageLink!)
                                        // Image.network(imageLink!)
                                        )),
                              ),
                            ))

                          /// Text message
                          :
                          Container(
                              width: replyMessage.isNotEmpty
                                  ? MediaQuery.of(context).size.width * 0.65
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4, top: 3),
                                child: SelectableText(
                                  textMessage ?? "",
                                  style: GoogleFonts.nunito(
                                      height: 1.3,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: isUserSender
                                          ? Colors.white
                                          : Colors.white),
                                  toolbarOptions: ToolbarOptions(
                                    selectAll: true,
                                    copy: true,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 3),

                /// Message time ago
                Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      timeAgo,
                      style: GoogleFonts.openSans(
                        fontSize: 11,
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(width: 1),

          /// Current User photo right
          isUserSender
              ? Column(
                  children: [
                    _userProfilePhoto,
                    if (likeMsg)
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      )
                  ],
                )
              : Container(width: 0, height: 0),
        ],
      ),
    );
  }
}

// Show chat image on full screen
class _ShowFullImage extends StatelessWidget {
  // Param
  final String imageUrl;

  _ShowFullImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InteractiveViewer(
        boundaryMargin: EdgeInsets.all(0),
        maxScale: 10.0,
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
