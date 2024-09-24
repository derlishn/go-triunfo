import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../manager/banner_viewmodel.dart';

class HomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bannerViewModel = Provider.of<BannerViewModel>(context);

    return bannerViewModel.isLoading
        ? Center(child: CircularProgressIndicator())
        : bannerViewModel.activeBanners.isEmpty
        ? Center(child: Text('No hay banners disponibles.'))
        : CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayInterval: Duration(seconds: 5),
      ),
      items: bannerViewModel.activeBanners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      banner.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        color: Colors.black54,
                        child: Text(
                          banner.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
