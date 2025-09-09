import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget customCachedNetworkImage({required String imgPath}) {
  return CachedNetworkImage(
    height: 250,
    width: double.infinity,
    imageUrl: 'https://image.tmdb.org/t/p/w500$imgPath',
    fit: BoxFit.cover,
    placeholder:
        (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 400,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
