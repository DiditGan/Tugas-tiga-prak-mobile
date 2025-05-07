import 'package:flutter/material.dart';
import 'package:tugas_tiga_prak/models/anime_model.dart';
import 'package:tugas_tiga_prak/presenters/anime_presenters.dart';
import 'package:tugas_tiga_prak/views/detail_page.dart';

class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({super.key});

  @override
  State<AnimeListScreen> createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen>
    implements AnimeView {
  late AnimePresenter _presenter;
  bool _isLoading = false;
  List<Anime> _animeList = [];
  String? _errorMessage;
  String _currentEndpoint = "akatsuki";

  @override
  void initState() {
    super.initState();
    _presenter = AnimePresenter(this);
    _presenter.loadAnimeData(_currentEndpoint);
  }

  void _fetchdata(String endpoint) {
    setState(() {
      _currentEndpoint = endpoint;
    });
    _presenter.loadAnimeData(_currentEndpoint);
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showAnimeList(List<Anime> animeList) {
    setState(() {
      _animeList = animeList;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Anime List"), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _fetchdata("akatsuki"),
                child: Text("Akatsuki"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _fetchdata("kara"),
                child: Text("Kara"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _fetchdata("characters"),
                child: Text("Characters"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(child: Text("Error: $_errorMessage"))
                    : ListView.builder(
                      itemCount: _animeList.length,
                      itemBuilder: (context, index) {
                        final anime = _animeList[index];
                        return ListTile(
                          leading: buildImage(anime.imageUrl),
                          title: Text(anime.name),
                          subtitle: Text(anime.familyCreator),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetailScreen(
                                      endpoint: _currentEndpoint,
                                      id: anime.id,
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
              "https://images.unsplash.com/photo-1541701494587-cb58502866ab?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            );
          },
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
      );
    }
  }
}