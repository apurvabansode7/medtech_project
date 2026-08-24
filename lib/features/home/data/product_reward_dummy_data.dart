import 'package:medtech_project/features/home/models/product_reward_model.dart';

class ProductRewardDummyData {
  static const List<ProductRewardModel> rewards = [
    ProductRewardModel(
      productName: 'Digital Blood Pressure Monitor',
      rewardPoints: '120',
      description: 'Accurate and easy-to-use health monitoring device.',
    ),

    ProductRewardModel(
      productName: 'Pulse Oximeter',
      rewardPoints: '80',
      description: 'Monitor your blood oxygen level anytime.',
    ),

    ProductRewardModel(
      productName: 'Digital Thermometer',
      rewardPoints: '50',
      description: 'Fast and reliable temperature measurement.',
    ),

    ProductRewardModel(
      productName: 'Glucometer Kit',
      rewardPoints: '150',
      description: 'Easy blood glucose monitoring at home.',
    ),

    ProductRewardModel(
      productName: 'Nebulizer Machine',
      rewardPoints: '200',
      description: 'Convenient respiratory care for everyday use.',
    ),
  ];
}