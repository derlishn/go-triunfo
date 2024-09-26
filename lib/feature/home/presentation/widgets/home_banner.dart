import 'package:flutter/material.dart';
import 'package:go_triunfo/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import '../manager/banner_viewmodel.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bannerViewModel = Provider.of<BannerViewModel>(context);

    return bannerViewModel.isLoading
        ? _buildSkeletonLoader()
        : bannerViewModel.activeBanners.isEmpty
        ? const Center(child: Text('No hay banners disponibles.'))
        : Column(
      children: [
        SizedBox(height: 16),
        CarouselSlider.builder(
          itemCount: bannerViewModel.activeBanners.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  bannerViewModel.activeBanners[index].imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(bannerViewModel.activeBanners.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: _currentIndex == index ? 12 : 8,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppColors.primaryOrange
                    : Colors.grey[400],
                shape: BoxShape.circle,
                boxShadow: _currentIndex == index
                    ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }

  // Método para construir la animación del skeleton loader
  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) => const BannerSkeletonLoader()).toList(),
      ),
    );
  }
}

// El loader animado de skeleton para los banners
class BannerSkeletonLoader extends StatelessWidget {
  const BannerSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(seconds: 3), // Prolongamos la animación del shimmer
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 200,
        width: MediaQuery.of(context).size.width * 0.8, // Tamaño similar al banner
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
