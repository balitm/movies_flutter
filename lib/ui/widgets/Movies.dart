import 'package:flutter/material.dart';
import 'package:movies/model/HTTPSession.dart';
import 'package:movies/ui/ViewModel/MoviesCollectionViewModel.dart';

const _kRatio = 0.7; // 1 / 1.5;
const _kPlaceholder = 'assets/images/noimage2.png';

class Movies extends StatefulWidget {
  Movies({Key? key}) : super(key: key);

  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  final _viewModel = MoviesCollectionViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final data = MediaQuery.of(context);
    final width = data.devicePixelRatio * data.size.width / 2;
    _viewModel.start(1, width.ceilToDouble().toInt());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return StreamBuilder<NowPlaying>(
      stream: _viewModel.nowPlaying,
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return _grid(context, snapshot.data!);
        }
      }),
    );
  }

  Widget _grid(BuildContext context, NowPlaying nowPlaying) {
    final data = MediaQuery.of(context);
    var width = data.size.width / 2;
    var height = width / _kRatio;

    double round(double value) {
      return (value * data.devicePixelRatio).roundToDouble() /
          data.devicePixelRatio;
    }

    width = round(width);
    height = round(height);

    return GridView.builder(
      itemCount: nowPlaying.results.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: _kRatio,
      ),
      itemBuilder: ((_, index) {
        final uri = nowPlaying.results[index].uri;
        if (uri == null) {
          return Container(
            width: width,
            height: height,
            color: Colors.yellow,
          );
        }
        print('show img from ${uri.toString()}');
        return FadeInImage.assetNetwork(
          placeholder: _kPlaceholder,
          image: uri.toString(),
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      }),
    );
  }
}
