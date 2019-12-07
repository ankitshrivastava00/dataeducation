class Institute{
   String  id,name,city,state,country,pincode;

  Institute(this.id,this.name,this.city,this.state,this.country,this.pincode);

  /*factory Institute.fromJson(Map<String, dynamic> json) {
    return new Institute(
      id: json['id'].toString(),
      name: json['name'].toString(),
      city: json['city'].toString(),
      state: json['state'].toString(),
      country: json['country'].toString(),
      pincode: json['pincode'].toString(),
    );
  }*/
}