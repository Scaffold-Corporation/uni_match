import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:place_picker/place_picker.dart';
import 'package:uni_match/app/app_controller.dart';
import 'package:uni_match/app/models/app_model.dart';
import 'package:uni_match/app/models/user_model.dart';
import 'package:uni_match/app/modules/profile/view/passaport/passport_screen.dart';
import 'package:uni_match/constants/constants.dart';
import 'package:uni_match/dialogs/common_dialogs.dart';
import 'package:uni_match/dialogs/show_me_dialog.dart';
import 'package:uni_match/dialogs/vip_dialog.dart';
import 'package:uni_match/widgets/show_scaffold_msg.dart';
import 'package:uni_match/widgets/svg_icon.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin{
  // Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late RangeValues _selectedAgeRange;
  late RangeLabels _selectedAgeRangeLabels;
  late double _selectedMaxDistance;
  String? showMe;
  bool _hideProfile = false;
  AppController _i18n = Modular.get();

  /// Initialize user settings
  void initUserSettings() {
    // Get user settings
    final Map<String, dynamic> _userSettings = UserModel().user.userSettings!;
    // Update variables state
    setState(() {
      // Get user max distance
      _selectedMaxDistance = _userSettings[USER_MAX_DISTANCE].toDouble();

      // Get age range
      final double minAge = _userSettings[USER_MIN_AGE].toDouble();
      final double maxAge = _userSettings[USER_MAX_AGE].toDouble();

      // Set range values
      _selectedAgeRange = new RangeValues(minAge, maxAge);
      _selectedAgeRangeLabels = new RangeLabels('$minAge', '$maxAge');

      // Check profile status
      if (UserModel().user.userStatus == 'hidden') {
        _hideProfile = true;
      }
    });
  }

  showMeOption() {
    AppController i18n = Modular.get();
    // Variables
    final Map<String, dynamic> settings = UserModel().user.userSettings!;
    showMe = settings[USER_SHOW_ME];
    print(showMe);
    // Check option
    if (showMe != null) {
      setState(() {
        showMe = i18n.translate(showMe!)!;
      });
    } else {
      setState(() {
        showMe = i18n.translate('opposite_gender')!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initUserSettings();
    showMeOption();
  }

  // Go to Passport screen
  Future<void> _goToPassportScreen() async {
    // Get picked location result
    LocationResult? result = await Navigator.of(context).push<LocationResult?>(
        MaterialPageRoute(builder: (context) => PassportScreen()));
    // Handle the retur result
    if (result != null) {
      // Update current your location
      _updateUserLocation(true, locationResult: result);
      // Debug info
      print(
          '_goToPassportScreen() -> result: ${result.country!.name}, ${result.city!.name}');
    } else {
      print('_goToPassportScreen() -> result: empty');
    }
  }

  // Update User Location
  Future<void> _updateUserLocation(bool isPassport,
      {LocationResult? locationResult}) async {
    /// Update user location: Country & City an Geo Data

    /// Update user data
    await UserModel().updateUserLocation(
        isPassport: isPassport,
        locationResult: locationResult,
        onSuccess: () {
          // Show success message
          showScaffoldMessage(
              context: context,
              message: _i18n.translate("location_updated_successfully")!);
        },
        onFail: () {
          // Show error message
          showScaffoldMessage(
              context: context,
              message:
                  _i18n.translate("we_were_unable_to_update_your_location")!);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_i18n.translate("settings")!),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              /// Passport feature
              /// Travel to any Country or City and Swipe Women there!
              Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  elevation: 2.0,
                  shadowColor: Theme.of(context).primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_i18n.translate("passport")!,
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      ListTile(
                        leading: Icon(Icons.flight,
                            color: Theme.of(context).primaryColor, size: 40),
                        title: Text(_i18n.translate(
                            "travel_to_any_country_or_city_and_match_with_people_there")!),
                        trailing: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          child: Text(_i18n.translate("travel_now")!,
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            // // Check User VIP Account Status
                            if (UserModel().userIsVip) {
                              // Go to passport screen
                              _goToPassportScreen();
                            } else {
                              /// Show VIP dialog
                              showDialog(
                                  context: context,
                                  builder: (context) => VipDialog());
                            }
                          },
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 20),

              /// User current location
              Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_i18n.translate("your_current_location")!,
                            style: TextStyle(fontSize: 18)),
                      ),
                      ListTile(
                        leading: SvgIcon("assets/icons/location_point_icon.svg",
                            color: Theme.of(context).primaryColor),
                        title: Text(
                            '${UserModel().user.userCountry}, ${UserModel().user.userLocality}'),
                        trailing: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          child: Text(_i18n.translate("UPDATE")!,
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            /// Update user location: Country & City an Geo Data
                            _updateUserLocation(false);
                          },
                        ),
                      ),
                    ],
                  )),

              SizedBox(height: 15),

              /// User Max distance
              Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                '${_i18n.translate("maximum_distance")} ${_selectedMaxDistance.round()} km',
                                style: TextStyle(fontSize: 18)),
                            SizedBox(height: 3),
                            Text(
                                _i18n.translate(
                                    "show_people_within_this_radius")!,
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Slider(
                        activeColor: Theme.of(context).primaryColor,
                        value: _selectedMaxDistance,
                        label: _selectedMaxDistance.round().toString() + ' km',
                        divisions: 100,
                        min: 0,

                        /// Check User VIP Account to set max distance available
                        max: UserModel().userIsVip
                            ? AppModel().appInfo.vipAccountMaxDistance
                            : AppModel().appInfo.freeAccountMaxDistance,
                        onChanged: (radius) {
                          setState(() {
                            _selectedMaxDistance = radius;
                          });
                          // debug
                          print('_selectedMaxDistance: '
                              '${radius.toStringAsFixed(2)}');
                        },
                        onChangeEnd: (radius) {
                          /// Update user max distance
                          UserModel().updateUserData(
                              userId: UserModel().user.userId,
                              data: {
                                '$USER_SETTINGS.$USER_MAX_DISTANCE':
                                    double.parse(radius.toStringAsFixed(2))
                              }).then((_) {
                            print(
                                'User max distance updated -> ${radius.toStringAsFixed(2)}');
                          });
                        },
                      ),
                      // Show message for non VIP user
                      UserModel().userIsVip
                          ? Container(width: 0, height: 0)
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${_i18n.translate("need_more_radius_away")} "
                                  "${AppModel().appInfo.vipAccountMaxDistance} km "
                                  "${_i18n.translate('radius_away')}",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                    ],
                  )),
              SizedBox(height: 15),

              // User age range
              Card(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(_i18n.translate("age_range")!,
                        style: TextStyle(fontSize: 19)),
                    subtitle: Text(
                        _i18n.translate("show_people_within_this_age_range")!),
                    trailing: Text(
                        "${_selectedAgeRange.start.toStringAsFixed(0)} - "
                        "${_selectedAgeRange.end.toStringAsFixed(0)}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  RangeSlider(
                      activeColor: Theme.of(context).primaryColor,
                      values: _selectedAgeRange,
                      labels: _selectedAgeRangeLabels,
                      divisions: 100,
                      min: 18,
                      max: 100,
                      onChanged: (newRange) {
                        // Update state
                        setState(() {
                          _selectedAgeRange = newRange;
                          _selectedAgeRangeLabels = RangeLabels(
                              newRange.start.toStringAsFixed(0),
                              newRange.end.toStringAsFixed(0));
                        });
                        print('_selectedAgeRange: $_selectedAgeRange');
                      },
                      onChangeEnd: (endValues) {
                        /// Update age range
                        ///
                        /// Get start value
                        final int minAge =
                            int.parse(endValues.start.toStringAsFixed(0));

                        /// Get end value
                        final int maxAge =
                            int.parse(endValues.end.toStringAsFixed(0));

                        // Update age range
                        UserModel().updateUserData(
                            userId: UserModel().user.userId,
                            data: {
                              '$USER_SETTINGS.$USER_MIN_AGE': minAge,
                              '$USER_SETTINGS.$USER_MAX_AGE': maxAge,
                            }).then((_) {
                          print('Age range updated');
                        });
                      })
                ],
              )),

              SizedBox(height: 15),
              // Show me option
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.wc_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                  title: Text(_i18n.translate('show_me')!,
                      style: TextStyle(fontSize: 18)),
                  trailing: Text(showMe!, style: TextStyle(fontSize: 18)),
                  onTap: () {
                    /// Choose Show me option
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return ShowMeDialog();
                        }).whenComplete(() {
                          Timer(Duration(milliseconds: 200), () {
                        showMeOption();
                      });
                    });
                  },
                ),
              ),
              SizedBox(height: 10),

              Observer(
                builder:(_) => Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.dark_mode_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      title: Text(_i18n.translate("button")!),
                      trailing: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          _i18n.alterarVirtualButton();
                          HapticFeedback.lightImpact();

                          if(_i18n.virtualButton == false)
                          successDialog(context,
                              message: _i18n.translate("virtual_button_successfully_activated")!,
                              positiveAction: () {Navigator.of(context).pop();});
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.fastLinearToSlowEaseIn,
                          height: _i18n.virtualButton ? 35 : 38,
                          width: _i18n.virtualButton ? 55 : 65,
                          decoration: BoxDecoration(
                            color: _i18n.virtualButton ? Color(0xffB23F3F) : Color(0xffFF4E4E),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(_i18n.isDark ? 0 : 0.3),
                                blurRadius: _i18n.virtualButton ? 0 : 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _i18n.virtualButton ? 'OFF' : 'ON',
                              style: TextStyle(
                                color: _i18n.virtualButton
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              ),
              SizedBox(height: 10),

              Observer(
                builder:(_) => Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.dark_mode_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      title: Text(_i18n.translate("dark")!),
                      trailing: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          _i18n.alterarTheme();
                          successDialog(context,
                              message: _i18n.translate("restart_the_application_for_the_changes_to_tak_effect")!,
                              positiveAction: () {
                                /// Close dialog
                                Navigator.of(context).pop();
                              });
                          HapticFeedback.lightImpact();
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.fastLinearToSlowEaseIn,
                          height: _i18n.isDark ? 35 : 38,
                          width: _i18n.isDark ? 55 : 65,
                          decoration: BoxDecoration(
                            color: _i18n.isDark ? Color(0xffB23F3F) : Color(0xffFF4E4E),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(_i18n.isDark ? 0 : 0.3),
                                blurRadius: _i18n.isDark ? 0 : 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _i18n.isDark ? 'OFF' : 'ON',
                              style: TextStyle(
                                color: _i18n.isDark
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              ),
              SizedBox(height: 10),

              /// Hide user profile setting
              Card(
                child: ListTile(
                  leading: _hideProfile
                      ? Icon(Icons.visibility_off,
                          color: Theme.of(context).primaryColor, size: 30)
                      : Icon(Icons.visibility,
                          color: Theme.of(context).primaryColor, size: 30),
                  title: Text(_i18n.translate('hide_profile')!,
                      style: TextStyle(fontSize: 18)),
                  subtitle: _hideProfile
                      ? Text(
                          _i18n.translate(
                              'your_profile_is_hidden_on_discover_tab')!,
                          style: TextStyle(color: Colors.red),
                        )
                      : Text(
                          _i18n.translate(
                              'your_profile_is_visible_on_discover_tab')!,
                          style: TextStyle(color: Colors.green)),
                  trailing: Switch(
                    value: _hideProfile,
                    onChanged: (newValue) {
                      // Update UI
                      setState(() {
                        _hideProfile = newValue;
                      });
                      // User status
                      String userStatus = 'active';
                      // Check status
                      if (newValue) {
                        userStatus = 'hidden';
                      }

                      // Update profile status
                      UserModel().updateUserData(
                          userId: UserModel().user.userId,
                          data: {USER_STATUS: userStatus}).then((_) {
                        print('Profile hidden: $newValue');
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
