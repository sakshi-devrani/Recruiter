import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/language/languageDialogBox%5B1%5D.dart';
import 'package:jobfinder/welcome.dart';
import 'size_config.dart';
import 'onboarding_contents.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color.fromARGB(255, 85, 143, 151),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    // double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () {
                      Get.dialog(LanguageDialog());
                    },
                    child: Image.asset(
                      "assets/images/language.png",
                      color: Color.fromARGB(255, 85, 143, 151),
                      height: 60,
                    ),
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 300),
                  child: TextButton(
                    onPressed: () {
                      _controller.jumpToPage(4);
                    },
                    child: Text(
                      "SKIP".tr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 85, 143, 151),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      elevation: 0,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: (width <= 550) ? 13 : 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 5,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Image.asset(
                          contents[i].image,
                          // color: Colors.white,
                          height: SizeConfig.blockV! * 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            contents.length,
                            (int index) => _buildDots(
                              index: index,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 30),
                          child: Text(
                            contents[i].title.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 85, 143, 151),
                              fontSize: (width <= 550) ? 30 : 35,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 30,
                            right: 30,
                          ),
                          child: Text(
                            contents[i].subtitle.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(144, 7, 16, 18),
                                fontSize: 19),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage + 1 == contents.length
                      ? Padding(
                          padding: const EdgeInsets.all(30),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Welcome();
                                },
                              ));
                            },
                            child: Text(
                              "START".tr,
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 85, 143, 151),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: (width <= 550)
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 127, vertical: 16)
                                  : const EdgeInsets.symmetric(
                                      horizontal: 127, vertical: 16),
                              textStyle:
                                  TextStyle(fontSize: (width <= 550) ? 13 : 17),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                },
                                child: Text(
                                  "NEXT".tr,
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 85, 143, 151),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  elevation: 0,
                                  padding: (width <= 550)
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 130, vertical: 16)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 130, vertical: 16),
                                  textStyle: TextStyle(
                                      fontSize: (width <= 550) ? 13 : 17),
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
