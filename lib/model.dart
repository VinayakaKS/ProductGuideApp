class data {
  final List<String> toxic;
  final String recommendation;

  const data({required this.toxic, required this.recommendation});

  factory data.fromJson(Map<String, dynamic> json) {
    return data(
        recommendation: json["Recommendation"],
        toxic: json['Toxic'].cast<String>());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Toxic'] = toxic;
    data['Recommendation'] = recommendation;
    return data;
  }
}
