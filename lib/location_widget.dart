import 'package:flutter/material.dart';
import 'location_model.dart';

class LocationWidget extends StatefulWidget {
  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final List<Location> _locations = [
    Location('New York', 'USA'),
    Location('Los Angeles', 'USA'),
    Location('Chicago', 'USA'),
    Location('Houston', 'USA'),
    Location('Phoenix', 'USA'),
    Location('Berlin', 'Germany'),
    Location('Munich', 'Germany'),
    Location('Hamburg', 'Germany'),
    // Add more locations as needed
  ];

  late List<Location> _filteredLocations;  // Use 'late' keyword for delayed initialization
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
    return Column(
      children: [
        _buildHeader(),
        _buildSearchBox(),
        _buildAlphabetIndex(),
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
      ],
    );
  }

  Widget _buildMinimizedView() {
    return Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
        icon: Icon(Icons.expand),
        onPressed: () {
          setState(() {
            _isMinimized = false;
          });
        },
      ),
    );
  }

  Widget _buildCollapsedView() {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          IconButton(
            icon: Icon(Icons.expand),
            onPressed: () {
              setState(() {
                _isCollapsed = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
        ),
        onChanged: _filterLocations,
      ),
    );
  }

  Widget _buildAlphabetIndex() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 26,
        itemBuilder: (context, index) {
          final letter = String.fromCharCode(65 + index);
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
