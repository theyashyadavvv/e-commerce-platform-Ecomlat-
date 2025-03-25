import 'package:ecommerce_int2/app/user_and_seller/controller/userController.dart';
import 'package:ecommerce_int2/helper/base.dart';
import 'package:flutter/material.dart';
import '../../model/appointmentUserModel.dart';

class AppointmentUser extends StatelessWidget {
  static const routeName = "/AppointmentsUser";

  @override
  Widget build(BuildContext context) {
    final email = context.extra;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator. of(context). pop(),
        ),
        title: Text('Appointments'),
      ),
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: FutureBuilder(
                  future: UserController.getAppointments(email),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return  snapshot.data.isEmpty ? Center(
                        child: Text(
                              "No Pending Requests!",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                      ) :ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            AppointmentsUser appointments =
                                snapshot.data[index];

                            return Column(children: <Widget>[
                              ListTile(
                                title: Text(
                                  appointments.service,
                                  style: TextStyle(fontSize: 20),
                                ),
                                leading: Icon(
                                  Icons.people,
                                ),
                              ),
                              ListTile(
                                title: Text("Seller: ${appointments.seller}"),
                              ),
                              ListTile(
                                title: Text("Issue: ${appointments.issue}"),
                              ),
                              ListTile(
                                title: Text("Address: ${appointments.address}"),
                              ),
                              ListTile(
                                title: Text("Date: ${appointments.date}"),
                              ),
                              ListTile(
                                title: Text("Time: ${appointments.time}"),
                              ),
                              ListTile(
                                title: Text(
                                    "Mechanic Phone: ${appointments.mechanicPhone}"),
                              ),
                              Divider(),
                            ]);
                          });
                    } else {
                      Center(
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              top: 30,
                            ),
                            child: Text(
                              "No Pending Requests!",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )),
                      );
                    }
                    return CircularProgressIndicator.adaptive();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
