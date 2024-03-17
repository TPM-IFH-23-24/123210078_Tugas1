import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bma_travel/models/tourism_place.dart';
import 'package:bma_travel/pages/login.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authStorage = GetStorage('auth');
  List<bool> isExpanded = List.filled(tourismPlaceList.length, false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            _heading(context),
            // _searchBar(context),
            // _mainmenu(context),
            _tourismListMenu(context),
            const SizedBox(height: 20)
          ]),
        ),
      ),
    );
  }

  Widget _heading(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20, bottom: 16),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${widget.username}  👋🏻",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Welcome to Bagus MA Travel.",
                ),
              ],
            ),
            _logout(context)
          ],
        ));
  }

  Widget _tourismListMenu(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int count = (width > 840) ? 2 : 1;

    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) => _tourismListItem(context, index),
        itemCount: tourismPlaceList.length,
      ),
    );
  }

  Widget _tourismListItem(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: const Color.fromARGB(32, 0, 0, 0)),
          image: DecorationImage(
              image: NetworkImage(tourismPlaceList[index].imageUrls[0]),
              fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: width,
            // padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded[index] = !isExpanded[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tourismPlaceList[index].name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(isExpanded[index]
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down),
                            ]),
                        Text(
                          tourismPlaceList[index].location,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(128, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isExpanded[index],
                  child: Container(
                    // margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Color.fromARGB(48, 0, 0, 0)))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                tourismPlaceList[index].openDays,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                tourismPlaceList[index].openTime,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.yellow,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6))),
                              onPressed: () {
                                _launchURL(
                                    tourismPlaceList[index].imageUrls[0]);
                              },
                              child: const Text('Open Image'))
                        ]),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: Colors.black,
          backgroundColor: const Color.fromARGB(66, 124, 124, 124),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            authStorage.remove('username');
            authStorage.remove('isLogged');
            return const LoginPage();
          }),
        );
      },
      icon: const Icon(Icons.logout),
    );
  }

  Future<void> _launchURL(String strUrl) async {
    Uri url = Uri.parse(strUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
