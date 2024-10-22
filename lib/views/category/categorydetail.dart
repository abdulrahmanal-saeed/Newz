import 'package:flutter/material.dart';
import 'package:newz/apptheme.dart';
import 'package:newz/views/category/newsitems.dart';
import 'package:newz/views/widgets/error_loading_indicatore.dart';
import 'package:newz/views/widgets/loading_indicatore.dart';
import 'package:provider/provider.dart';
import 'package:newz/view_models/category_view_model.dart';

class Categorydetail extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const Categorydetail({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryViewModel()..fetchSources(categoryId),
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
        body: const _CategoryDetailBody(),
      ),
    );
  }
}

class _CategoryDetailBody extends StatelessWidget {
  const _CategoryDetailBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CategoryViewModel>(context);

    if (viewModel.isLoading) {
      return const LoadingIndicatore();
    } else if (viewModel.hasError) {
      return const ErrorLoadingIndicatore();
    }

    final sources = viewModel.sources;

    return DefaultTabController(
      length: sources.length,
      child: Column(
        children: [
          const SizedBox(height: 10),
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicator: const BoxDecoration(
              color: Colors.transparent,
            ),
            onTap: (index) {
              viewModel.setSelectedTabIndex(index);
              viewModel.fetchNewsBySource(sources[index].id!);
            },
            tabs: sources.map((source) {
              final isSelected =
                  viewModel.selectedTabIndex == sources.indexOf(source);
              return Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    source.name ?? 'Unknown',
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Newsitems(
              sourceId: sources[viewModel.selectedTabIndex].id!,
            ),
          ),
        ],
      ),
    );
  }
}
