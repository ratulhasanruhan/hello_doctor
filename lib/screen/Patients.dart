import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:hello_doctor/model/HealthCardModel.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../utils/calculateTIme.dart';
import '../utils/colors.dart';

class Patients extends StatefulWidget {
  const Patients({Key? key}) : super(key: key);

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {

  var searchQuery = '';
  bool searchOn = false;

  Color statusColor(status){
    if(status == 'pending'){
      return Colors.amber;
    }else if(status == 'confirmed'){
      return Colors.green;
    }else if(status == 'rejected'){
      return Colors.red;
    }
    return Colors.black87;
  }

  var allQ = FirebaseFirestore.instance.collection('health_card').where('doctor', isEqualTo: Hive.box('user').get('phone')).orderBy('date', descending: true)
      .withConverter<HealthCardModel>(
  fromFirestore: (snapshot, _) => HealthCardModel.fromJson(snapshot.data()!),
  toFirestore: (data, _) => data.toJson(),
  );
  
  @override
  Widget build(BuildContext context) {

    var searchQ = FirebaseFirestore.instance.collection('health_card').where('doctor', isEqualTo: Hive.box('user').get('phone')).where('phone', isGreaterThanOrEqualTo: searchQuery)
        .withConverter<HealthCardModel>(
      fromFirestore: (snapshot, _) => HealthCardModel.fromJson(snapshot.data()!),
      toFirestore: (data, _) => data.toJson(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        title: searchOn
            ? TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          style: TextStyle(
            color: Colors.white,
          ),
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search by phone',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            border: InputBorder.none,
          ),
        )
            : Text(
            'Health Card',
          style: TextStyle(
              color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchOn = !searchOn;
              });
            },
            icon: Icon(searchOn ? FeatherIcons.x:FeatherIcons.search),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FirestoreListView<HealthCardModel>(
        query: searchQuery == '' ? allQ : searchQ,
        itemBuilder: (context, snapshot) {
          HealthCardModel data = snapshot.data();

          return   Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2,
              color: Colors.white,
              shadowColor: waterColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            data.photo,
                            height: 120.h,
                            width: 100.w,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              'Phone: ' +data.phone,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'NID: ' +data.nid,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),

                            Text(
                              'Type: ' +data.type,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              'Viewed: ' +data.viewed.toString(),
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )

                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card Created: ' + DateFormat('dd-MM-yyyy').format(data.date.toDate()) + '  ('+ calculateTimeDifference(startDate: data.date.toDate(), endDate: DateTime.now()).replaceAll('-', '') +' আগে)',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          Text(
                            'Address: ' + data.address,
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Status: ' + data.status,
                            style: TextStyle(
                              color: statusColor(data.status),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          data.viewed == 0 ? Text(
                            'Last visited: ' + 'Not Visited Yet',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ) : Text(
                            'Last visited: ' + DateFormat('dd-MM-yyyy').format(data.lastDate.toDate()) + '  ('+ calculateTimeDifference(startDate: data.lastDate.toDate(), endDate: DateTime.now()).replaceAll('-', '') +' আগে)',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
