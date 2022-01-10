import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Post extends StatefulWidget {
  const Post(
      {Key? key,
      this.userId,
      this.title,
      this.description,
      this.location,
      this.rating,
      this.imageLink})
      : super(key: key);

  final String? userId;
  final String? title;
  final String? description;
  final String? location;
  final int? rating;
  final String? imageLink;

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  Color postBgColor = const Color(0xFFD8AEAE);

  String imageLink =
      "https://erestaurantconsulting.ca/wp-content/uploads/2019/04/Restaurant-Performance-Measurement-1080x675.jpg";

  String postTitle = "Bob's coffee";
  double beanSize = 30;
  double ratingMargin = 10;
  double mainMargin = 5;
  int rating = 3;
  double fontSize = 24.0;
  EdgeInsets postMargins = const EdgeInsets.fromLTRB(5, 10, 5, 0);
  EdgeInsets postNameMargins = const EdgeInsets.fromLTRB(25, 10, 0, 0);

  String apiKey = "AIzaSyA2fzQ7U_Kisoh4JCPjmIFKxGmVCIh9OKQ";

  void init() {
    //  widget.userId
    setState(() {
      imageLink = widget.imageLink ?? imageLink;
      postTitle = widget.title ?? postTitle;
      rating = widget.rating ?? rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    // getCityName();
    init();

    return Wrap(children: [
      Container(
          color: postBgColor,
          margin: postMargins,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Image(image: NetworkImage(imageLink))
              AspectRatio(
                aspectRatio: 12 / 8,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: FractionalOffset.topCenter,
                      image: NetworkImage(imageLink),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Container(
                margin: postMargins,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        postTitle,
                        style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      widget.location != null && widget.location!.isNotEmpty
                          ? Column(
                              children: [
                                const Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                ),
                                Text(
                                  widget.location!,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: Text(
                    widget.description ?? "",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  )),
              Ratings(
                rating: rating,
              ),
            ],
          )),
    ]);
  }
}

class Ratings extends StatefulWidget {
  const Ratings(
      {Key? key,
      this.rating = 1,
      this.beanSize = 30,
      this.widtFactor = 0.6,
      this.setRating,
      this.isButton = false})
      : super(key: key);

  final int rating;
  final double beanSize;
  final double widtFactor;
  final bool isButton;
  final Function(int)? setRating;

  @override
  State<Ratings> createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  // double beanSize = 30;
  double ratingMargin = 10;
  int rating = 3;

  var beanChildren = <Widget>[];

  void getBeans({void Function()? onPressed}) {
    // rating = rating != widget.rating ? widget.rating : rating;

    setState(() {
      rating = widget.rating;
    });
    beanChildren.clear();
    for (var i = 0; i < 5; i++) {
      beanChildren.add(
        SizedBox(
          child: widget.isButton
              ? IconButton(
                  key: ValueKey(i),
                  onPressed: () {
                    setState(() {
                      rating = i;
                      widget.setRating != null ? widget.setRating!(i) : null;
                    });
                  },
                  icon: SvgPicture.asset(
                    'assets/score-bean.svg',
                    color: i <= rating ? Colors.black : Colors.white,
                    width: widget.beanSize,
                    height: widget.beanSize,
                  ),
                  iconSize: widget.beanSize,
                )
              : SvgPicture.asset(
                  'assets/score-bean.svg',
                  color: i <= rating ? Colors.black : Colors.white,
                  width: widget.beanSize,
                  height: widget.beanSize,
                ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    getBeans();
    return Container(
      margin: EdgeInsets.all(ratingMargin),
      alignment: Alignment.bottomLeft,
      child: FractionallySizedBox(
        widthFactor: widget.widtFactor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: beanChildren,
            ),
          ],
        ),
      ),
    );
  }
}
