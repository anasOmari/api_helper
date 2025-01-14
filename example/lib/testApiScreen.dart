import 'package:api_request_helper/api_helper.dart';
import 'package:flutter/material.dart';

class Testapiscreen extends StatefulWidget {
  const Testapiscreen({super.key});

  @override
  State<Testapiscreen> createState() => _TestapiscreenState();
}

class _TestapiscreenState extends State<Testapiscreen> {
  late ApiHelper apiHelper;
  List<dynamic> data = [];

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiHelper = ApiHelper(environments: {'test': 'https://jsonplaceholder.typicode.com'},currentEnvironment: 'test');

    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await apiHelper.fetchAllData('/posts');
      setState(() {
        data = result;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test API Helper"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
            children: [
              Container(
                height: 500,
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return ListTile(
                        title: Text(item['title']),
                        subtitle: Text("ID: ${item['id']}"),
                      );
                    }),
              ),
            ],
          ),
    );
  }
}
