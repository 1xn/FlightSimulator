// international standard atmosphere, good to 20,000 m
//
// pacific spaceflight, http://pacificspaceflight.com
// mit open source software license

float EARTH_RADIUS = 6371000.0;   // meters
float REAL_GAS_CONSTANT = 287.04; // earth air, m^2/Ksec^2
float E = 2.71828182845904523536028747135266250;
float METERS_TO_FEET = 3.28083989501312;
float HPA_TO_PSI = 0.014503773773;

// CONDITIONS AT ALTITUDE 0
float SEA_LEVEL_PRESSURE = 1013.25;
float SEA_LEVEL_TEMPERATURE = 15;
float SEA_LEVEL_GRAVITY = 9.80665;
float SEA_LEVEL_DENSITY = 1.225;
float SEA_LEVEL_SPEED_OF_SOUND = 340.294;

class Atmosphere{
  float  temperature;    // celsius (288.15 in K)
  float  pressure;       // psi  (101325 N/m^2) or (1013.25 hPa)
  float  density;        // kg/m^3
  float  gravity;        // m/sec^2
  float  speed_of_sound; // m/sec

  void atmosphereAtAltitude(float altitude){
    if(altitude < 0.0 || altitude > 20000.0) println("ERROR: ALTITUDE EXCEEDING ACCEPTABLE RANGE");   // calculations only valid between sea level and 20,000m
    gravity = SEA_LEVEL_GRAVITY * pow( EARTH_RADIUS / (EARTH_RADIUS+altitude), 2);
    if(altitude < 11000.0){ // meters, (36,089 ft)
        temperature = SEA_LEVEL_TEMPERATURE - 6.5 * altitude / 1000.0; // -= 1.98 * altitude / 1000.0; if using feet
        pressure = SEA_LEVEL_PRESSURE * pow(1 - (0.0065 * altitude / (SEA_LEVEL_TEMPERATURE+273.15)), 5.2561 );
    }
    else{  // above the troposphere
        temperature = -56.5;  // C, or 216.65 K
        pressure = 226.32 * pow(E, -gravity*(altitude-11000)/(REAL_GAS_CONSTANT*216.65));
    }
    density = pressure/(REAL_GAS_CONSTANT*(temperature+273.15))*100.0;
    speed_of_sound = 331 + ( 0.6 * temperature );
    pressure *= HPA_TO_PSI;
  }
  float speedOfSoundAtAltitude(float altitude){
    if(altitude < 0.0 || altitude > 20000.0)
        return -1;
    else if(altitude < 11000.0)
        return 331 + ( 0.6 * (SEA_LEVEL_TEMPERATURE - 6.5 * altitude / 1000.0) );
    else
        return 331 + ( 0.6 * -56.5 );
  }
  float gravityAtAltitude(float altitude){
    return SEA_LEVEL_GRAVITY * pow( EARTH_RADIUS / (EARTH_RADIUS+altitude), 2);
  }
  float temperatureAtAltitude(float altitude){
    if(altitude < 0.0 || altitude > 20000.0)
        return -1;
    else if(altitude < 11000.0)
        return SEA_LEVEL_TEMPERATURE - 6.5 * altitude / 1000.0;
    else
        return -56.5;
  }
  float pressureAtAltitude(float altitude){
    if(altitude < 0.0 || altitude > 20000.0)
        return -1;
    else if(altitude < 11000.0)
        return SEA_LEVEL_PRESSURE * pow(1 - (0.0065 * altitude / ((SEA_LEVEL_TEMPERATURE-(6.5*altitude/1000.0) )+273.15)), 5.2561 ) * HPA_TO_PSI;
    else
        return 226.32 * pow(E, -(SEA_LEVEL_GRAVITY * pow( EARTH_RADIUS / (EARTH_RADIUS+altitude), 2))*(altitude-11000)/(REAL_GAS_CONSTANT*216.65)) * HPA_TO_PSI;
  }
  float densityAtAltitude(float altitude){
    float t = SEA_LEVEL_TEMPERATURE;
    float p = SEA_LEVEL_PRESSURE;
    float g = SEA_LEVEL_GRAVITY;
    if(altitude < 0.0 || altitude > 20000.0)
        return -1;
    else if(altitude < 11000.0){
        t -= 6.5 * altitude / 1000.0;
        p *= pow(1 - (0.0065 * altitude / (SEA_LEVEL_TEMPERATURE+273.15)), 5.2561 );
    }
    else{
        t = -56.5;
        p = 226.32 * pow(E, -g*(altitude-11000)/(REAL_GAS_CONSTANT*216.65));
    }
    return p/(REAL_GAS_CONSTANT*(t+273.15))*100.0;
  }
};
