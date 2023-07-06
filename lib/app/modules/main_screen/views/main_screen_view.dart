import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () => controller.onClickedSingleTravelTypeTour(
                      controller.travelTypesToursList[index].name),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 5,
                    child: CachedNetworkImage(
                        fadeInCurve: Curves.bounceInOut,
                        placeholder: (BuildContext context, String url) =>
                            CustomShimmer(
                              height: screenWidth * 0.75,
                              width: 171,
                              borderRadius: BorderRadius.circular(30),
                            ),
                        imageUrl: controller.travelTypesToursList[index].image
                            .toString(),
                        imageBuilder: (BuildContext context,
                            ImageProvider<Object> imageProvider) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            height: 100,
                            width: screenWidth * 0.75,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  controller.travelTypesToursList[index].image
                                      .toString(),
                                ),
                              ),
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(18),
                            ),
                          );
                        }),
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
          : SizedBox(
              height: screenHeight * 0.35,
              child: CarouselSlider.builder(
                itemCount: controller.exclusiveToursList.length,
                options: CarouselOptions(
                    height: screenHeight * 0.35,
                    aspectRatio: 3 / 4,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    autoPlay: true,
                    disableCenter: true),
                itemBuilder: (BuildContext context, int index, int realIndex) =>
                    Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: GestureDetector(
                    onTap: () => controller.onClickSingleExclusiveTour(
                        controller.exclusiveToursList[index].name),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 5,
                      child: CachedNetworkImage(
                          fadeInCurve: Curves.bounceInOut,
                          placeholder: (BuildContext context, String url) =>
                              CustomShimmer(
                                height: screenHeight * 0.30,
                                width: 171,
                                borderRadius: BorderRadius.circular(30),
                              ),
                          imageUrl: controller.exclusiveToursList[index].image
                              .toString(),
                          imageBuilder: (BuildContext context,
                              ImageProvider<Object> imageProvider) {
                            return Container(
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
                            );
                          }),
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
          : SizedBox(
              height: screenHeight * 0.30,
              child: CarouselSlider.builder(
                itemCount: controller.trendingToursList.length,
                options: CarouselOptions(
                    height: screenHeight * 0.30,
                    aspectRatio: 3 / 4,
                    enlargeCenterPage: true,
                    viewportFraction: 0.5,
                    autoPlay: true,
                    disableCenter: true),
                itemBuilder: (BuildContext context, int index, int realIndex) =>
                    Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    onTap: () => controller.onClickSingleTrendingTour(
                        controller.trendingToursList[index].destination),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      clipBehavior: Clip.hardEdge,
                      elevation: 4,
                      child: CachedNetworkImage(
                          fadeInCurve: Curves.bounceInOut,
                          placeholder: (BuildContext context, String url) =>
                              CustomShimmer(
                                height: screenHeight * 0.30,
                                width: 171,
                                borderRadius: BorderRadius.circular(30),
                              ),
                          imageUrl: controller.trendingToursList[index].image
                              .toString(),
                          imageBuilder: (BuildContext context,
                              ImageProvider<Object> imageProvider) {
                            return Container(
                              // padding: const EdgeInsets.all(10),
                              width: 171,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: imageProvider,
                                ),
                                color: englishlinearViolet,
                                borderRadius: BorderRadius.circular(18),
                              ),
                            );
                          }),
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
          : Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
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
                                child: SizedBox(
                                  height: 73,
                                  width: 73,
                                  child: Column(
                                    children: <Widget>[
                                      CachedNetworkImage(
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
