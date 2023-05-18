import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/tour_maker_icons.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/custom_shimmer.dart';
import '../controllers/main_screen_controller.dart';

class MainScreenView extends GetView<MainScreenController> {
  const MainScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final MainScreenController controller = Get.put(MainScreenController());
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: controller.obx(
        onLoading: const CustomLoadingScreen(),
        (MainScreenView? state) => RefreshIndicator(
          onRefresh: controller.loadData,
          color: englishViolet,
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: SingleChildScrollView(
              physics: const RangeMaintainingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  //search field for Home Screen
                  buildHeadSection(screenHeight, context),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //Categories Section
                        buildCategories(screenHeight),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Text('     Trending', style: paragraph1),
                          ],
                        ),
                        const SizedBox(height: 20),
                        //Trending tours secction
                        buildTrending(screenHeight),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Text('     Exclusive Tours', style: paragraph1),
                          ],
                        ),
                        const SizedBox(height: 20),
                        //Exclusive tour Section
                        buildExclusive(screenHeight, screenWidth),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Text('     Travel Types', style: paragraph1)
                          ],
                        ),
                        //Travel types tours section
                        buildTravelTypes(screenHeight, screenWidth),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTravelTypes(double screenHeight, double screenWidth) {
    return Obx(
      () => controller.travelTypesToursList.isEmpty
          ? CustomShimmer(
              margin: const EdgeInsets.all(7),
              padding: const EdgeInsets.all(10),
              height: 100,
              borderRadius: BorderRadius.circular(18),
              width: screenWidth * 0.75,
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.travelTypesToursList.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () => controller.onClickedSingleTravelTypeTour(
                    controller.travelTypesToursList[index].name),
                child: Hero(
                  tag: controller.travelTypesToursList[index],
                  transitionOnUserGestures: true,
                  child: Material(
                    borderRadius: BorderRadius.circular(18),
                    type: MaterialType.transparency,
                    elevation: 5,
                    child: CachedNetworkImage(
                      cacheManager: DefaultCacheManager(),
                      placeholder: (BuildContext context, String url) =>
                          CustomShimmer(
                        margin: const EdgeInsets.all(7),
                        padding: const EdgeInsets.all(10),
                        height: 100,
                        borderRadius: BorderRadius.circular(18),
                        width: screenWidth * 0.75,
                      ),
                      imageUrl: controller.travelTypesToursList[index].image
                          .toString(),
                      imageBuilder: (BuildContext context,
                              ImageProvider<Object> imageProvider) =>
                          Container(
                        margin: const EdgeInsets.all(7),
                        padding: const EdgeInsets.all(10),
                        height: 100,
                        width: screenWidth * 0.75,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover, image: imageProvider),
                          color: englishlinearViolet,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    controller.travelTypesToursList[index].name
                                        .toString(),
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildExclusive(double screenHeight, double screenWidth) {
    return Obx(
      () => controller.exclusiveToursList.isEmpty
          ? CustomShimmer(
              height: screenHeight * 0.35,
              borderRadius: BorderRadius.circular(30),
            )
          : Container(
              height: screenHeight * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListView.builder(
                physics: const RangeMaintainingScrollPhysics(),
                itemCount: controller.exclusiveToursList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () => controller.onClickSingleExclusiveTour(
                      controller.exclusiveToursList[index].name),
                  child: Hero(
                    tag: controller.exclusiveToursList[index],
                    transitionOnUserGestures: true,
                    child: Material(
                      borderRadius: BorderRadius.circular(18),
                      type: MaterialType.transparency,
                      elevation: 5,
                      child: CachedNetworkImage(
                        cacheManager: DefaultCacheManager(),
                        placeholder: (BuildContext context, String url) =>
                            CustomShimmer(
                          margin: const EdgeInsets.all(7),
                          padding: const EdgeInsets.all(10),
                          width: screenWidth * 0.75,
                        ),
                        imageUrl:
                            controller.categoryList[index].image.toString(),
                        imageBuilder: (BuildContext context,
                                ImageProvider<Object> imageProvider) =>
                            Container(
                          margin: const EdgeInsets.all(7),
                          padding: const EdgeInsets.all(10),
                          width: screenWidth * 0.75,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            ),
                            color: englishlinearViolet,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      controller.exclusiveToursList[index].name
                                          .toString(),
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildTrending(double screenHeight) {
    return Obx(
      () => controller.trendingToursList.isEmpty
          ? CustomShimmer(
              height: screenHeight * 0.30,
              borderRadius: BorderRadius.circular(30),
            )
          : Container(
              height: screenHeight * 0.30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListView.builder(
                physics: const PageScrollPhysics(),
                itemCount: controller.trendingToursList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () => controller.onClickSingleTrendingTour(
                      controller.trendingToursList[index].destination),
                  child: Hero(
                    tag: controller.trendingToursList[index],
                    transitionOnUserGestures: true,
                    child: Material(
                      borderRadius: BorderRadius.circular(18),
                      // borderOnForeground: false,

                      type: MaterialType.transparency,
                      elevation: 5,
                      child: CachedNetworkImage(
                        cacheManager: DefaultCacheManager(),
                        placeholder: (BuildContext context, String url) =>
                            CustomShimmer(
                          width: 171,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        imageUrl: controller.trendingToursList[index].image
                            .toString(),
                        imageBuilder: (BuildContext context,
                                ImageProvider<Object> imageProvider) =>
                            Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          width: 171,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            ),
                            color: englishlinearViolet,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        controller.trendingToursList[index]
                                            .destination
                                            .toString(),
                                        style: TextStyle(
                                          fontFamily: 'Tahu',
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        'Tours',
                                        style: TextStyle(
                                          fontFamily: 'Tahu',
                                          fontSize: 20,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      'Starting From: ',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      controller
                                          .trendingToursList[index].minAmount
                                          .toString(),
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Obx buildCategories(double screenHeight) {
    return Obx(() {
      return controller.categoryList.isEmpty
          ? CustomShimmer(
              width: 1000,
              borderRadius: BorderRadius.circular(20),
              height: 200,
            )
          : Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: screenHeight * 0.35,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 18),
                          child: Text('  Category', style: paragraph1),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: SizedBox(
                          height: double.infinity,
                          child: GridView.builder(
                            itemCount: controller.categoryList.length,
                            physics: controller.categoryList.length <= 8
                                ? const NeverScrollableScrollPhysics()
                                : const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 5,
                              crossAxisCount: 4,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () =>
                                    controller.onClickedSingleCategoryTour(
                                  controller.categoryList[index].name
                                      .toString(),
                                  controller.categoryList[index].image
                                      .toString(),
                                ),
                                child: Hero(
                                  transitionOnUserGestures: true,
                                  tag: controller.categoryList[index].image
                                      .toString(),
                                  child: SizedBox(
                                    height: 73,
                                    width: 73,
                                    child: Column(
                                      children: <Widget>[
                                        CachedNetworkImage(
                                          // cacheKey:
                                          //     'categories_image_cache_key ${controller.categoryList[index].image}',
                                          // cacheManager: DefaultCacheManager(),
                                          fadeInDuration:
                                              const Duration(milliseconds: 600),
                                          imageUrl: controller
                                              .categoryList[index].image!,
                                          imageBuilder: (BuildContext context,
                                                  ImageProvider<Object>
                                                      imageProvider) =>
                                              Container(
                                            width: 55,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (BuildContext context,
                                                  String url) =>
                                              const CustomShimmer(
                                            width: 55,
                                            height: 55,
                                            shape: BoxShape.circle,
                                          ),
                                          errorWidget: (BuildContext context,
                                                  String url, dynamic error) =>
                                              const Icon(Icons.error),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          controller.categoryList[index].name
                                              .toString(),
                                          overflow: TextOverflow.clip,
                                          style: paragraph4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
    });
  }

  Stack buildHeadSection(double screenHeight, BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: screenHeight * 0.4,
          decoration: BoxDecoration(
            color: englishlinearViolet,
            image: const DecorationImage(
              image: AssetImage(
                  'assets/farshad-rezvanian-Eelegt4hFNc-unsplash.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 80.w),
        //   child: badges.Badge(
        //     badgeContent: Text(
        //       '3',
        //       style: GoogleFonts.montserrat(
        //         fontWeight: FontWeight.w500,
        //         fontSize: 12,
        //         color: Colors.white,
        //       ),
        //     ),
        //     badgeAnimation: const badges.BadgeAnimation.fade(),
        //     ignorePointer: true,
        //     badgeStyle: badges.BadgeStyle(
        //       borderRadius: BorderRadius.circular(50),
        //     ),
        //     position: badges.BadgePosition.topEnd(end: -28, top: -12),
        //     child: Icon(TourMaker.notification, color: englishViolet),
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 100),
          child: Image.asset('assets/Logo.png', height: 50),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: 20, right: 20, top: screenHeight * 0.30),
          child: Material(
            elevation: 8,
            type: MaterialType.transparency,
            child: TextField(
              //enabled: false,
              focusNode: controller.searchFocusNode,
              controller: controller.textController,
              onTap: () => controller.onSearchClicked(),
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(TourMaker.search, color: englishViolet, size: 30),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search Destinations',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(18),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(18),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
