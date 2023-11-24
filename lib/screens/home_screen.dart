import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_app/blocs/home/home_bloc.dart';
import 'package:story_app/config/models/get_stories_response_model.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onTappedAddStory;
  final Function(bool) onTappedLogout;
  final Function(bool, String) onTappedDetailStory;

  const HomeScreen({
    super.key,
    required this.onTappedAddStory,
    required this.onTappedLogout,
    required this.onTappedDetailStory,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;
  GetStoriesResponseModel? dataStories;

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(GetListStory(location: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is OnSuccessHome) {
          setState(() {
            dataStories = state.data;
          });
        }
        if (state is OnSuccessLogout) {
          widget.onTappedLogout(false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("List Story"),
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: [
              GestureDetector(
                onTap: () => homeBloc.add(DoLogout()),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.logout),
                ),
              )
            ],
          ),
          body: state is OnLoadingHome
              ? Shimmer.fromColors(
                  direction: ShimmerDirection.ltr,
                  period: const Duration(milliseconds: 1200),
                  baseColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.white,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 78,
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: dataStories?.listStory?.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => widget.onTappedDetailStory(
                          true, dataStories?.listStory?[index].id ?? ""),
                      child: Container(
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
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: ClipRect(
                                    child: Image.network(
                                      dataStories?.listStory?[index].photoUrl ??
                                          "",
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dataStories?.listStory?[index].name ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      dataStories
                                              ?.listStory?[index].description ??
                                          "",
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            child: const Icon(Icons.add),
            onPressed: () => widget.onTappedAddStory(true),
          ),
        );
      },
    );
  }
}
