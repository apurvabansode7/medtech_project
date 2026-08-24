import 'package:flutter/material.dart';
import 'package:medtech_project/features/home/models/home_banner_model.dart';

class HomeBannerDummyData {
  static const List<HomeBannerModel> banners = [
    HomeBannerModel(
      title: 'Products',
      description: 'Explore our latest  products.',
      icon: Icons.medical_services_outlined,
    ),

    HomeBannerModel(
      title: 'Scan Products',
      description: 'Scan a product to get more information.',
      icon: Icons.qr_code_scanner,
    ),

    HomeBannerModel(
      title: 'Special Offers',
      description: 'Discover our latest offers and products.',
      icon: Icons.local_offer_outlined,
    ),

    HomeBannerModel(
      title: 'Product Rewards',
      description: 'Purchase products and earn exciting rewards.',
      icon: Icons.card_giftcard_outlined,
    ),

    HomeBannerModel(
      title: 'New Arrivals',
      description: 'Check out our newest healthcare products.',
      icon: Icons.new_releases_outlined,
    ),

    HomeBannerModel(
      title: 'Essentials',
      description: 'Find essential products for your daily care.',
      icon: Icons.health_and_safety_outlined,
    ),

    HomeBannerModel(
      title: 'Featured Products',
      description: 'Discover our most popular  products.',
      icon: Icons.star_border_rounded,
    ),

    HomeBannerModel(
      title: 'Exclusive Deals',
      description: 'Get special discounts on selected products.',
      icon: Icons.discount_outlined,
    ),
  ];
}