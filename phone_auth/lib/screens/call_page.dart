import 'package:flutter/material.dart';
import 'package:phone_auth/const.dart';

class CallPage extends StatelessWidget {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Center(
              child: Text(
                'Appels',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 35,
              margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 210, 210, 210),
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 25, top: 2, right: 50, bottom: 3),
                    child: Image.asset(
                      'assets/icons/search.png',
                      height: 20,
                    ),
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Rechercher dans les appels',
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(left: 12, right: 12),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                FirstSectionWidget(
                  color: color2,
                  text: 'Tout',
                  onTap: () {},
                ),
                const SizedBox(
                  width: 25,
                ),
                FirstSectionWidget(
                  color: color1,
                  text: 'Appels manques',
                  onTap: () {},
                ),
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: color1,
                border: Border(bottom: BorderSide(color: color1)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 7,
                  itemBuilder: (context, index) => const CallWidget()),
            ),
          ],
        ),
      ),
    );
  }
}

class CallWidget extends StatelessWidget {
  const CallWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    color: color1,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/icons/profil.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Adam',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'appel entrant',
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Image.asset(
                                  'assets/icons/appel-manque.png',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text('19h23')
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10.0),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: color1))),
            )
          ],
        ),
      ),
    );
  }
}

class FirstSectionWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  const FirstSectionWidget(
      {super.key,
      required this.text,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(7))),
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
