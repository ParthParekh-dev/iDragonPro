import 'dart:core';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idragon_pro/constants.dart';
import 'package:idragon_pro/models/addToWatchlistRespose.dart';
import 'package:idragon_pro/models/editProfileResponse.dart';
import 'package:idragon_pro/models/googleLoginResponse.dart';
import 'package:idragon_pro/models/hashResponse.dart';
import 'package:idragon_pro/models/homePageResponse.dart';
import 'package:idragon_pro/models/mobileLoginResponse.dart';
import 'package:idragon_pro/models/promoResponse.dart';
import 'package:idragon_pro/models/searchResponse.dart';
import 'package:idragon_pro/models/userDetailsReponse.dart';
import 'package:idragon_pro/models/videoDetailResponse.dart';
import 'package:idragon_pro/models/watchListResponse.dart';
import 'package:device_info_plus/device_info_plus.dart';

class NetworkService {
  Future<UserDetailsResponse?> fetchUserDetails() async {
    var deviceInfo = DeviceInfoPlugin();
    late var model;

    if (Platform.isIOS) {
      try {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        model = iosInfo.utsname.machine;
      } catch (exp) {
        model = "iphone";
      }
    } else {
      try {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        model = androidInfo.model;
      } catch (exp) {
        model = "android";
      }
    }

    http.Response response = await http.post(
      Uri.encodeFull(
          'https://idragonpro.com/idragon/api/v.08.2021/userinfobyid_new?id=${GetStorage().read(Constant().USER_ID)}&deviceId=${model.toString().replaceAll(' ', '')}&firebaseId=${GetStorage().read(Constant().FIREBASE_ID)}&versionCode=32'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return userDetailsResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }

  Future<HomePageResponse?> fetchHomePage() async {
    http.Response response = await http.get(
      Uri.parse(
          'https://idragonpro.com/idragon/api/v.08.2021/get_home_banners?versionCode=32'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return homePageResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }

  Future<HomePageResponse?> fetchWebSeries() async {
    http.Response response = await http.get(
      Uri.parse(
          'https://idragonpro.com/idragon/api/v.08.2021/get_series_banners?versionCode=33'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return homePageResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }

  Future<PromoResponse?> fetchPromoVideo() async {
    http.Response response = await http.get(
      Uri.parse('https://idragonpro.com/idragon/api/v.08.2021/promoflash'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.statusCode);

    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonString = response.body;
      print('Promo ============' + jsonString);
      return promoResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }

  Future<VideoDetailResponse?> fetchVideoDetails(String id) async {
    http.Response response = await http.post(
      Uri.parse(
          'https://idragonpro.com/idragon/api/v.08.2021/getvideobyid_new?id=$id&userid=${GetStorage().read(Constant().USER_ID)}&versionCode=32'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return videoDetailResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }

  Future<SearchResponse?> fetchSearchResponse(String text) async {
    http.Response response = await http.post(
      Uri.parse(
          'https://idragonpro.com/idragon/api/v.08.2021/getsearchitems?search=$text'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonString = response.body;

      return searchResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }

  Future<AddtoWatchlistResponse?> addtoWatchList(
      String userId, String videoId) async {
    print('Tapped 1');
    http.Response response = await http.post(
      Uri.parse(
          'https://idragonpro.com/idragon/api/v.08.2021/wishlistcreate?iUserId=$userId&iVideoId=$videoId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Tapped 2');

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonString = response.body;

      return addtoWatchlistResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }

  Future<MobileLoginResponse?> mobileLogin(
      String id, String mobile, String fname, String email) async {
    var name = fname.split(' ');

    if (name.length == 1) {
      name.add(' ');
    }

    http.Response response = await http.post(
      Uri.encodeFull(
          'https://idragonpro.com/idragon/api/v.08.2021/updatemobile?id=$id&mobileno=$mobile&role_id=2&name=${name[0]}&lastname=${name[1]}&email=$email&versionCode=33'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonString = response.body;

      return mobileLoginResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }

  Future<EditProfileResponse?> updateProfile(String fname, String lname) async {
    http.Response response = await http.post(
      Uri.encodeFull(
          'https://idragonpro.com/idragon/api/v.08.2021/userupdatebyid?role_id=2&name=$fname&lastname=$lname&id=${GetStorage().read(Constant().USER_ID)}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonString = response.body;

      return editProfileResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }

  Future<GoogleLoginResponse?> fetchGoogleLoginResponse(
      String fullName, String email, String profile) async {
    var name = fullName.split(' ');

    if (name.length == 1) {
      name.add(' ');
    }

    http.Response response = await http.post(
      Uri.encodeFull(
          'https://idragonpro.com/idragon/api/v.08.2021/register?role_id=2&name=${name[0]}&lastname=${name[1]}&email=$email&profile_pic=$profile&versionCode=32'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonString = response.body;

      print(jsonString);

      return googleLoginResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }

  Future<WatchlistResponse?> fetchWatchList(String id) async {
    http.Response response = await http.post(
      Uri.parse(
          'https://idragonpro.com/idragon/api/v.08.2021/getwishlist?iUserId=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return watchlistResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }

  Future<HashResponse?> generateHash() async {
    http.Response response = await http.post(
      Uri.parse(
          'https://idragonpro.com/idragon/api/v.08.2021/generate_userId_hash?iUserId=${GetStorage().read(Constant().USER_ID)}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return hashResponseFromJson(jsonString);
    } else {
      //show error
      return null;
    }
  }
}
