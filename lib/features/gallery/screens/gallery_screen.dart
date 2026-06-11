import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/api/gallery_service.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<dynamic> _albums = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchData(); }
  Future<void> _fetchData() async {
    final result = await GalleryService.getGallery();
    if (result['success'] == true && mounted) setState(() { _albums = result['data']; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 24, mainAxisSpacing: 24, childAspectRatio: 0.85),
            itemCount: _albums.length,
            itemBuilder: (context, index) {
              final album = _albums[index];
              final photos = album['photos'] as List<dynamic>? ?? [];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AlbumDetailScreen(album: album, photos: photos))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStackedFolderPreview(photos),
                    const SizedBox(height: 12),
                    Text(album['album_name'], textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('${photos.length} items', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildStackedFolderPreview(List<dynamic> photos) {
    if (photos.isEmpty) return const Icon(Icons.folder_open, size: 80, color: Colors.black26);
    return SizedBox(
      height: 100, width: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (photos.length > 2) Transform.rotate(angle: 0.15, child: _buildThumb(photos[2]['file_path'])),
          if (photos.length > 1) Transform.rotate(angle: -0.10, child: _buildThumb(photos[1]['file_path'])),
          _buildThumb(photos[0]['file_path']),
        ],
      ),
    );
  }

  Widget _buildThumb(String path) {
    return Container(
      width: 80, height: 80,
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(2, 2))],
        border: Border.all(color: Colors.white, width: 3),
        image: DecorationImage(image: NetworkImage('https://alumni.recordly.ng/uploads/gallery/$path'), fit: BoxFit.cover),
      ),
    );
  }
}

class AlbumDetailScreen extends StatelessWidget {
  final Map<String, dynamic> album;
  final List<dynamic> photos;
  const AlbumDetailScreen({super.key, required this.album, required this.photos});

  void _openFullScreen(BuildContext context, int initialIndex) {
    showDialog(
      context: context, useSafeArea: false,
      builder: (_) => FullScreenViewer(photos: photos, initialIndex: initialIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(album['album_name'])),
      body: photos.isEmpty 
          ? const Center(child: Text('This album is empty', style: TextStyle(color: Colors.black54)))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _openFullScreen(context, index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: DecorationImage(image: NetworkImage('https://alumni.recordly.ng/uploads/gallery/${photos[index]['file_path']}'), fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class FullScreenViewer extends StatefulWidget {
  final List<dynamic> photos;
  final int initialIndex;
  const FullScreenViewer({super.key, required this.photos, required this.initialIndex});
  @override
  State<FullScreenViewer> createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<FullScreenViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  Future<void> _downloadImage() async {
    final path = widget.photos[_currentIndex]['file_path'];
    final url = Uri.parse('https://alumni.recordly.ng/uploads/gallery/$path');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not download image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return InteractiveViewer(
                panEnabled: true, minScale: 0.5, maxScale: 4.0,
                child: Image.network('https://alumni.recordly.ng/uploads/gallery/${widget.photos[index]['file_path']}', fit: BoxFit.contain),
              );
            },
          ),
          Positioned(
            top: 40, left: 16,
            child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 32), onPressed: () => Navigator.pop(context)),
          ),
          Positioned(
            top: 40, right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
              child: Text('${_currentIndex + 1} / ${widget.photos.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          Positioned(
            bottom: 40, right: 24,
            child: FloatingActionButton(
              backgroundColor: AppTheme.brandPrimary,
              onPressed: _downloadImage,
              child: const Icon(Icons.download, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
