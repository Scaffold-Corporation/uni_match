import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ntp/ntp.dart';
import 'package:uni_match/app/api/dislikes_api.dart';
import 'package:uni_match/app/api/likes_api.dart';
import 'package:uni_match/app/api/matches_api.dart';
import 'package:uni_match/app/api/users_api.dart';
import 'package:uni_match/app/api/visits_api.dart';
import 'package:uni_match/app/app_controller.dart';
import 'package:uni_match/app/datas/user.dart';
import 'package:uni_match/app/models/app_model.dart';
import 'package:uni_match/app/models/user_model.dart';
import 'package:uni_match/app/modules/profile/view/profile_screen.dart';
import 'package:uni_match/constants/constants.dart';
import 'package:uni_match/dialogs/common_dialogs.dart';
import 'package:uni_match/dialogs/its_match_dialog.dart';
import 'package:uni_match/dialogs/vip_dialog.dart';
import 'package:uni_match/plugins/swipe_stack/swipe_stack.dart';
import 'package:uni_match/widgets/cicle_button.dart';
import 'package:uni_match/widgets/no_data.dart';
import 'package:uni_match/widgets/processing.dart';
import 'package:uni_match/widgets/profile_card.dart';

// ignore: must_be_immutable
class DiscoverTab extends StatefulWidget {
  @override
  _DiscoverTabState createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  // Variables
  final GlobalKey<SwipeStackState> _swipeKey = GlobalKey<SwipeStackState>();
  final LikesApi _likesApi = LikesApi();
  final DislikesApi _dislikesApi = DislikesApi();
  final MatchesApi _matchesApi = MatchesApi();
  final VisitsApi _visitsApi = VisitsApi();
  final UsersApi _usersApi = UsersApi();
  List<DocumentSnapshot>? _users;
  AppController _i18n = Modular.get();
  int swipeNum = 10;
  int superLike = 0;
  Duration? swipeTime;
  late DateTime dateTime;

  /// Get all Users
  Future<void> _loadUsers(List<DocumentSnapshot> dislikedUsers) async {
    dateTime = await NTP.now();

    _usersApi.getUsers(dislikedUsers: dislikedUsers).then((users) {
      // Check result
      if (users.isNotEmpty) {
        if (mounted) {
          setState(() => _users = users);
        }
      } else {
        if (mounted) {
          setState(() => _users = []);
        }
      }
      _limiteSwipes(dateTime);
      _limiteSuperLike(dateTime);
      _recuperarDislike(dislikedUsers);
      // Debug
      print('DateTime now  -> $dateTime');
      print('DateTime user -> ${UserModel().user.userSettings![USER_TIME_SWIPES].toDate()}');
      print('Diferença     -> ${dateTime.difference(UserModel().user.userSettings![USER_TIME_SWIPES].toDate()).inHours}h');

      print('Usuários -> ${users.length}');
      print('Usuários Disliked -> ${dislikedUsers.length}');
    });
  }

  _limiteSuperLike(DateTime dateTime) async {
    print('SuperLike Firebase:  ${UserModel().user.userSettings![USER_SUPERLIKE]}');

    if(UserModel().user.userSettings![USER_SUPERLIKE] <= 0){
      if (dateTime.difference(UserModel().user.userSettings![USER_TIME_SUPERLIKE].toDate()).inHours >= 24){
        debugPrint("Tempo superior à 24 horas");

        if (UserModel().userIsVip) {
          debugPrint("Usuário VIP");

          await UserModel()
              .updateUserData(userId: UserModel().user.userId, data: {
            '$USER_SETTINGS.$USER_SUPERLIKE': 4
          });
          setState(() => superLike = 4);

        }else{

          debugPrint("Usuário Normal");

          await UserModel()
              .updateUserData(userId: UserModel().user.userId, data: {
            '$USER_SETTINGS.$USER_SUPERLIKE': 2
          });
          setState(() => superLike = 2);
        }
      }
    }else{
      setState(() => superLike = UserModel().user.userSettings![USER_SUPERLIKE]);
    }
  }

