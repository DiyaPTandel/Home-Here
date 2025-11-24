import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GalleryPage extends StatefulWidget {
  final List<String> images;
  final List<String>? extraImages; // Optional extra images

  const GalleryPage({super.key, required this.images, this.extraImages});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late final List<String> allImages;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Merge property images with optional extra images + web images
    allImages = [
      ...widget.images,
      if (widget.extraImages != null) ...widget.extraImages!,
      // Extra images from the web
      'https://images.unsplash.com/photo-1604079625342-1b5b599f0f18',
      'https://images.unsplash.com/photo-1593642532973-d31b6557fa68',
      'https://images.unsplash.com/photo-1612831455541-50ac04f5c1ec',
      'https://images.unsplash.com/photo-1581291519195-ef11498d1cf6',
      'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery")),
      body: Stack(
        children: [
          PageView.builder(
            itemCount: allImages.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              final img = allImages[index];
              return InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 3.0,
                child: img.startsWith("http")
                    ? CachedNetworkImage(
                        imageUrl: img,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.broken_image, size: 50)),
                      )
                    : Image.asset(img, fit: BoxFit.contain),
              );
            },
          ),

          // Page indicator dots at the bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(allImages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 12 : 8,
                  height: currentIndex == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.blue
                        : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
