import 'package:flutter/material.dart';

class Photo {
  final String imagePath;
  final String title;

  Photo({required this.imagePath, required this.title});
}

class HomePage extends StatelessWidget {
  final List<Photo> photos = [
    Photo(imagePath: 'assets/images/Screenshot 2023-06-11 at 1.46.37 AM.png', title: 'style 1'),
    Photo(imagePath: 'assets/images/Screenshot 2023-06-11 at 1.47.15 AM.png', title: 'style 2'),
    Photo(imagePath: 'assets/images/Screenshot 2023-06-11 at 1.47.31 AM.png', title: 'style 3'),
    Photo(imagePath: 'assets/images/Screenshot 2023-06-11 at 1.47.43 AM.png', title: 'style 4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(photos.length, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(photo: photos[index]),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Image.asset(photos[index].imagePath),
                  Text(photos[index].title),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Photo photo;

  DetailPage({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.title),
      ),
      body: Center(
        child: Image.asset(photo.imagePath),
      ),
    );
  }
}