  _limiteSwipes(DateTime dateTime) async {
    if (UserModel().userIsVip) {
      setState(() => swipeNum = AppModel().appInfo.vipAccountSwipes);
    } else {
      if (dateTime.difference(UserModel().user.userSettings![USER_TIME_SWIPES].toDate()).inHours >= 24){
        debugPrint("Tempo superior à 24 horas");

        await UserModel()
            .updateUserData(userId: UserModel().user.userId, data: {
          '$USER_SETTINGS.$USER_SWIPES': AppModel().appInfo.freeAccountSwipes
        });

        setState(() => swipeNum = AppModel().appInfo.freeAccountSwipes);
      } else {

        setState(() {
          swipeTime = Duration(hours: 24) - dateTime.difference(
              UserModel().user.userSettings![USER_TIME_SWIPES].toDate());

          swipeNum  = UserModel().user.userSettings![USER_SWIPES] == null
              ? 10
              : UserModel().user.userSettings![USER_SWIPES];
        });
      }
    }

    print('Swipes        -> $swipeNum');
  }

  _recuperarDislike(List<DocumentSnapshot> dislikedUsers) async {
    DateTime dateTime = await NTP.now();
    debugPrint("Recuperar Dislike => Tempo GTM: $dateTime");

    if (dateTime.difference(UserModel().user.userLastLogin).inDays >= 7) {
      debugPrint("Tempo superior à 6 dias");

      await UserModel().updateUserData(
          userId: UserModel().user.userId, data: {USER_LAST_LOGIN: dateTime});

      debugPrint("Login atual: ${UserModel().user.userLastLogin}");

      if (dislikedUsers.isNotEmpty) {
        Map dadosUser =
            dislikedUsers[Random().nextInt(dislikedUsers.length)].data() as Map;

        if (dislikedUsers.length > 2) {
          debugPrint("Dislike deletado -> ${dadosUser[DISLIKED_USER_ID]}");

          _dislikesApi.deleteDislikedUser(dadosUser[DISLIKED_USER_ID]);
          dadosUser = dislikedUsers[Random().nextInt(dislikedUsers.length)]
              .data() as Map;
          if (dateTime.difference(dadosUser[TIMESTAMP].toDate()).inDays >= 6) {
            debugPrint("2: Dislike deletado -> ${dadosUser[DISLIKED_USER_ID]}");
            _dislikesApi.deleteDislikedUser(dadosUser[DISLIKED_USER_ID]);
          }
        } else {
          _dislikesApi.deleteDislikedUser(dadosUser[DISLIKED_USER_ID]);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    /// First: Load All Disliked Users to be filtered
    _dislikesApi
        .getDislikedUsers(withLimit: false)
        .then((List<DocumentSnapshot> dislikedUsers) async {
      /// Validate user max distance
      await UserModel().checkUserMaxDistance();

      /// Load all users
      await _loadUsers(dislikedUsers);
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Initialization
    return _showUsers();
  }

  Widget _showUsers() {
    /// Check result
    if (_users == null) {
      return Processing(text: _i18n.translate("loading"));
    } else if (_users!.isEmpty) {
      /// No user found
      return NoData(
          animated: true,
          svgName: 'search_icon',
          text: _i18n.translate("no_user_found_around_you_please_try_again_later")!);
    } else {
      return FadeIn(
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// User card list
            SwipeStack(
              key: _swipeKey,
              children: _users!.map((userDoc) {
                final Usuario user = Usuario.fromDocument(userDoc.data()! as Map);
                return SwiperItem(
                    builder: (SwiperPosition position, double progress) {
                  /// Return User Card
                  return ProfileCard(
                      page: 'discover', position: position, user: user);
                });
              }).toList(),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              translationInterval: 6,
              scaleInterval: 0.03,
              stackFrom: StackFrom.None,
              onEnd: () => debugPrint("onEnd"),
              onSwipe: (int index, SwiperPosition position) async {

                swipeNum--;
                debugPrint("SwipeNum: $swipeNum");

                await UserModel()
                    .updateUserData(userId: UserModel().user.userId, data: {
                  '$USER_SETTINGS.$USER_SWIPES': swipeNum,
                  '$USER_SETTINGS.$USER_TIME_SWIPES': dateTime});

                /// Control swipe position
                switch (position) {
                  case SwiperPosition.None:
                    break;
                  case SwiperPosition.Left:

                  /// Swipe Left Dislike profile
                    _dislikesApi.dislikeUser(
                        dislikedUserId: _users![index][USER_ID],
                        onDislikeResult: (r) =>
                            debugPrint('onDislikeResult: $r'));

                    if(swipeNum == 0)setState(() {
                      swipeTime = Duration(hours: 24) - dateTime.difference(
                          UserModel().user.userSettings![USER_TIME_SWIPES].toDate());});

                    break;

                  case SwiperPosition.Right:

                  /// Swipe right and Like profile
                    _likeUser(context, clickedUserDoc: _users![index]);
                    if(swipeNum == 0)setState(() {
                      swipeTime = Duration(hours: 24) - dateTime.difference(
                          UserModel().user.userSettings![USER_TIME_SWIPES].toDate());});

                    break;
                  case SwiperPosition.SuperRight:

                    superLike--;
                    debugPrint("Super Like: $superLike");

                    await UserModel()
                        .updateUserData(userId: UserModel().user.userId, data: {
                      '$USER_SETTINGS.$USER_SUPERLIKE': superLike,
                      '$USER_SETTINGS.$USER_TIME_SUPERLIKE': dateTime});

                  /// Super Swipe right and Like profile
                    _likeUser(context, clickedUserDoc: _users![index], superLike: true);
                    if(swipeNum == 0)setState(() {
                      swipeTime = Duration(hours: 24) - dateTime.difference(
                          UserModel().user.userSettings![USER_TIME_SWIPES].toDate());});

                    break;
                }
              }
            ),

          if(swipeNum == 0)
            Align(
              alignment: Alignment.center,
              child: InkWell(
                  child: Container(
                    color: Colors.white.withOpacity(.25),
                    child: Dialog(
                      insetAnimationCurve: Curves.bounceInOut,
                      insetAnimationDuration: Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.white,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        height: MediaQuery.of(context).size.height * .55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Icon(
                              Icons.lock_outline,
                              size: 80,
                              color: Colors.pinkAccent,
                            ),
                            Text(
                              "Você já usou o número máximo de Swipes gratuitos disponíveis por 24 horas.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                  fontSize: 20),
                            ),

                            Column(
                              children: [
                                Text(
                                  "RESTA APENAS",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500],
                                      fontSize: 14),
                                ),
                                SizedBox(height: 2,),
                                CustomTimer(
                                  from: swipeTime!,
                                  to: Duration(hours: 0),
                                  onBuildAction: CustomTimerAction.auto_start,
                                  builder: (CustomTimerRemainingTime remaining) {
                                    return Text(
                                      "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                      style: TextStyle(fontSize: 30.0, color: Colors.grey[500]),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Text(
                              "Para descolar mais universitários, basta assinar nossos planos UniVips.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(context: context,
                        builder: (context) => VipDialog());
                  }),
            ),
            /// Swipe buttons
            if(swipeNum != 0)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: swipeButtons(context),
                )
            )
          ],
        ),
      );
    }
  }

  /// Build swipe buttons
  Widget swipeButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Rewind profiles
        ///
        /// Go to Disliked Profiles
        cicleButton(
            bgColor: Colors.white,
            padding: 8,
            icon: Icon(Icons.restore, size: 22, color: Colors.grey[600]),
            onTap: () {
              // Go to Disliked Profiles Screen
              Modular.to.pushNamed('/profile/dislikes');
            }),

        SizedBox(width: 20),

        /// Swipe left and reject user
        cicleButton(
            bgColor: Colors.white,
            padding: 8,
            icon: Icon(Icons.close, size: 35, color: Colors.deepPurpleAccent),
            onTap: () {
              /// Get card current index
              final cardIndex = _swipeKey.currentState!.currentIndex;

              /// Check card valid index
              if (cardIndex != -1) {
                /// Swipe left
                _swipeKey.currentState!.swipeLeft();
              }
            }),
        SizedBox(width: 15),

        cicleButton(
            bgColor: Colors.white,
            padding: 8,
            icon: Icon(Icons.star, size: 25, color: Colors.deepOrange),
            onTap: () {
              print("AQUI $superLike");

              if(superLike > 0){
                /// Get card current index
                final cardIndex = _swipeKey.currentState!.currentIndex;

                /// Check card valid index
                if (cardIndex != -1) {
                  /// Swipe right
                  _swipeKey.currentState!.superSwipeRight();
                }
              }
              else{
                print("Compre superlike");
                infoDialog(
                    context,
                    positiveAction: (){
                      Navigator.of(context).pop();
                    },
                    message: "Seus SuperLikes acabaram 😭.\n\nAumente seu limite diário sendo UniVip!");
              }
            }),
        SizedBox(width: 15),

        /// Swipe right and like user
        cicleButton(
            bgColor: Colors.white,
            padding: 8,
            icon: Icon(Icons.favorite_border,
                size: 35, color: Theme.of(context).primaryColor),
            onTap: () async {
              /// Get card current index
              final cardIndex = _swipeKey.currentState!.currentIndex;

              /// Check card valid index
              if (cardIndex != -1) {
                /// Swipe right
                _swipeKey.currentState!.swipeRight();
              }
            }),

        SizedBox(width: 20),

        /// Go to user profile
        cicleButton(
            bgColor: Colors.white,
            padding: 8,
            icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.grey[600]),
            onTap: () {
              /// Get card current index
              final cardIndex = _swipeKey.currentState!.currentIndex;

              /// Check card valid index
              if (cardIndex != -1) {
                /// Get User object
                final Usuario user =
                    Usuario.fromDocument(_users![cardIndex].data()! as Map);

                /// Go to profile screen
                // Modular.to.pushNamed('/profile');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(user: user, showButtons: false)));

                /// Increment user visits an push notification
                print("_visitsApi() => Enviar Visita");
                _visitsApi.visitUserProfile(
                  visitedUserId: user.userId,
                  userDeviceToken: user.userDeviceToken,
                  nMessage: "${_i18n.translate("visited_your_profile_click_and_see")}",
                );
              }
            }),
      ],
    );
  }

