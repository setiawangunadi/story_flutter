import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Story"),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.blue,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 4,
                  offset: Offset(1, 1), // Shadow position
                ),
              ],
            ),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              // SizedBox(
              //   width: 100,
              //   height: 100,
              //   child: FittedBox(
              //     fit: BoxFit.fill,
              //     child: ClipRect(
              //       child: Image.network(
              //         storiesModel.listStory![index].photoUrl!,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(width: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title Test",
                      // storiesModel.listStory?[index].name ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                    Text(
                      "Body Test",
                      // storiesModel
                      // .listStory?[index].description ??
                      // "",
                    ),
                  ],
                ),
              ),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
