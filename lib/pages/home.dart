import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/pages/category_products.dart';
import 'package:ecom/pages/product_detail.dart';
import 'package:ecom/services/database.dart';
import 'package:ecom/services/shared_pref.dart';
import 'package:ecom/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  List categories = [
    "images/headphone_icon.png",
    "images/laptop.png",
    "images/watch.png",
    "images/TV.png",
  ];

  List categoryName = [
    'Headphones',
    'Laptop',
    'Watch',
    'TV',
  ];

  var queryRequestSet = [];
  var tempSearchStore = [];
  TextEditingController searchController = TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryRequestSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryRequestSet.length == 0 && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; i++) {
          queryRequestSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryRequestSet.forEach((element) {
        if (element['UpdatedName'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  String? name, image;
  bool isLoading = true;

  getTheSharedPref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  onTheLoad() async {
    await getTheSharedPref();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  Future<List<DocumentSnapshot>> fetchAllProducts() async {
    List<String> collections = ['Headphones', 'Laptops', 'Watches', 'TV'];
    List<DocumentSnapshot> allProducts = [];

    for (String collection in collections) {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(collection).get();
      allProducts.addAll(snapshot.docs);
    }

    return allProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xfff2f2f2),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.black,
                size: 50,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hey, " + name!,
                              style: AppStyle.boldTextFieldStyle(),
                            ),
                            Text(
                              "Good Morning",
                              style: AppStyle.lightTextFieldStyle(),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            image!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          initiateSearch(value.toUpperCase());
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Products",
                          hintStyle: AppStyle.lightTextFieldStyle(),
                          prefixIcon: search
                              ? GestureDetector(
                                  onTap: () {
                                    search = false;
                                    tempSearchStore = [];
                                    queryRequestSet = [];
                                    searchController.text = "";
                                    setState(() {});
                                  },
                                  child: Icon(Icons.close),
                                )
                              : Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    search
                        ? ListView(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList())
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Categories",
                                    style: AppStyle.semiBoldTextFieldStyle(),
                                  ),
                                  Text(
                                    "See all",
                                    style: TextStyle(
                                      color: Color(0xFFfd6f3e),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    padding: EdgeInsets.all(20),
                                    height: 130,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFfd6f3e),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        "All",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.zero,
                                      height: 130,
                                      child: ListView.builder(
                                          itemCount: categories.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return CategoryTile(
                                              image: categories[index],
                                              name: categoryName[index],
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "All Products",
                                    style: AppStyle.semiBoldTextFieldStyle(),
                                  ),
                                  Text(
                                    "See all",
                                    style: TextStyle(
                                      color: Color(0xFFfd6f3e),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                height: 240,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: FutureBuilder<List<DocumentSnapshot>>(
                                  future: fetchAllProducts(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    var products = snapshot.data!;

                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        var product = products[index].data()
                                            as Map<String, dynamic>;

                                        return GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(image: product['Image'], name: product['Name'], price: product['Price'], detail: product['Description']),));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 200,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Image.network(
                                                    product['Image'],
                                                    height: 150,
                                                    width: 150,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      product['Name'],
                                                      style: AppStyle
                                                          .semiBoldTextFieldStyle(),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "\$${product['Price']}",
                                                        style: TextStyle(
                                                          color: Color(0xFFfd6f3e),
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Color(0xFFfd6f3e),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                    image: data["Image"],
                    name: data["Name"],
                    price: data["Price"],
                    detail: data["Description"])));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20),
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  data['Image'],
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                )),
            SizedBox(
              width: 20,
            ),
            Text(
              data["Name"],
              style: AppStyle.semiBoldTextFieldStyle(),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String image, name;
  CategoryTile({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProducts(
                      category: name,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.all(20),
        height: 90,
        width: 90,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              fit: BoxFit.cover,
            ),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
