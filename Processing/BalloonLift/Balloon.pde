// hot air balloon simulator, good to 20,000 m
//
// pacific spaceflight, http://pacificspaceflight.com
// mit open source software license
// robby kraft


//////////////////////
//TODO:
// cannot vent to below the OAT
// LIFT and DRAG negative signs, arrow boxes
//

float R  = 287.04;  // real gas constant for air, m^2/Ksec^2
int FREQ = 30;  // simulator updates per second

class Balloon{
    Atmosphere a;
    float altitude;
    float mass;
    float mass_air;
    float weight;
    float volume;
    float temperature;      // ambient_internal_balloon_temperature   (Tg)
    float drag_coef;        // coefficient of drag, .4 for most hot air balloons
    float S;                // horizontal cross sectional area of balloon at maximum diameter
    float velocity;         // vertical velocity (U)
    float acceleration;     // vertical acceleration (a)    
    // prove that these are necessary
    float density;
    float diameter;
//    float pressure;   // NOPE this is always the same as outside

    float forceLift;
    float forceDrag;

public

  void loadBalloon(Balloon c){
    altitude = c.altitude;
    mass = c.mass;
    weight = c.weight;
    volume = c.volume;
    temperature = c.temperature;      // ambient_internal_balloon_temperature   (Tg)
    drag_coef = c.drag_coef;        // coefficient of drag, .4 for most hot air balloons
    S = c.S;                // horizontal cross sectional area of balloon at maximum diameter
    velocity = c.velocity;         // vertical velocity (U)
    acceleration = c.acceleration;     // vertical acceleration (a)    
    // prove that these are necessary
    density = c.density;
    diameter = c.diameter;
//    float pressure;   // NOPE this is always the same as outside
  }
  
  Balloon(float balloon_mass_kg, float balloon_diameter_m, float internal_temperature_c){
//  balloon_mass_kg: what is normally called "weight" even though it is technically mass. a person's mass is ~70kg

    a = new Atmosphere();
    
    altitude = 0.0;
    mass = balloon_mass_kg;
    weight = balloon_mass_kg * 9.8;   //TODO: during updates, make sure to recalculate this at every step since gravity changes
    diameter = balloon_diameter_m;
    S = pow(balloon_diameter_m * .5, 2)*PI;  // AREA: PI*R^2
    volume = pow(balloon_diameter_m * .5, 3) * 4 / 3. * PI;  // VOLUME: 4/3*PI*r^3
    temperature = internal_temperature_c;
    drag_coef = 0.44;          //  also try .4    http://en.wikipedia.org/wiki/Drag_coefficient
    
    density = (a.pressure/HPA_TO_PSI)/(287.058*(temperature+273.15))*100.0;
    velocity = 0.0;
    acceleration = 0.0;
  }

  void update_vertical_motion(float times_per_second){

    a.atmosphereAtAltitude(altitude);

    density = (a.pressure/HPA_TO_PSI)/(287.058*(temperature+273.15))*100.0;
    mass_air = volume * density;

    forceLift = (volume * a.density - (mass + mass_air) ) * a.gravity;               // force free lift
    forceDrag = .5 * drag_coef * a.density * pow(velocity, 2) * S;  //½CDρV2A  // aerodynamic drag
    if(velocity < 0) forceDrag = -forceDrag;
  
    float newVelocity;
    float _inside = 8 * (diameter*.5) * 9.8 / (3*drag_coef) * (1 - 3*(mass+mass_air)/(4*3.14159*a.density*pow((diameter*.5),3) ) );
    if(_inside < 0) newVelocity = -sqrt( -_inside );
    else newVelocity = sqrt( _inside );

    acceleration = newVelocity-velocity;
    velocity = newVelocity;

    if(altitude > 0 || velocity > 0){
      altitude += velocity/times_per_second;  
    }
    else if(velocity < 0){
      velocity = 0;
    }
    else{
      altitude = 0;  
    }
  }
  
  void predict_vertical_motion(float times_per_second, int elapsedSeconds){
    for(int i = 0; i < elapsedSeconds; i++){
      temperature += (-.0025)*times_per_second;   
      a.atmosphereAtAltitude(altitude);

      density = (a.pressure/HPA_TO_PSI)/(287.058*(temperature+273.15))*100.0;
      mass_air = volume * density;
      forceLift = (volume * a.density - (mass + mass_air) ) * a.gravity;               // force free lift

      forceDrag = .5 * drag_coef * a.density * pow(velocity, 2) * S;  //½CDρV2A  // aerodynamic drag
      if(velocity < 0) forceDrag = -forceDrag;
      
      float newVelocity;
      float _inside = 8 * (diameter*.5) * 9.8 / (3*drag_coef) * (1 - 3*(mass+mass_air)/(4*3.14159*a.density*pow((diameter*.5),3) ) );
      if(_inside < 0) newVelocity = -sqrt( -_inside );
      else newVelocity = sqrt( _inside );

      acceleration = newVelocity-velocity;
      velocity = newVelocity;

      if(altitude > 0 || velocity > 0){
        altitude += velocity/times_per_second;  
      }
      else if(velocity < 0){
        velocity = 0;
      }
      else{
        altitude = 0;  
      }
    }
  }

  void log(){
    println("\n\n******** BALLOON *********");
//    println("* MASS: " + mass);
//    println("* VOLUME: " + volume);
//    println("* HORIZONTAL CROSS SECTIONAL AREA: " + S);
//    println("* DRAG COEFFICIENT: " + drag_coef);
    println("- WEIGHT: " + weight);
    println("- ALTITUDE: " + altitude);
    println("- TEMPERATURE: " + temperature);
    println("- VELOCITY: " + velocity);
    println("- ACCELERATION: " + acceleration);
    println("##### VERTICAL MOTION #####");
    println("### LIFT: " + forceLift);
    println("### DRAG: " + forceDrag); 
    println("### LIFT-DRAG: " + (forceLift-forceDrag));  

  }
};

