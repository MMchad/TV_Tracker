String getEpisodeTitle(int episodeNb, int seasonNb) {
  var title = "S";
  title = seasonNb < 10 ? "${title}0$seasonNb | E" : "$title$seasonNb | E";
  title = episodeNb < 10 ? "${title}0$episodeNb" : "$title$episodeNb";
  return title;
}
