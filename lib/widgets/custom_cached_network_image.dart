import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget customCachedNetworkImage({
  required String imgPath,
  double height = 250,
}) {
  return CachedNetworkImage(
    height: height,
    width: double.infinity,
    imageUrl: 'https://image.tmdb.org/t/p/w500$imgPath',
    fit: BoxFit.cover,
    placeholder:
        (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade700,
          child: Container(
            height: 400,
            width: double.infinity,
            color: Colors.grey.shade900,
          ),
        ),

    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