  /// Like user function
  Future<void> _likeUser(BuildContext context,
      {required DocumentSnapshot clickedUserDoc, bool superLike = false}) async {
    /// Check match first
    await _matchesApi.checkMatch(
        userId: clickedUserDoc[USER_ID],
        onMatchResult: (result)async{
          if (result) {
            /// It`s match - show dialog to ask user to chat or continue playing
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return ItsMatchDialog(
                    swipeKey: _swipeKey,
                    matchedUser:
                        Usuario.fromDocument(clickedUserDoc.data()! as Map),
                  );
                });

            /// like profile
            await _likesApi.likeUser(
                likedUserId: clickedUserDoc[USER_ID],
                userDeviceToken: clickedUserDoc[USER_DEVICE_TOKEN],
                nMessage: "${_i18n.translate("match_your_profile_click_and_see")}",
                onLikeResult: (result) {
                  print('likeResult: $result');
                });
          }
          else{
            /// like profile
            await _likesApi.likeUser(
                superLiked: superLike,
                likedUserId: clickedUserDoc[USER_ID],
                userDeviceToken: clickedUserDoc[USER_DEVICE_TOKEN],
                nMessage: "${superLike
                    ? _i18n.translate("super_liked_your_profile_click_and_see")
                    : _i18n.translate("liked_your_profile_click_and_see")}",
                onLikeResult: (result) {
                  print('likeResult: $result');
                });
          }
        });
  }
}
