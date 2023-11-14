import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/blocs/detail_story/detail_story_bloc.dart';

class DetailStoryScreen extends StatefulWidget {
  final String id;

  const DetailStoryScreen({super.key, required this.id});

  @override
  State<DetailStoryScreen> createState() => _DetailStoryScreenState();
}

class _DetailStoryScreenState extends State<DetailStoryScreen> {
  late DetailStoryBloc detailStoryBloc;

  @override
  void initState() {
    detailStoryBloc = BlocProvider.of<DetailStoryBloc>(context);
    detailStoryBloc.add(GetDetailStory(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailStoryBloc, DetailStoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Detail Story"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state is OnSuccessDetailStory)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: ClipRect(
                          child: Image.network(
                            state.data.story?.photoUrl ?? "",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.data.story?.name ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18),
                          ),
                          Text(
                            state.data.story?.description ?? "",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
