import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  //These methods performs CRUD operations

  //1.CREATE USER
  Future addUserDetails(
     Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }
//2.READ USER DETAILS
  Future<Stream<QuerySnapshot>> getUserDetails() async {
    return await FirebaseFirestore.instance.collection("users").snapshots();
  }
//UPDATE
Future updateUserDetails(String uid, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance.collection("Employee").doc(uid).update(updateInfo);
}


//DELETE USER DETAILS
  Future deleteUserDetails(String uid) async {
    return await FirebaseFirestore.instance.collection("Employee").doc(uid).delete();
  }


}
//create controllers for any data you want to perform CRUD operations
//button to register user
/*
* ElevatedButton(
* onPressed: ()async{
* string Id=randomAlphaNumeric(10);
* Map<String, dynamic> userInfoMap = {
* "Name":nameController.text,
* "Age":ageController.text,
* "id":Id,
* "Location":locationController.text,
* };
* await DatabaseMethods().addUserInfo(userInfoMap, Id)-then add fluttertoast;
*}
* ),
*
*
* */

//READ operation

//StreamBuilder fetches all the data from firebase
//at the app state level declare this
   /*
   * Stream? UsersStream;
   * Widget allUserDetails(){
   *return StreamBuilder(
   * builder: (context, AsyncSnapshot snapshot){
   * return snapshot.hasData? ListView.builder(itemBuilder:(context, index){}): Container();
   *});
   * //then pass stream and get the list/count of all docs present
   * return StreamBuilder(
   * stream: UsersStream,
   * builder: (context, AsyncSnapshot snapshot){
   * return snapshot.hasData? ListView.builder(
   * itemCount: snapshot.data.docs.length,
   * itemBuilder:(context, index){
   * DocumentSnapshot ds=snapshot.data.docs[index];
   * return Material(
   *   elevation: 5.0,
   * borderRadius: BorderRadius.circular(10),
   * child: Container(
   * child: Column(
   * children:[
   * Row(
   * Text("Name:" +ds["Name"]),
   * GestureDetector(
   * onTap:(){
   * nameController.text=ds["Name"];
   * ageController.text=ds["Age"];
   * locationController.text=ds["Location"];
   * EditUserDetails(ds["Id"]);
   *}
   *Icon(Icons.edit,))
   * ),
   *
   * Text("Age:" +ds["Age"]),
   * Text("Location:"+ds["Location"]),
   * ],
   * ),
   * ),
   * ),
   * }): Container();
   *});
   *}
   * //after all these steps create a method on state level
   *
   *   getOnTheLoad() async{
   *    usersStream = await DatabaseMethods().getUserDetails();
   *    setState((){
   * });
   * }
   *@override              //init state is the first function that is called when the app launches
   * void initState(){
   * getOnTheLoad();
   * super.initState();
   * }
   *
   *
   * //on the body call allUserDetails() method
   *
   * body: Container(
   * margin: EdgeInsets.only(left:20.0, right:20.0, top:30.0),
   * child: Column(
   * children:[
   *   Expanded(
   * child: allUserDetails(),
   * )
   * ]
   * )
   * )
   *
   * */

//UPDATE operation

/*
* Future EditUserDetails(String id)=>showDialog(context: context, builder:(context)=>alertDialog(
* content:Container(
* child:Column(
* children:[
* Row(
* Text("Edit details"),
* Icon(Icons.cancel), //wrap with a gestureDetector onTap Navigator.pop(context);
* ),//end Row
*
* //Text widgets with details
* pass controllers to the text-fields as well
* Text()
*  //update button
* ElevatedButton(onPressed:() async {
* Map<String, dynamic>updateInfo={
* "Name":nameController.text,
* "Age":ageController.text,
* "Id": id,
* "Location": locationController.text,
* };
* await DatabaseMethods().updateUserDetails(id, updateInfo).then((value){
* Navigator.pop(context);
* });
*
* })
*
*
* ]
* )
* )
*
* ));
*
*
*
* */
//Delete Operation
/*  delete Icon
GestureDetector(
onTap:()async{
await DatabaseMethods().deleteUserDetails(ds[id])
}
child:Icon(Icons.delete)),
*
*
* */



