import 'package:flutter/material.dart';
import 'package:phone_auth/const.dart';

class GroupePage extends StatelessWidget {
  const GroupePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Groupes',
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
                            hintText: 'Rechercher dans les groupes',
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: PlainWidgetRow(
                    color: const Color(0xFFEDE6F2),
                    text: 'Creer un nouveau groupe',
                    imageAsset: 'assets/icons/plus.png',
                    onTap: () {}),
              ),
              const GroupWidget(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: PlainWidgetRow(
                    color: const Color(0xFFC5B8CE),
                    text: 'Communaute TETOUAN',
                    imageAsset: 'assets/icons/users_b.png',
                    onTap: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlainWidgetRow extends StatelessWidget {
  final String text;
  final String imageAsset;
  final VoidCallback onTap;
  final Color color;
  const PlainWidgetRow(
      {super.key,
      required this.text,
      required this.imageAsset,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: Image.asset(
                imageAsset,
                width: 25,
                height: 25,
              ),
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupWidget extends StatelessWidget {
  const GroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
          color: color1, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          GroupHeaderWidget(
            onTap: () {},
            text: 'Tetouan boys',
          ),
          PlainWidgetRow(
              color: const Color(0xFFC5B8CE),
              text: 'Club des As',
              imageAsset: 'assets/icons/utilisateurs.png',
              onTap: () {}),
          const LineWidget(),
          PlainWidgetRow(
              color: const Color(0xFFC5B8CE),
              text: 'Club des As',
              imageAsset: 'assets/icons/utilisateurs.png',
              onTap: () {}),
          const LineWidget(),
          const Text('Voir plus...'),
        ],
      ),
    );
  }
}

class LineWidget extends StatelessWidget {
  const LineWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white))),
    );
  }
}

class GroupHeaderWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const GroupHeaderWidget({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color(0xFFC5B8CE),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: const BoxDecoration(
                      color: color2, shape: BoxShape.circle),
                  child: Image.asset(
                    'assets/icons/users.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const LineWidget(),
        ],
      ),
    );
  }
}
