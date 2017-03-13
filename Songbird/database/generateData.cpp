#include <iostream>
#include <string>
#include <fstream>
#include <stdlib.h>

using namespace std;

int main() {
  ofstream out;
  out.open("load_data.sql");

  out << "INSERT INTO sampleInfo (sampleid, deviceid, added, latitude, longitude, humidity, temp, light, type1, per1, type2, per2, type3, per3)\nvalues\n";

  string birds[] = {"American Robin", "American Goldfinch", "Blue Jay", "Black-capped Chickadee", "American Crow", "Tufted Titmouse", "Northern Cardinal", "House Sparrow"};

  for (int i = 0; i < 100; i++) {
    if (i != 0) out << ",\n";

    int dev = rand() % 101;
    double lat = (double)rand() / RAND_MAX * 90;
    double lon = (double)rand() / RAND_MAX * 180;
    if ((dev > 25 && dev <= 50) || (dev > 75))
      { lat = 0 - lat; }
    if (dev > 50)
      { lon = 0 - lon; }

    int hum = rand() % 101;
    double tem = (double)rand() / RAND_MAX * 120;
    double lig = (double)rand() / RAND_MAX;

    int spe1 = rand() % 8;
    swap(birds[0], birds[spe1]);
    double typ1 = (double)rand() / RAND_MAX;
    int spe2 = rand() % 7 + 1;
    swap(birds[1], birds[spe1]);
    double typ2 = (double)rand() / RAND_MAX;
    int spe3 = rand() % 6 + 1;
    swap(birds[2], birds[spe1]);
    double typ3 = (double)rand() / RAND_MAX;

    string b1 = birds[0];
    string b2 = birds[1];
    string b3 = birds[2];

    out << "(" << i << "," << dev << ",CURRENT_TIMESTAMP," << lat << "," << lon << "," << hum << "," << tem << "," << lig << ",'" << birds[0] << "'," << typ1 << ",'" << birds[1] << "'," << typ2 << ",'" << birds[2] << "'," << typ3 << ")";
  }
  out << ";";

  out.close();
  return 0;
}