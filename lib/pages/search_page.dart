import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SearchedAddres {
  String name;
  late String formattedAddress;
  late double lat;
  late double lng;

  SearchedAddres(this.name, this.formattedAddress,this.lat,this.lng);
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  final Dio _dio = Dio(); // Dio 인스턴스 생성
  List<SearchedAddres> searchedAddress = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black.withOpacity(0.01), // Scaffold의 배경색을 반 투명하게 설정
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
        child: Center(
            child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // 검색창 배경색
                borderRadius: searchedAddress.isEmpty
                    ? BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),

                // 모서리 둥글게
                boxShadow: [
                  // 그림자 효과
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                onChanged: (value) => _searchAddress(),
                onSubmitted: (value) => _searchAddress(),
                decoration: InputDecoration(
                  hintText: 'Enter an address',
                  suffixIcon: IconButton(
                    onPressed: () => _searchAddress(),
                    icon: Icon(Icons.search),
                  ), // 검색 아이콘
                  border: InputBorder.none, // 테두리 없애기
                ),
              ),
            ),
            // Text(_response),
            Expanded(
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchedAddress.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context, searchedAddress[index]);
                        },
                        title: Text(searchedAddress[index].name),
                        subtitle: Text(searchedAddress[index].formattedAddress),
                      ),
                      
                      // decoration: index == searchedAddress.length - 1
                      //     ? BoxDecoration(
                      //         borderRadius: BorderRadius.only(
                      //           bottomLeft: Radius.circular(10),
                      //           bottomRight: Radius.circular(10),
                      //         ),
                      //       )
                      //     : BoxDecoration(),
                    );
                  },
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  void _searchAddress() async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/textsearch/json',
        queryParameters: {
          'query': _controller.text,
          'key':
              'AIzaSyC8wLLyw_26SoLNnnUwdimZ5NXNhdAwGNA', // 여기에 실제 API 키를 넣으세요

          'language': 'ko',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _response = response.data['results'].toString();
          searchedAddress.clear();
          for (var i = 0; i < response.data['results'].length && i < 7; i++) {
            searchedAddress.add(SearchedAddres(
              response.data['results'][i]['name'],
              response.data['results'][i]['formatted_address'],
              response.data['results'][i]['geometry']['location']['lat'],
              response.data['results'][i]['geometry']['location']['lng'],
            ));
          }
        });
      } else {
        setState(() {
          _response = 'Error fetching results: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }
}
