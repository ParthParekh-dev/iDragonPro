// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:idragon_pro/screens/languageScreen.dart';
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           child: Center(
//             child: Container(
//               child: Column(
//                 children: [
//                   Text(
//                     'hello'.tr,
//                     style: TextStyle(fontSize: 15),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'message'.tr,
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'subscribe'.tr,
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   ElevatedButton(
//                       onPressed: () {
//                         Get.to(() => LanguageScreen());
//                       },
//                       child: Text('Change')),
//                   Text('Chat Screen'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Chat'),
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: 'https://idragonpro.com/chatwindow.php#max-widget',
              javascriptMode: JavascriptMode.unrestricted,
              gestureNavigationEnabled: true,
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                setState(() {
                  isLoading = false;
                });
              },
              onProgress: (int progress) {
                setState(() {
                  if (progress < 90) isLoading = true;
                });
                print("WebView is loading (progress : $progress%)");
              },
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(),
          ],
        ),
      ),
    );
  }
}
