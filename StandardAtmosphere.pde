float NUMBER_E = 2.718281828;
int radiusEarth = 6371000; // meters, for calculating gravity
// 0.014503773773, convert hPa to psi

class StandardAtmosphere{  
public
  float a;  // speed of sound, m/sec
  float g;  // acceleration of gravity m/sec^2
  float h = 0;  // altitude, m or ft
  float p;  // pressure, psi
  float T;  // C (288.15 in K)  // K or C
  float density; // density, kg/m^3
  float R = 287.04;  // real gas constant for air, m^2/Ksec^2
  StandardAtmosphere(){
    setMeanSeaLevelConditions();
  }
  void setMeanSeaLevelConditions(){
      p = p0;   T = T0;   a = a0;
      g = g0;   density = density0;
  }
  void update(float altitude){
    h = altitude;
    if(h < 11000){ // meters, (36,089 ft)
      T = T0 - 6.5 * (float)h / 1000.0; // T = T0 - 1.98 * float(h) / 1000.0;// in ft
      p = p0 * pow(1 - (0.0065 * h / (T0+273.15)), 5.2561 );  // pressure in pa
    }
    else{  // above the troposphere
      T = -56.5;  // C, or 216.65 K
      p = 226.32 * pow(NUMBER_E, -g*(h-11000)/(R*216.65));  // pressure in pa
    }
    density = p/(R*(T+273.15));
    println("PRES: " + p);
    println("DENS: " + density);
    a = 331 + ( 0.6 * T );
    g = g0 * pow( (float)radiusEarth/(radiusEarth+h), 2);
    p *= 0.000145037738;  // convert pa to psi
  }
  void printStats(int xPos, int yPos){
    int fontSize = 16;
    text("altitude: " + (int(h*10)/10.0) + " m  " + (int(h*32.808)/10.0) + " ft", xPos, yPos + 1*fontSize);
    text("temperature: " + (int(T*1000)/1000.0) + " C", xPos, yPos + 2*fontSize);
    text("pressure: " + (int(p*1000)/1000.0) + " psi", xPos, yPos + 3*fontSize);
    text("density: " + (int(density*1000)/1000.0) + " kg/m^3", xPos, yPos + 4*fontSize);
    text("gravity: " + (int(g*1000)/1000.0) + " m/sec^2", xPos, yPos + 5*fontSize);
    text("speed of sound: " + (int(a*1000)/1000.0) + " m/sec", xPos, yPos + 6*fontSize);
  }

private
  float a0 = 340.294;
  float g0 = 9.80665; 
  float p0 = 101325;
  float T0 = 15; 
  float density0 = 1.225; 
}
