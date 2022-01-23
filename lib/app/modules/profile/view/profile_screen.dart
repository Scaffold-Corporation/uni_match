import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uni_match/app/api/dislikes_api.dart';
import 'package:uni_match/app/api/likes_api.dart';
import 'package:uni_match/app/api/matches_api.dart';
import 'package:uni_match/app/app_controller.dart';
import 'package:uni_match/app/datas/user.dart';
import 'package:uni_match/app/models/user_model.dart';
import 'package:uni_match/dialogs/flag_user_dialog.dart';
import 'package:uni_match/dialogs/its_match_dialog.dart';
import 'package:uni_match/helpers/app_ad_helper.dart';
import 'package:uni_match/helpers/app_helper.dart';
import 'package:uni_match/plugins/carousel_pro/carousel_pro.dart';
import 'package:uni_match/widgets/badge.dart';
import 'package:uni_match/widgets/cicle_button.dart';
import 'package:uni_match/widgets/show_scaffold_msg.dart';
import 'package:uni_match/widgets/svg_icon.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  /// Params
  final Usuario user;
  final bool myUser;
  final bool showButtons;
  final bool hideDislikeButton;
  final bool fromDislikesScreen;

  // Constructor
  ProfileScreen(
      {required this.user,
        this.showButtons = true,
        this.myUser = false,
        this.hideDislikeButton = false,
        this.fromDislikesScreen = false
      });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// Local variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppHelper _appHelper = AppHelper();
  final LikesApi _likesApi = LikesApi();
  final DislikesApi _dislikesApi = DislikesApi();
  final MatchesApi _matchesApi = MatchesApi();
  AppController _i18n = Modular.get();

  @override
  void initState() {
    super.initState();
    AppAdHelper.showInterstitialAd();
  }

  @override
  void dispose() {
    AppAdHelper.disposeInterstitialAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Initialization
    //
    // Get User Birthday
    final DateTime userBirthday = DateTime(
        widget.user.userBirthYear,
        widget.user.userBirthMonth,
        widget.user.userBirthDay);
    // Get User Current Age
    final int userAge = UserModel().calculateUserAge(userBirthday);

    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  /// Carousel Profile images
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Carousel(
                        autoplay: false,
                        dotBgColor: Colors.transparent,
                        dotIncreasedColor: Theme.of(context).primaryColor,
                        images: UserModel()
                            .getUserProfileImages(widget.user)
                            .map((url) => NetworkImage(url))
                            .toList()),
                  ),
                  Container(
                    height: widget.user.userBadges.isNotEmpty ? 50 : 0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.deepPurpleAccent,
                          Colors.purpleAccent,
                          Color(0XFFFB40BD),
                          Colors.pinkAccent,
                        ],
                      ),
                    ),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:widget.user.userBadges.length,
                        itemBuilder: (_, index) {
                          return widget.user.userBadges.isNotEmpty?
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              child: Image.network(
                                  widget.user.userBadges[index]["emblema"],
                                  width: 35,
                                  height: 35
                              ),
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    content: Container(
                                      height: 230,
                                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.deepPurpleAccent,
                                            Colors.purpleAccent,
                                            Color(0XFFFB40BD),
                                            Colors.pinkAccent,
                                          ],
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white.withOpacity(0.8),
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                Modular.to.pop();
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              title: Padding(
                                                padding: const EdgeInsets.only(right: 4.0),
                                                child: Text(
                                                  widget.user.userBadges[index]["titulo"],
                                                  softWrap: true,
                                                  style: GoogleFonts.fredokaOne(
                                                      fontSize: 28,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              leading: Image.network(
                                                widget.user.userBadges[index]["emblema"],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),

                                              trailing: Image.network(
                                                widget.user.userBadges[index]["emblema"],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.0,),

                                          Expanded(
                                            flex: 2,
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  widget.user.userBadges[index]["desc"],
                                                  textAlign: TextAlign.justify,
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ),
                                          ),

                                          SizedBox(width: 2.0,),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                              : Container(width: 0, height: 0);
                        }
                    ),
                  ),

                  /// Profile details
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Full Name
                            Expanded(
                              child: Text(
                                '${widget.user.userFullname}, '
                                    '${userAge.toString()}',
                                style: GoogleFonts.nunito(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),

                            /// Show verified badge
                            widget.user.userIsVerified
                                ? Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Image.asset(
                                    'assets/images/verified_badge.png',
                                    width: 30,
                                    height: 30))
                                : Container(width: 0, height: 0),

                            /// Show VIP badge for current user
                            UserModel().user.userId == widget.user.userId &&
                                UserModel().userIsVip
                                ? Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Image.asset(
                                    'assets/images/crow_badge.png',
                                    width: 25,
                                    height: 25))
                                : Container(width: 0, height: 0),

                            /// Location distance
                            Badge(
                                icon: SvgIcon(
                                    "assets/icons/location_point_icon.svg",
                                    color: Colors.white,
                                    width: 15,
                                    height: 15),
                                text:
                                '${_appHelper.getDistanceBetweenUsers(userLat: widget.user.userGeoPoint.latitude, userLong: widget.user.userGeoPoint.longitude)}km')
                          ],
                        ),

                        SizedBox(height: 5),

                        /// Home location
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                          leading: SvgIcon(
                              "assets/icons/location_point_icon.svg",
                              color: Theme.of(context).primaryColor,
                              width: 25,
                              height: 25),
                          title: Text("${widget.user.userLocality}, ${widget.user.userCountry}", style: TextStyle(fontSize: 19)),
                        ),

                        /// Orientation
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                          leading: SvgIcon("assets/icons/gender_icon.svg",
                              color: Theme.of(context).primaryColor,
                              width: 27,
                              height: 27),
                          title: Text("${widget.user.userOrientation}", style: TextStyle(fontSize: 19)),
                        ),

                        /// Education
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                          leading: SvgIcon("assets/icons/university_icon.svg",
                              color: Theme.of(context).primaryColor,
                              width: 32,
                              height: 32),
                          title: Text("${widget.user.userSchool}", style: TextStyle(fontSize: 19)),
                        ),

                        /// Birthday
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                          leading: SvgIcon("assets/icons/gift_icon.svg",
                              color: Theme.of(context).primaryColor,
                              width: 28,
                              height: 28),
                          title: Text('${_i18n.translate('birthday')} '
                              '${widget.user.userBirthDay < 10 ? '0' + widget.user.userBirthDay.toString() :  widget.user.userBirthDay}/'
                              '${widget.user.userBirthMonth < 10 ? '0' + widget.user.userBirthMonth.toString() : widget.user.userBirthMonth}/'
                              '${widget.user.userBirthYear}', style: TextStyle(fontSize: 19)),
                        ),

                        /// Join date
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                          leading: SvgIcon("assets/icons/info_icon.svg",
                              color: Theme.of(context).primaryColor,
                              width: 28,
                              height: 28),
                          title: Text("${_i18n.translate('join_date')}: ${timeago.format(widget.user.userRegDate, locale: 'pt_BR')}",
                              style: TextStyle(fontSize: 19)),
                        ),
                        Divider(),

                        if(widget.user.userInterests.isNotEmpty)
                        Container(
                          height: 60,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: companyPosition.toList(),
                            ),
                          ),
                        ),

                        Divider(),

                        /// Profile bio
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_i18n.translate("bio")!,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Theme.of(context).primaryColor)),
                        ),
                        Text(widget.user.userBio,
                            style:
                            TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// AppBar to return back
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme:
                IconThemeData(color: Theme.of(context).primaryColor),
                actions: <Widget>[
                  if(widget.myUser != true)
                  IconButton(
                    icon: Icon(Icons.flag,
                        color: Theme.of(context).primaryColor, size: 30),
                    onPressed: () {
                      /// Flag user profile
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return FlagUserDialog(
                                flaggedUserId: widget.user.userId);
                          });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar:
        widget.showButtons ? _buildButtons(context) : null);
  }

  /// Build Like and Dislike buttons
  Widget _buildButtons(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /// Dislike profile button
            if (!widget.hideDislikeButton)
              cicleButton(
                  padding: 8.0,
                  icon:
                  Icon(Icons.close, color: Theme.of(context).primaryColor),
                  bgColor: Colors.grey,
                  onTap: () {
                    // Dislike profile
                    _dislikesApi.dislikeUser(
                        dislikedUserId: widget.user.userId,
                        onDislikeResult: (result) {
                          /// Check result to show message
                          if (!result) {
                            // Show error message
                            showScaffoldMessage(
                                context: context,
                                message: _i18n.translate(
                                    "you_already_disliked_this_profile")!);
                          }
                        });
                  }),

            /// Like profile button
            cicleButton(
                padding: 8.0,
                icon: Icon(Icons.favorite_border, color: Colors.white),
                bgColor: Theme.of(context).primaryColor,
                onTap: () {
                  // Like user
                  _likeUser(context);
                }),
          ],
        ));
  }

  /// Like user function
  Future<void> _likeUser(BuildContext context) async {
    /// Check match first
    _matchesApi
        .checkMatch(
        userId: widget.user.userId,
        onMatchResult: (result) {
          if (result) {
            /// Show It`s match dialog
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return ItsMatchDialog(
                    matchedUser: widget.user,
                    showSwipeButton: false,
                    swipeKey: null,
                  );
                });
          }
        })
        .then((_) {
      /// Like user
      _likesApi.likeUser(
          likedUserId: widget.user.userId,
          userDeviceToken: widget.user.userDeviceToken,
          nMessage: "${UserModel().user.userFullname.split(' ')[0]}, "
              "${_i18n.translate("liked_your_profile_click_and_see")}",
          onLikeResult: (result) async {
            if (result) {
              // Show success message
              showScaffoldMessage(
                  context: context,
                  message:
                  '${_i18n.translate("like_sent_to")} ${widget.user.userFullname}');
            } else if (!result) {
              // Show error message
              showScaffoldMessage(
                  context: context,
                  message: _i18n.translate("you_already_liked_this_profile")!);
            }

            /// Validate to delete disliked user from disliked list
            else if (result && widget.fromDislikesScreen) {
              // Delete in database
              await _dislikesApi.deleteDislikedUser(widget.user.userId);
            }
          });
    });
  }

  Iterable<Widget> get companyPosition sync* {
    for (String company in widget.user.userInterests) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: Chip(
          elevation: 5.0,
          backgroundColor: Colors.pinkAccent.shade100,
          label: Text(
            company,
            style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      );
    }
  }
}