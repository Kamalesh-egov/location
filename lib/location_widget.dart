import 'package:flutter/material.dart';
import 'location_model.dart';

class LocationWidget extends StatefulWidget {
  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final List<Location> _locations = [
    Location('Amsterdam', 'NetherLands'),
    Location('Bangalore', 'India'),
    Location('Chennai', 'India'),
    Location('Delhi', 'India'),
    Location('Kiev', 'Ukraine'),
    Location('Kiev', 'United Kingdom'),
    Location('Krakow', 'Poland'),
    Location('Mumbai', 'India'),
    Location('Not Provided', 'Canada'),
    Location('Not Provided', 'China'),
    Location('Not Provided', 'India'),
    Location('Not Provided', 'Poland'),
    Location('Not Provided', 'Russia'),
    Location('Seoul', 'Korea'),
    Location('Shangai', 'China'),
    Location('Toronto', 'Canada'),
    Location('Zurich', 'Switzerland'),
  ];

  late List<Location> _filteredLocations;
  String _searchTerm = '';
  bool _isMinimized = false;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _filteredLocations = _locations;  // Initialize _filteredLocations in initState
  }

  void _filterLocations(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
      _filteredLocations = _locations
          .where((location) => location.toString().toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  void _scrollToLetter(String letter) {
    final index = _filteredLocations.indexWhere((location) => location.city.startsWith(letter));
    if (index != -1) {
      _scrollController.jumpTo(index * _itemHeight);
    }
  }

  final ScrollController _scrollController = ScrollController();
  final double _itemHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    if (_isMinimized) {
      return _buildMinimizedView();
    } else if (_isCollapsed) {
      return _buildCollapsedView();
    } else {
      return _buildNormalView();
    }
  }

  Widget _buildNormalView() {
    return Container(
      width: 300,
      height: 600,
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: Padding(
        padding: EdgeInsets.all(10), // Adjust the padding as needed for internal content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildSearchBox(),
            SizedBox(height: 10), // Example of spacing between search box and content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _filteredLocations.length,
                      itemBuilder: (context, index) {
                        final location = _filteredLocations[index];
                        return ListTile(
                          title: Text(location.toString()),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20), // Adjust width as needed
                  Container(
                    width: 20, // Adjust width as needed
                    child: _buildAlphabetIndex(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildMinimizedView() {
    return Container(
      color: Colors.grey[300],
      width: 300,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Locations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.tablet_sharp),
              onPressed: () {
                setState(() {
                  _isMinimized = false;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _isCollapsed = true;
                  _isMinimized = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedView() {
    return Container(
      width: 70,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: Column(
        children: [
          IconButton(
            icon: Icon(Icons.keyboard_tab_rounded),
            onPressed: () {
              setState(() {
                _isCollapsed = false;
              });
            },
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Transform.rotate(
              angle: -90 * 3.1415926535897932 / 180,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                    'Locations',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Locations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.minimize),
          onPressed: () {
            setState(() {
              _isMinimized = true;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isCollapsed = true;
            });
          },
        ),
      ],
    );
  }

Widget _buildSearchBox() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      color: Colors.white,
      height: 45,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter locations',
                border: OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: _filterLocations,
            ),
          ),
        ],
      ),
    ),
  );
}

  List<String> _getAlphabetIndex() {
    final Set<String> letters = _filteredLocations
        .map((location) => location.city[0].toUpperCase())
        .toSet();
    final List<String> sortedLetters = letters.toList()..sort();
    return sortedLetters;
  }

  Widget _buildAlphabetIndex() {
    final letters = _getAlphabetIndex();
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: letters.length,
        itemBuilder: (context, index) {
          final letter = letters[index];
          return GestureDetector(
            onTap: () => _scrollToLetter(letter),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(letter),
            ),
          );
        },
      ),
    );
  }
}
