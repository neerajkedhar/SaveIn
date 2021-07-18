import 'package:downn/main.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HowToDownload extends StatefulWidget {
  @override
  _HowToDownloadState createState() => _HowToDownloadState();
}

class _HowToDownloadState extends State<HowToDownload> {
  PageController controller = PageController();

  //int _curr = 0;
  Color blue = Color(0xff3742fa);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "How to Download",
          style: TextStyle(color: Colors.grey[800]),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[800],
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return MyApp();
            }));
          },
        ),
      ),
      body: Stack(alignment: Alignment.center, children: [
        Container(
          child: PageView(
              scrollDirection: Axis.horizontal,
              controller: controller,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        SizedBox(height: 10),

                        SizedBox(height: 20),
                        Center(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "ImageAssets/1.png",
                            width: 250,
                            height: 250,
                          ),
                        )),
                        SizedBox(height: 40),
                        Center(
                          child: Text("Open Instagram",
                              style: TextStyle(
                                  color: blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Tap on settings on top right corner of the your post and tap  \u0022Share to...\u0022",
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // SizedBox(height: 20),
                        // Center(
                        //     child: ClipRRect(
                        //   borderRadius: BorderRadius.circular(15),
                        //   child: Image.asset(
                        //     "ImageAssets/2.png",
                        //     width: 350,
                        //     height: 200,
                        //   ),
                        // )),
                        // SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        SizedBox(height: 20),
                        Center(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            "ImageAssets/2.png",
                            width: 300,
                            height: 300,
                          ),
                        )),
                        Center(
                          child: Text("Share Post",
                              style: TextStyle(
                                  color: blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Share your post to SaveIn to Download",
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        //Center(child: Image.asset("ImageAssets/4.png")),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        SizedBox(height: 20),
                        Center(
                            child: Image.asset(
                          "ImageAssets/3.png",
                          width: 300,
                          height: 300,
                        )),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Text("Or... Copy Link",
                              style: TextStyle(
                                  color: blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Tap on Copy \u0022Link button\u0022",
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        SizedBox(height: 10),
                        Center(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "ImageAssets/4.png",
                            width: 350,
                            height: 350,
                          ),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text("Paste Link",
                              style: TextStyle(
                                  color: blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Paste your post link and hit Download button",
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ListView(
                //       children: [
                //         SizedBox(height: 10),
                //         Center(
                //             child: ClipRRect(
                //           borderRadius: BorderRadius.circular(20),
                //           child: Image.asset(
                //             "ImageAssets/5.png",
                //             width: 350,
                //             height: 350,
                //           ),
                //         )),
                //         SizedBox(
                //           height: 10,
                //         ),
                //         Center(
                //           child: Text("To Download Profile Picture",
                //               style: TextStyle(
                //                   color: blue,
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.bold)),
                //         ),
                //         SizedBox(height: 10),
                //         Center(
                //           child: Text(
                //             "Tap on \u0022Download Instagram User Profile Picture\u0022 button",
                //             style: TextStyle(
                //                 color: Colors.grey[800], fontSize: 20),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ListView(
                //       children: [
                //         SizedBox(height: 10),
                //         Center(
                //             child: ClipRRect(
                //           borderRadius: BorderRadius.circular(20),
                //           child: Image.asset(
                //             "ImageAssets/6.png",
                //             width: 350,
                //             height: 350,
                //           ),
                //         )),
                //         SizedBox(
                //           height: 10,
                //         ),
                //         Center(
                //           child: Text("Instagram User ID",
                //               style: TextStyle(
                //                   color: blue,
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.bold)),
                //         ),
                //         SizedBox(height: 10),
                //         Center(
                //           child: Text(
                //             "Type in instagram user ID and tap on download button",
                //             style: TextStyle(
                //                 color: Colors.grey[800], fontSize: 20),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ListView(
                //       children: [
                //         SizedBox(height: 10),
                //         Center(
                //             child: ClipRRect(
                //           borderRadius: BorderRadius.circular(20),
                //           child: Image.asset(
                //             "ImageAssets/7.png",
                //             width: 400,
                //             height: 400,
                //           ),
                //         )),
                //         SizedBox(
                //           height: 10,
                //         ),
                //         Center(
                //           child: Text("Or... Copy Link",
                //               style: TextStyle(
                //                   color: blue,
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.bold)),
                //         ),
                //         SizedBox(height: 10),
                //         Center(
                //           child: Text(
                //             "Open Instagram User Profile and Copy Profile Url",
                //             style: TextStyle(
                //                 color: Colors.grey[800], fontSize: 20),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ListView(
                //       children: [
                //         SizedBox(height: 10),
                //         Center(
                //             child: ClipRRect(
                //           borderRadius: BorderRadius.circular(20),
                //           child: Image.asset(
                //             "ImageAssets/8.png",
                //             width: 350,
                //             height: 350,
                //           ),
                //         )),
                //         SizedBox(
                //           height: 10,
                //         ),
                //         Center(
                //           child: Text("Paste Link",
                //               style: TextStyle(
                //                   color: blue,
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.bold)),
                //         ),
                //         SizedBox(height: 10),
                //         Center(
                //           child: Text(
                //             "Paste User's profile link and hit Download button",
                //             style: TextStyle(
                //                 color: Colors.grey[800], fontSize: 20),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ]),
        ),
        Positioned(
          bottom: 30,
          child: Center(
            child: SmoothPageIndicator(
                controller: controller, // PageController
                count: 4,
                effect: ExpandingDotsEffect(
                    activeDotColor: blue), // your preferred effect
                onDotClicked: (index) {}),
          ),
        ),
      ]),
    );
  }
}
