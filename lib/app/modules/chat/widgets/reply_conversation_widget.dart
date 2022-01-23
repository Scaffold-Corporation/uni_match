import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_match/app/models/user_model.dart';

class ReplyConversationWidget extends StatelessWidget {
  final String message;
  final String userName;
  final bool userSend;
  final bool isImage;
  final String imageLink;
  const ReplyConversationWidget({
    required this.message,
    required this.userName,
    required this.userSend,
    required this.isImage,
    required this.imageLink,
  });
  @override
  Widget build(BuildContext context) =>

      IntrinsicHeight(
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: userSend ?Colors.white70  :Colors.white54,
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: Row(
        children: [
          Container(
            color: userSend ?Colors.pinkAccent  :Color (0xFF871F78),
            width: 4,
          ),
          const SizedBox(width: 8),
          Expanded(child: buildReplyMessage()),
        ],
      ),
    ),
  );
  Widget buildReplyMessage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            userName == UserModel().user.userFullname ? 'Você':userName,
            style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize:17,
            fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ],
      ),
      const SizedBox(height: 4),
    //this.message.substring(0,5) == 'https'?
      this.isImage?
      Card(
      /// Image
        semanticContainer: true,
        margin: const EdgeInsets.all(0),
        color: Colors.grey.withAlpha(70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
            width: 70,
            height: 70,
            child: Image.network(message)))
          : Text(this.message,
      style: GoogleFonts.nunito(
        color: Colors.black,
        fontSize: 15,
        height: 1.1,
      ),
      textAlign: TextAlign.start,
      )
    ],
  );
}