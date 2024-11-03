import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newz/apptheme.dart';
import 'package:newz/bloc/category_bloc.dart';
import 'package:newz/views/widgets/error_loading_indicatore.dart';
import 'package:newz/views/widgets/loading_indicatore.dart';
import 'package:newz/views/category/newsitems.dart';

class CategoryDetail extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryDetail({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBloc(RepositoryProvider.of(context))
        ..add(FetchSources(widget.categoryId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F5FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: AppTheme.darkGray,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/logowithoutbg.png",
                height: MediaQuery.of(context).size.height * 0.04,
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const LoadingIndicatore();
            } else if (state is CategoryError) {
              return const ErrorLoadingIndicatore();
            } else if (state is CategoryLoaded) {
              final sources = state.sources;

              return DefaultTabController(
                length: sources.length,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TabBar(
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.transparent,
                      isScrollable: true,
                      indicator: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      onTap: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      tabs: sources.map((source) {
                        final isSelected =
                            sources.indexOf(source) == selectedIndex;
                        return Tab(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Colors.grey : Colors.red,
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              source.name ?? 'Unknown',
                              style: TextStyle(
                                color: isSelected ? Colors.red : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: TabBarView(
                        children: sources.map((source) {
                          return Newsitems(
                            sourceId: source.id!,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
