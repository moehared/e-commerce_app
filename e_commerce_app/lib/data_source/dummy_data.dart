import 'package:flutter/material.dart';
import '../models/product.dart';

import '../models/category.dart';

final categoryList = [
  Category(id: 'c1', title: 'All'),
  Category(id: 'c2', title: 'jacket'),
  Category(id: 'c3', title: 'pants'),
  Category(id: 'c4', title: 'shirt'),
  Category(id: 'c5', title: 'Khamiis'),
];

final lookUpColor = {
  'black': Color(0xff000000),
  'blue': Color(0xff42a5f5),
  'grey': Color(0xff9e9e9e),
  'green': Color(0xff4caf50),
  'brown': Color(0xff795548),
};

// final products = [
//   Product(
//     id: 'p1',
//     title: 'Thobe',
//     price: 29.99,
//     // colors: [
//     //   'Black',
//     //   'dark blue',
//     //   'grey',
//     // ],
//     colors: {
//       'black': Colors.black,
//       'blue': Colors.blue.shade400,
//       'grey': Colors.grey,
//     },

//     categories: ['c1', 'c5'],
//     description: '''Fabric is cotton\n
// Full length thobe
// Short collar with button opening
// Side pockets and accent chest pocket
// Machine wash cold with like colors and tumble dry, ironing needed
//     images: [
//       'https://cdn.shopify.com/s/files/1/0121/7262/3930/products/mens-accent-thobe-496162_4000x.progressive.jpg?v=1580515353',
//       'https://cdn.shopify.com/s/files/1/0121/7262/3930/products/basic-mens-traditional-thobe-805407_4000x.progressive.jpg?v=1615293349',
//       'https://cdn.shopify.com/s/files/1/0121/7262/3930/products/zipper-front-grey-dishdasha-977218_4000x.progressive.jpg?v=1580516112',
//     ],
//     isFavourite: false,
//     size: ['S', 'M', 'L', 'XL'],
//   ),
//   Product(
//     id: 'p2',
//     title: 'Pants',
//     price: 39.99,
//     categories: ['c3', 'c1'],
//     // colors: [
//     //   'grey',
//     //   'Black',
//     // ],
//     colors: {
//       'grey': Colors.grey,
//       'black': Colors.black,
//     },

//     description: 'nice slim pants. ',
//     images: [
//       'https://images.lululemon.com/is/image/lululemon/LM5952S_032894_1?wid=1080&op_usm=0.5,2,10,0&fmt=webp&qlt=80,1&fit=constrain,0&op_sharpen=0&resMode=sharp2&iccEmbed=0&printRes=72',
//       'https://images.lululemon.com/is/image/lululemon/LM5952S_0001_1?wid=1080&op_usm=0.5,2,10,0&fmt=webp&qlt=80,1&fit=constrain,0&op_sharpen=0&resMode=sharp2&iccEmbed=0&printRes=72',
//     ],
//     isFavourite: false,
//     size: ['S', 'M', 'L', 'XL'],
//   ),
//   Product(
//     id: 'p3',
//     title: 'Shirt',
//     price: 118.00,
//     categories: ['c1', 'c4'],
//     // colors: [
//     //   'light blue',
//     //   'green',
//     //   'Black',
//     // ],
//     colors: {
//       'blue': Colors.blue.shade400,
//       'black': Colors.black,
//       'green': Colors.green,
//     },

//     description: 'nice long sleeve shirt. designed for on the move',
//     images: [
//       'https://images.lululemon.com/is/image/lululemon/LM3CM0S_024704_1?wid=1080&op_usm=0.5,2,10,0&fmt=webp&qlt=80,1&fit=constrain,0&op_sharpen=0&resMode=sharp2&iccEmbed=0&printRes=72',
//       'https://images.lululemon.com/is/image/lululemon/LM3CLXS_0001_1?wid=1080&op_usm=0.5,2,10,0&fmt=webp&qlt=80,1&fit=constrain,0&op_sharpen=0&resMode=sharp2&iccEmbed=0&printRes=72',
//       'https://images.lululemon.com/is/image/lululemon/LM3CM0S_048431_1?wid=1080&op_usm=0.5,2,10,0&fmt=webp&qlt=80,1&fit=constrain,0&op_sharpen=0&resMode=sharp2&iccEmbed=0&printRes=72',
//     ],
//     isFavourite: false,
//     size: ['S', 'M', 'L', 'XL'],
//   ),
//   Product(
//     id: 'p4',
//     title: 'Jacket',
//     price: 149.99,
//     categories: [
//       'c1',
//       'c2',
//     ],
//     // colors: [
//     //   'brown',
//     //   'blue',
//     //   'Black',
//     // ],
//     colors: {
//       'brown': Colors.brown,
//       'blue': Colors.blue.shade400,
//       'black': Colors.black,
//     },
//     description:
//         'nice and warm sweater.it is water-resistance jacket. good for rainy day',
//     images: [
//       'https://images.lululemon.com/is/image/lululemon/LM4AATS_045604_1?wid=1080&op_usm=0.5,2,10,0&fmt=webp&qlt=80,1&fit=constrain,0&op_sharpen=0&resMode=sharp2&iccEmbed=0&printRes=72',
//       'https://images.lululemon.com/is/image/lululemon/LM4AATS_026865_1?wid=1080&op_usm=0.5,2,10,0&fmt=webp&qlt=80,1&fit=constrain,0&op_sharpen=0&resMode=sharp2&iccEmbed=0&printRes=72',
//       'https://images.lululemon.com/is/image/lululemon/LM4975S_0001_1?wid=1080&op_usm=0.5,2,10,0&fmt=webp&qlt=80,1&fit=constrain,0&op_sharpen=0&resMode=sharp2&iccEmbed=0&printRes=72',
//     ],
//     isFavourite: false,
//     size: [
//       'S',
//       'M',
//       'L',
//       'XL',
//     ],
//   ),
// ];
