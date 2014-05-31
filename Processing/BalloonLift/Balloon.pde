// hot air balloon simulator, good to 20,000 m
//
// pacific spaceflight, http://pacificspaceflight.com
// mit open source software license
// robby kraft

// some typical balloon dimensions:
//   17m diameter
//   200kg weight (100kg envelope alone)

float PI = 3.14159265358979323846264338;
float R  = 287.04;  // real gas constant for air, m^2/Ksec^2

class Balloon{
    Atmosphere a;
    float altitude;
    float mass;
    float weight;
    float volume;
    float temperature;      // ambient_internal_balloon_temperature   (Tg)
    float drag_coef;        // coefficient of drag, .4 for most hot air balloons
    float S;                // horizontal cross sectional area of balloon at maximum diameter
    float velocity;         // vertical velocity (U)
    float acceleration;     // vertical acceleration (a)    
    // prove that these are necessary
    float density;
//    float pressure;   // NOPE this is always the same as outside

    float netForce;
private
    float L;    // aerostatic lift
    float G;    // gross weight
    float I;    // 50% additional or virtual air mass (see paper)
    float D;    // aerodynamic drag

public

  Balloon(float balloon_mass_kg, float balloon_diameter_m, float internal_temperature_c){
//  balloon_mass_kg: what is normally called "weight" even though it is technically mass. a person's mass is ~70kg

    a = new Atmosphere();
    
    altitude = 0.0;
    mass = balloon_mass_kg;
    weight = balloon_mass_kg * 9.8;   //TODO: during updates, make sure to recalculate this at every step since gravity changes
    S = pow(balloon_diameter_m * .5, 2)*PI;  // AREA: PI*R^2
    volume = pow(balloon_diameter_m * .5, 3) * 4 / 3. * PI;  // VOLUME: 4/3*PI*r^3
    temperature = internal_temperature_c;
    drag_coef = 0.44;          //  also try .4    http://en.wikipedia.org/wiki/Drag_coefficient
    
    velocity = 0.0;
    acceleration = 0.0;
  }
  void update_vertical_motion(float times_per_second){    
    a.atmosphereAtAltitude(altitude);
    L = volume * a.density * (1 - a.temperature / temperature);                 // aerostatic lift
//    D = .5 * drag_coef * (a.density / a.gravity) * pow(velocity, 2) * S;    // aerodynamic drag
    G = mass*a.gravity;// fuck! or is it b->mass;                                  // gross weight
    I = 1.5 * volume * a.density / a.gravity * acceleration;    // 50% additional or virtual air mass (see paper)
    D = .5 * drag_coef * a.density * pow(velocity, 2) * S;  //½CDρV2A  // aerodynamic drag

    if(L-G > 0) ; // D = D;  // D is subtracted
    else if(L-G < 0) D = -D; // D is added
 
    netForce = L - G - D;
    float accel = netForce/mass;
    
    acceleration = accel/times_per_second;
    velocity += acceleration/times_per_second;
    if(altitude > 0 || velocity > 0)
        altitude += velocity/times_per_second;    
  }
  void log(){
    println("\n\n******** BALLOON *********");
    println("* MASS: " + mass);
    println("* VOLUME: " + volume);
    println("* HORIZONTAL CROSS SECTIONAL AREA: " + S);
    println("* DRAG COEFFICIENT: " + drag_coef);
    println("- WEIGHT: " + weight);
    println("- ALTITUDE: " + altitude);
    println("- TEMPERATURE: " + temperature);
    println("- VELOCITY: " + velocity);
    println("- ACCELERATION: " + acceleration);
    println("##### VERTICAL MOTION #####");
    println("### L: " + L);
    println("### D: " + D);
    println("### G: " + G);
    println("### I: " + I);  
  }
};

