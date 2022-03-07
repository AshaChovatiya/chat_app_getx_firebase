import 'package:chat_app_getx_firebase/ui/ChatRoomsScreen/chat_rooms_screen.dart';
import 'package:chat_app_getx_firebase/ui/SignInScreen/sign_in_screen.dart';
import 'package:chat_app_getx_firebase/utils/PreferenceUtils.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    PreferenceUtils.init();
    Future.delayed(const Duration(seconds: 3), () {
      if (PreferenceUtils.getString(keyUserId) != "") {
        Get.offAll(const ChatRoomsScreen());
      } else {
        Get.offAll(const SignInScreen());
      }
    });
  }
}
