import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/properties_provider.dart';
import '../../widgets/property_card.dart';
import '../property/property_detail_screen.dart';

class AllPropertiesScreen extends ConsumerStatefulWidget {
  final String? status;
  final String? type;
  final String? category;

  const AllPropertiesScreen({
    super.key,
    this.status,
    this.type,
    this.category,
  });

  @override
  ConsumerState<AllPropertiesScreen> createState() => _AllPropertiesScreenState();
}

class _AllPropertiesScreenState extends ConsumerState<AllPropertiesScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchTimer;

  bool _isLoadingMore = false;
  bool _isInitialLoad = true;
  int _currentPage = 1;
  bool _hasMore = true;
  List<dynamic> _allProperties = [];
  String _searchKeyword = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProperties();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMore && _searchKeyword.isEmpty) {
        _loadMoreProperties();
      }
    }
  }

  String _getImageUrl(dynamic imageData) {
    const baseUrl = "https://makazi.nono.co.tz/uploads/";
    const fallbackImage =
        "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c";

    if (imageData == null) {
      return fallbackImage;
    }

    String? imagePath;

    if (imageData is Map) {
      imagePath = imageData['url'] ?? imageData['image'] ?? imageData['path'];
    } else if (imageData is String) {
      imagePath = imageData;
    } else if (imageData is List && imageData.isNotEmpty) {
      return _getImageUrl(imageData.first);
    }

    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith("http")) {
        return imagePath;
      }
      return "$baseUrl$imagePath";
    }

    return fallbackImage;
  }

  void _searchProperty(String value) {
    _searchTimer?.cancel();
    _searchTimer = Timer(
      const Duration(milliseconds: 400),
      () {
        if (mounted) {
          setState(() {
            _searchKeyword = value.toLowerCase();
          });
        }
      },
    );
  }

  List<dynamic> get filteredProperties {
    if (_searchKeyword.isEmpty) {
      return _allProperties;
    }

    return _allProperties.where((property) {
      final title = property['title']?.toString().toLowerCase() ?? "";
      final description = property['description']?.toString().toLowerCase() ?? "";
      final location = property['ward']?['name']?.toString().toLowerCase() ?? "";
      final district = property['ward']?['district']?['name']?.toString().toLowerCase() ?? "";
      final region = property['ward']?['district']?['region']?['name']?.toString().toLowerCase() ?? "";
      final category = property['category']?['name']?.toString().toLowerCase() ?? "";
      final status = property['status']?.toString().toLowerCase() ?? "";

      return title.contains(_searchKeyword) ||
          description.contains(_searchKeyword) ||
          location.contains(_searchKeyword) ||
          district.contains(_searchKeyword) ||
          region.contains(_searchKeyword) ||
          category.contains(_searchKeyword) ||
          status.contains(_searchKeyword);
    }).toList();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isInitialLoad = true;
      _isLoadingMore = true;
    });

    try {
      final notifier = ref.read(paginatedPropertiesProvider.notifier);
      await notifier.loadProperties(
        page: 1,
        limit: 20,
        status: widget.status,
        type: widget.type,
        category: widget.category,
      );

      if (!mounted) return;

      final state = ref.read(paginatedPropertiesProvider);
      state.when(
        data: (properties) {
          setState(() {
            _allProperties = List.from(properties);
            _currentPage = 1;
            _hasMore = properties.length == 20;
            _isInitialLoad = false;
            _isLoadingMore = false;
          });
        },
        loading: () {
          setState(() {
            _isInitialLoad = false;
            _isLoadingMore = false;
          });
        },
        error: (error, stack) {
          setState(() {
            _isInitialLoad = false;
            _isLoadingMore = false;
          });
          _showErrorSnackBar(error.toString());
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialLoad = false;
          _isLoadingMore = false;
        });
        _showErrorSnackBar(e.toString());
      }
    }
  }

  Future<void> _loadMoreProperties() async {
    if (_isLoadingMore || !_hasMore || _searchKeyword.isNotEmpty) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final notifier = ref.read(paginatedPropertiesProvider.notifier);
      final response = await notifier.loadMoreProperties(
        page: nextPage,
        limit: 20,
        status: widget.status,
        type: widget.type,
        category: widget.category,
      );

      if (!mounted) return;

      setState(() {
        if (response['success'] == true) {
          final newProperties = response['data'] ?? [];
          _allProperties.addAll(newProperties);
          _hasMore = newProperties.length == 20;
          _currentPage = nextPage;
        }
        _isLoadingMore = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        _showErrorSnackBar('Failed to load more properties');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final propertiesState = ref.watch(paginatedPropertiesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(
          widget.category != null
              ? 'Properties in ${widget.category}'
              : widget.status != null
                  ? '${widget.status} Properties'
                  : widget.type != null
                      ? '${widget.type} Properties'
                      : 'All Properties',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: _searchProperty,
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchKeyword = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(propertiesState),
    );
  }

  Widget _buildBody(AsyncValue<List<dynamic>> propertiesState) {
    if (_isInitialLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    final displayProperties = filteredProperties;

    return propertiesState.when(
      data: (properties) {
        if (displayProperties.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  _searchKeyword.isNotEmpty
                      ? 'No results found for "$_searchKeyword"'
                      : widget.category != null
                          ? 'No properties in ${widget.category}'
                          : 'No properties found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                if (_searchKeyword.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Try adjusting your search terms',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadProperties,
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: displayProperties.length + (_hasMore && _searchKeyword.isEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == displayProperties.length && _hasMore && _searchKeyword.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final property = displayProperties[index];
              final imageUrl = _getImageUrl(property['images']);

              return PropertyCard(
                image: imageUrl,
                title: property['title'] ?? "Property",
                price: property['price']?.toString() ?? "0",
                status: property['status'] ?? "Available",
                propertyData: property,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PropertyDetailScreen(
                        property: property,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load properties',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadProperties,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}