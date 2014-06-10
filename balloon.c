// hot air balloon simulator, good to 20,000 m
//
// pacific spaceflight, http://pacificspaceflight.com
// mit open source software license
// robby kraft

#include "standard_atmosphere.c"  // get the most recent version at: github.com/PacificSpaceflight/

#define PI  3.14159265358979323846264338
#define R   287.04  // real gas constant for air, m^2/Ksec^2

typedef struct balloon balloon;
struct balloon{
    double altitude;
    double mass;
    double mass_air;
    double weight;
    double volume;
    double temperature;      // ambient_internal_balloon_temperature   (Tg)
    double drag_coef;        // coefficient of drag, .4 for most hot air balloons
    double S;                // horizontal cross sectional area of balloon at maximum diameter
    double velocity;         // vertical velocity (U)
    double acceleration;     // vertical acceleration (a)
    
    double diameter;
    double density;
//    double pressure;   // NOPE this is always the same as outside
};


balloon make_balloon(double balloon_mass_kg, double balloon_diameter_m, double internal_temperature_c){
    //  balloon_mass_kg: what is normally called "weight" even though it is technically mass. a person's mass is ~70kg
    balloon b;
    b.altitude = 0.0;
    b.mass = balloon_mass_kg;
    b.weight = balloon_mass_kg * 9.8;   //TODO: during updates, make sure to recalculate this at every step since gravity changes
    b.S = pow(balloon_diameter_m * .5, 2)*PI;  // AREA: PI*R^2
    b.volume = pow(balloon_diameter_m * .5, 3) * 4 / 3. * PI;  // VOLUME: 4/3*PI*r^3
    b.temperature = internal_temperature_c;
    b.drag_coef = 0.44;          //  also try .4    http://en.wikipedia.org/wiki/Drag_coefficient
    b.velocity = 0.0;
    b.acceleration = 0.0;
    b.diameter = balloon_diameter_m;
    b.density = (1.22)/(287.058*(temperature+273.15))*100.0;
    return b;
}


#define FREQ 30  // simulator updates per second

void predict_vertical_motion(balloon *b, unsigned int elapsedSeconds){

    for(int i = 0; i < elapsedSeconds; i++){
        temperature -= 0.001*FREQ;
        atmosphere a = atmosphereAtAltitude(b->altitude);
        
        density = (a.pressure/HPA_TO_PSI)/(287.058*(temperature+273.15))*100.0;
        mass_air = volume * density;
        
        float newVelocity;
        float _inside = 8 * (diameter*.5) * 9.8 / (3*drag_coef) * (1 - 3*(mass+mass_air)/(4*3.14159*a.density*pow((diameter*.5),3) ) );
        if(_inside < 0) newVelocity = -sqrt( -_inside );
        else newVelocity = sqrt( _inside );
        
        acceleration = newVelocity-velocity;
        velocity = newVelocity;
        
        if(altitude > 0 || velocity > 0)
            altitude += velocity/FREQ;
        else if(velocity < 0)
            velocity = 0;
        else
            altitude = 0;
    }
}

void increment_vertical_motion(balloon *b){
    
    temperature -= 0.001;  //TODO: temperature leak
    atmosphere a = atmosphereAtAltitude(b->altitude);
    
    density = (a.pressure/HPA_TO_PSI)/(287.058*(temperature+273.15))*100.0;
    mass_air = volume * density;
   
    float newVelocity;
    float _inside = 8 * (diameter*.5) * 9.8 / (3*drag_coef) * (1 - 3*(mass+mass_air)/(4*3.14159*a.density*pow((diameter*.5),3) ) );
    if(_inside < 0) newVelocity = -sqrt( -_inside );
    else newVelocity = sqrt( _inside );
    
    acceleration = newVelocity-velocity;
    velocity = newVelocity;
    
    if(b->altitude > 0 || b->velocity > 0)
        b->altitude += b->velocity;
    else if(velocity < 0)
        velocity = 0;
    else
        altitude = 0;
}


void log_balloon(balloon *b){
    printf("******** BALLOON *********\n");
    printf("* MASS: %.1f\n", b->mass);
    printf("* VOLUME: %.2f\n", b->volume);
    printf("* HORIZONTAL CROSS SECTIONAL AREA: %.2f\n", b->S);
    printf("* DRAG COEFFICIENT: %.3f\n", b->drag_coef);
    printf("- WEIGHT: %.1f\n", b->weight);
    printf("- ALTITUDE: %.1f\n", b->altitude);
    printf("- TEMPERATURE: %.3f\n", b->temperature);
    printf("- VELOCITY: %.3f\n", b->velocity);
    printf("- ACCELERATION: %.3f\n", b->acceleration);
}
