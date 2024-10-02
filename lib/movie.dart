class Movie {
  String title;
  String poster;
  String year;
  Movie(this.title, this.poster, this.year);

  //Convertendo um Json para Movie
  static Movie fromJson(Map<String, dynamic> json) {
    return Movie(json['Title'], json['Poster'], json['Year']);
  }
}
