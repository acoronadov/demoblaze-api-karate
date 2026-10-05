function fn() {
  karate.configure('connectTimeout', 15000);
  karate.configure('readTimeout', 15000);
  return { baseUrl: 'https://api.demoblaze.com' };
}
