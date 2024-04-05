import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_app/blocs/home/home_bloc.dart';
import 'package:story_app/config/models/get_stories.dart';
import 'package:story_app/config/models/list_story.dart';
import 'package:story_app/shared/widget/custom_toast.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onTappedAddStory;
  final Function(bool) onTappedLogout;
  final Function(bool, String) onTappedDetailStory;
  final Function() onBackPressed;

  const HomeScreen({
    super.key,
    required this.onTappedAddStory,
    required this.onTappedLogout,
    required this.onTappedDetailStory,
    required this.onBackPressed,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;
  GetStories? dataStories;
  List<ListStory> listDataStories = [];
  int page = 1;
  int size = 10;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(GetListStory(location: 1, page: page, size: size));
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is OnSuccessHome) {
          _refreshController.loadComplete();
          setState(() {
            dataStories = state.data;
          });
          listDataStories += state.data.listStory ?? [];
        }
        if (state is OnSuccessLogout) {
          widget.onTappedLogout(false);
        }
        if (state is OnFailedHome) {
          AppToast.show(context, state.message, Colors.red);
        }
      },
      builder: (context, state) {
        if (state is OnLoadingHome) {
          Shimmer.fromColors(
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
          );
        }
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) {
              return;
            }
            widget.onBackPressed();
          },
          child: Scaffold(
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
            body: SmartRefresher(
              controller: _refreshController,
              enablePullUp: true,
              onLoading: () {
                page++;
                homeBloc.add(
                  GetListStory(
                    location: 0,
                    size: size,
                    page: page,
                  ),
                );
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    listDataStories.length,
                    (index) => GestureDetector(
                      onTap: () => widget.onTappedDetailStory(
                        true,
                        listDataStories[index].id ?? "",
                      ),
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
                              offset: Offset(1, 1),
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
                                    listDataStories[index].photoUrl ?? "",
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
                                    listDataStories[index].name ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    listDataStories[index].description ?? "",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.amber,
              child: const Icon(Icons.add),
              onPressed: () => widget.onTappedAddStory(true),
            ),
          ),
        );
      },
    );
  }
}
