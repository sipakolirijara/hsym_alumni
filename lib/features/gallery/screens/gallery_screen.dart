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
    if (result['success'] == true && mounted) {
      setState(() { _albums = result['data']; _isLoading = false; });
    }
  }

  Future<void> _downloadImage(String path) async {
    final url = Uri.parse('https://alumni.recordly.ng/uploads/gallery/$path');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alumni Gallery')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _albums.length,
            itemBuilder: (context, index) {
              final album = _albums[index];
              final photos = album['photos'] as List<dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(album['album_name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      itemBuilder: (context, pIndex) {
                        final photo = photos[pIndex];
                        return GestureDetector(
                          onTap: () => _downloadImage(photo['file_path']),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage('https://alumni.recordly.ng/uploads/gallery/${photo['file_path']}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.download, color: Colors.black87, shadows: [Shadow(color: Colors.black, blurRadius: 2)])),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
    );
  }
}
