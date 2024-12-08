import 'package:animeate/Api/jikan_api.dart';
import 'package:animeate/Models/news_item.dart';
import 'package:animeate/Provider/network_provider.dart';
import 'package:animeate/dialog/fast_snack_bar.dart';
import 'package:animeate/widget/news_item.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  //* setting vars
  final List<NewsItem> newsList = [];
  bool isLoading = false;
  int currentPage = 1;

  //* create the controller
  ScrollController newsScrollController = ScrollController();

  //* initial
  @override
  void initState() {
    super.initState();
    _loadMoreNews();
    newsScrollController.addListener(_scrollListener);
  }

  //* remove when finish
  @override
  void dispose() {
    newsScrollController.removeListener(_scrollListener);
    newsScrollController.dispose();
    super.dispose();
  }

  //* functions
  //? Check if the user has scrolled to the bottom of the list
  void _scrollListener() {
    if (newsScrollController.position.pixels ==
        newsScrollController.position.maxScrollExtent) {
      _loadMoreNews();
    }
  }

  //? load more news to feed up the section
  Future<void> _loadMoreNews() async {
    // * Prevent multiple simultaneous loading requests and check if widget is still mounted
    if (isLoading || !mounted) return;

    // * Set loading state to true
    setState(() {
      isLoading = true;
    });

    try {
      List<dynamic> moreNews;
      do {
        // * Fetch news for the current page
        moreNews = await getAnimeNewsById(currentPage);
        currentPage++;
        // * Check if widget is still mounted after each API call
        if (!mounted) return;
      } while (moreNews.isEmpty);

      // * If news were fetched and the widget is still mounted, update the state
      if (moreNews.isNotEmpty && mounted) {
        setState(() {
          newsList.addAll(moreNews.cast<NewsItem>());
        });
      }
    } catch (e) {
      showFastSnackBar(context, "Failed To Load", Colors.orange, Icons.info);
    } finally {
      // * Reset loading state if the widget is still mounted
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  //*Ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //* appBar
      appBar: newsAppBar(),
      //* widget body
      body: newsPageBody(),
    );
  }

  //* appBar body
  PreferredSizeWidget newsAppBar() {
    return AppBar(
      title: const Text(
        "Updates",
        style: TextStyle(
          fontFamily: "Quick",
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }

  //* the news page body
  Widget newsPageBody() {
    return ListView.builder(
      //
      controller: newsScrollController,
      itemCount: newsList.length + 1,
      //
      itemBuilder: (context, index) {
        if (index < newsList.length) {
          // * Display news item
          return clickableNewsItem(index: index);
        } else if (isLoading) {
          // * Show loading indicator at the bottom while fetching more news
          return loadingWidgetForNewsItems();
        } else {
          // * Add extra space at the bottom to allow scrolling past the last item
          return scrollSpace();
        }
      },
    );
  }

  //* news item body
  Widget clickableNewsItem({required int index}) {
    return GestureDetector(
        onTap: () {
          openUrlInBrowser(newsList[index].url, context);
        },
        child: newsItemWidget(newsList[index], context));
  }

  //* scroll space
  Widget scrollSpace() {
    return const SizedBox(height: 50);
  }

  //* loading widget
  Widget loadingWidgetForNewsItems() {
    return const Padding(
      padding: EdgeInsets.all(25),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
