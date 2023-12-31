import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  final bool accessSettings = false;
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '부가 기능들',
            style: TextStyle(
              fontFamily: 'Gangwonstate',
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 50,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      elevation: MaterialStatePropertyAll(0.0)),
                  onPressed: () {},
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: 330,
                    height: 120,
                    decoration: BoxDecoration(
                      color: widget.accessSettings
                          ? Colors.black
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '설정',
                            style: TextStyle(
                              fontFamily: 'Gangwonstate',
                              fontSize: 40,
                              color: widget.accessSettings
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                          Transform.scale(
                            scale: 1.15,
                            child: Transform.translate(
                              offset: const Offset(2.0, 23.0),
                              child: Image.asset(
                                'assets/icons/setting_color.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      elevation: MaterialStatePropertyAll(0.0)),
                  onPressed: () async {
                    final url = Uri.parse(
                        'https://smartreport.seoul.go.kr/w100/index.do');
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    } else {
                      // ignore: avoid_print
                      print("Can't launch $url");
                    }
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: 330,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '불법주차\n신고하기',
                            style: TextStyle(
                              fontFamily: 'Gangwonstate',
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: Transform.translate(
                              offset: const Offset(2.0, 23.0),
                              child:
                                  Image.asset('assets/icons/report_color.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
