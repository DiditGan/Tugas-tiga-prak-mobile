import 'package:flutter/material.dart';
import 'package:tugas_tiga_prak/models/detail_model.dart';
import 'package:tugas_tiga_prak/networks/base_network.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final String endpoint;
  const DetailScreen({super.key, required this.id, required this.endpoint});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isLoading = true;
  AnimeDetail? _animeDetail;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetailData();
  }

  Future<void> _fetchDetailData() async {
    try {
      final data = await BaseNetwork.getDetailData(widget.endpoint, widget.id);
      setState(() {
        _animeDetail = AnimeDetail.fromJson(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Widget buildImage(String imageUrl) {
  return Card(
    elevation: 5,
    margin: EdgeInsets.only(bottom: 16),
    child: Image.network(
      imageUrl,
      width: 250,
      height: 250,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.network(
          "https://images.unsplash.com/photo-1541701494587-cb58502866ab?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          width: 250,
          height: 250,
          fit: BoxFit.cover,
        );
      },
    ),
  );
}

  Widget _buildMapSection(String title, Map<String, dynamic> mapData) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$title',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 6),
            mapData.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: mapData.entries.map((entry) {
                      final value = entry.value;
                      final displayValue = (value != null &&
                              value.toString().trim().isNotEmpty)
                          ? value.toString()
                          : "-";
                      return Text('${entry.key}: $displayValue');
                    }).toList(),
                  )
                : Text("-"),
          ],
        ),
      ),
    );
  }

  Widget _buildKekkeiGenkai(String? value) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kekkei Genkai",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 6),
            Text(value != null && value.trim().isNotEmpty ? value : "-"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Anime")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text("Error: $_errorMessage"))
              : _animeDetail != null
                  ? SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildImage(_animeDetail!.image),
                          SizedBox(height: 16),
                          Text(
                            _animeDetail!.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildMapSection("Family", _animeDetail!.family),
                          _buildMapSection("Debut", _animeDetail!.debut),
                          _buildKekkeiGenkai(_animeDetail!.kekkeiGenkai),
                        ],
                      ),
                    )
                  : Center(child: Text("No data available!")),
    );
  }
}