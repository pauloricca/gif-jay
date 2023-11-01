color toRGB(final color h, final color s, final color b) {
  return toRGB(h, s, b, 255);
}

color toRGB(final color h, final color s, final color b, final color a) {
  pushStyle();
  colorMode(HSB, 360, 100, 100, 255);
  final color rgb = color(h, s, b, a);
  popStyle();
  return rgb;
}
