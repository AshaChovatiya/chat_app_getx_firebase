import 'package:chat_app_getx_firebase/services/database.dart';
import 'package:chat_app_getx_firebase/ui/ChatScreen/chat_screen.dart';
import 'package:chat_app_getx_firebase/utils/PreferenceUtils.dart';
import 'package:chat_app_getx_firebase/utils/app_utils.dart';
import 'package:chat_app_getx_firebase/utils/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  DatabaseMethods databaseMethods = DatabaseMethods();

  TextEditingController searchTextController = TextEditingController();

  var UserList = [];

  List<DocumentSnapshot> userDocumentSnapshot = [];

  initiateSearch() async {
    if (searchTextController.text.isNotEmpty) {
      Get.focusScope?.unfocus();
      showLoader(Get.context);
      await databaseMethods
          .getAllUserInfo(searchTextController.text)
          .then((snapshot) async {
        Get.back();
        QuerySnapshot userInfoSnapshot =
            await DatabaseMethods().getAllUserInfo(searchTextController.text);
        userDocumentSnapshot.clear();
        userDocumentSnapshot.addAll(userInfoSnapshot.docs);
        if (userDocumentSnapshot.isEmpty) {
          showToast("No Data Found");
        }
        if (kDebugMode) {
          print("User Document ${userDocumentSnapshot.length}");
        }
        update();
      });
    }
  }

  createChatRoom(var userData) async {
    List<String> userIds = [
      PreferenceUtils.getString(keyUserId),
      userData["UserId"]
    ];
    List<String> users = [
      PreferenceUtils.getString(keyUserName),
      userData["userName"]
    ];

    String chatRoomId =
        "${PreferenceUtils.getString(keyUserId)}_${userData["UserId"]}";

    Map<String, dynamic> chatRoom = {
      "sendBy": {
        "userId": PreferenceUtils.getString(keyUserId),
        "userName": PreferenceUtils.getString(keyUserName),
      },
      "receiveBy": {
        "userId": userData["UserId"],
        "userName": userData["userName"],
      },
      "userIds": userIds,
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    await PreferenceUtils.setString(keyChatRoomId, chatRoomId);

    Get.to(ChatScreen(
      chatRoomId: chatRoomId,
      userName: userData["userName"],
    ));
  }
}
