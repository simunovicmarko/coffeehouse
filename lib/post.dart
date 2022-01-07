import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  Color postBgColor = const Color(0xFFD8AEAE);

  String imageLink =
      "https://erestaurantconsulting.ca/wp-content/uploads/2019/04/Restaurant-Performance-Measurement-1080x675.jpg";

  String postName = "Bob's coffee";
  double beanSize = 30;
  double ratingMargin = 10;
  double mainMargin = 5;
  int rating = 3;
  double fontSize = 24.0;
  EdgeInsets postMargins = const EdgeInsets.fromLTRB(5, 10, 5, 0);
  EdgeInsets postNameMargins = const EdgeInsets.fromLTRB(25, 10, 0, 0);

  String apiKey = "AIzaSyA2fzQ7U_Kisoh4JCPjmIFKxGmVCIh9OKQ";

  Future<LocationData> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return Future.error("Could not get location");
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error("Could not get location");
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }

  Future<http.Response> fetchGeocoding(double? lat, double? lon) {
    return http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$apiKey'));
  }

  Future<String> getCityName() async {
    try {
      LocationData locationData = await getLocation();

      http.Response geoCoding =
          await fetchGeocoding(locationData.latitude, locationData.longitude);

      print(geoCoding.body);
    } catch (e) {}
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // getCityName();
    return Wrap(children: [
      Container(
          color: postBgColor,
          margin: postMargins,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image(image: NetworkImage(imageLink)),
              Container(
                margin: postMargins,
                child: Text(
                  postName,
                  style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Ratings(
                rating: rating,
              )
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
      this.isButton = false})
      : super(key: key);

  final int rating;
  final double beanSize;
  final double widtFactor;
  final bool isButton;
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
                  color: i < rating ? Colors.black : Colors.white,
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
