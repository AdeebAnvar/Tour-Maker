import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/theme/style.dart';
import 'custom_shimmer.dart';

class PackageTile extends StatelessWidget {
  const PackageTile({
    super.key,
    required this.onPressed,
    required this.isFavourite,
    required this.onClickedFavourites,
    required this.tourName,
    required this.tourCode,
    required this.tourDays,
    required this.tournights,
    required this.tourAmount,
    required this.tourImage,
  });
  final String tourName;
  final String tourCode;
  final String tourDays;
  final String tournights;
  final String tourAmount;
  final String tourImage;
  final Function() onPressed;
  final bool isFavourite;
  final Function() onClickedFavourites;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        // width: 160,
        height: 165,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CachedNetworkImage(
                    cacheManager: DefaultCacheManager(),
                    useOldImageOnUrlChange: true,
                    errorWidget:
                        (BuildContext context, String url, dynamic error) {
                      return const Icon(Icons.error);
                    },
                    placeholder: (BuildContext context, String url) =>
                        CustomShimmer(
                      width: 125,
                      height: 125,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    imageUrl: tourImage,
                    imageBuilder: (BuildContext context,
                            ImageProvider<Object> imageProvider) =>
                        Container(
                      margin: const EdgeInsets.all(10),
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: englishlinearViolet,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: imageProvider,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tourName.split(' ').join('\n'),
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: fontColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(tourCode, style: paragraph1),
                    const SizedBox(height: 12),
                    Text(
                      '$tourDays Days / $tournights Nights',
                      style: subheading3,
                    ),
                    const SizedBox(height: 13),
                    Text('₹ $tourAmount', style: heading3),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                height: 180,
                margin: const EdgeInsets.only(right: 16, top: 15),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: onClickedFavourites,
                      child: isFavourite
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20.sp,
                            )
                          : Icon(
                              Icons.favorite_border_outlined,
                              color: englishlinearViolet,
                              size: 20.sp,
                            ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
