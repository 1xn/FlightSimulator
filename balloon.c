// hot air balloon simulator, good to 20,000 m
//
// pacific spaceflight, http://pacificspaceflight.com
// mit open source software license
// robby kraft


// some typical balloon dimensions:
//   17m diameter
//   200kg weight (100kg envelope alone)

#include "standard_atmosphere.c"  // get the most recent version at: github.com/PacificSpaceflight/

#define PI  3.14159265358979323846264338
#define R   287.04  // real gas constant for air, m^2/Ksec^2

typedef struct balloon balloon;
struct balloon{
    double altitude;
    double mass;
    double weight;
    double volume;
    double temperature;      // ambient_internal_balloon_temperature   (Tg)
    double drag_coef;        // coefficient of drag, .4 for most hot air balloons
    double S;                // horizontal cross sectional area of balloon at maximum diameter
    double velocity;         // vertical velocity (U)
    double acceleration;     // vertical acceleration (a)
    
    
    // prove that these are necessary
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
    return b;
}


#define FREQ 30  // simulator updates per second

void predict_vertical_motion(balloon *b, unsigned int elapsedSeconds){
    atmosphere a = atmosphereAtAltitude(b->altitude);
    double L = b->volume * a.density * (1 - a.temperature / b->temperature);                 // aerostatic lift
//    double D = .5 * b->drag_coef * (a.density / a.gravity) * pow(b->velocity, 2) * b->S;   // aerodynamic drag
    double G = b->mass*a.gravity;// fuck! or is it b->mass;                                  // gross weight
    double I = 1.5 * b->volume * a.density / a.gravity * b->acceleration;    // 50% additional or virtual air mass (see paper)
    double D = .5 * b->drag_coef * a.density * pow(b->velocity, 2) * b->S;   //½CDρV2A       // aerodynamic drag
    if(L-G > 0) ; // D = D;  // D is subtracted
    else if(L-G < 0) D = -D; // D is added
    // "aerostatic lift is balanced by drag, inertia, and weight"
    double netForce = L - G - D;
    double accel = netForce/b->mass;
    for(int i = 0; i < elapsedSeconds*FREQ; i++){
        b->acceleration = accel/FREQ;
        if(b->altitude > 0 || b->acceleration > 0)
            b->velocity += b->acceleration/FREQ;
        else
            velocity = 0;
        
        if(b->altitude > 0 || b->velocity > 0)
            b->altitude += b->velocity/FREQ;
        else
            altitude = 0;
    }
}


//½

//   L + G + D + I = 0
//
//  L = V wa (1 - Ta / Tg)
//  D = .5 Cd (wa / g) U^2 S
//  I = ma
//  G = gross weight excluding weight of lifting gas
//

void update_vertical_motion(balloon *b){
    
    atmosphere a = atmosphereAtAltitude(b->altitude);
    
//    0 =    V * wa * (1 - Ta / Tg)      +       .5 * Cd * (wa / g) * U^2 * S     +      ma       +      mg
    
//    0 = b->volume*a.density*(1-a.temperature/b->temperature) + .5*b->drag_coef*(a.density/a.gravity)*pow(velocity,2)*b->S + b->mass*accel + b->mass*a.gravity;
    
//    U   =    sqrtf(    ( balloon->volume * wa * (1 - Ta / Tg)      +      ma       +      mg  )  / (-.5 * Cd * (wa / g) *  S)     )
    
    double L = b->volume * a.density * (1 - a.temperature / b->temperature);                 // aerostatic lift
    double D = .5 * b->drag_coef * (a.density / a.gravity) * pow(b->velocity, 2) * b->S;     // aerodynamic drag
    double G = b->mass*a.gravity;// fuck! or is it b->mass;                                  // gross weight
    double I = 1.5 * b->volume * a.density / a.gravity * b->acceleration;    // 50% additional or virtual air mass (see paper)
    
    double D2 = .5 * b->drag_coef * a.density * pow(b->velocity, 2) * b->S;  //½CDρV2A       // aerodynamic drag
    
    if(L-G > 0) ; // D2 = D2;  // D is subtracted
    else if(L-G < 0) D2 = -D2; // D is added
    
    // "aerostatic lift is balanced by drag, inertia, and weight"
    double netForce = L - G - D2;
    
    double accel = netForce/b->mass;
    
    b->acceleration = accel;
    if(b->altitude > 0 || b->acceleration > 0)
        b->velocity += b->acceleration;
    else
        velocity = 0;
    
    if(b->altitude > 0 || b->velocity > 0)
        b->altitude += b->velocity;
    else
        altitude = 0;

    printf("##### VERTICAL MOTION #####\n");
    printf("### L: %.3f\n",L);
    printf("### D: %.3f\n",D);
    printf("### G: %.3f\n",G);
    printf("### I: %.3f\n",I);
//    printf("### NET: %.3f\n", net_force);
    
    
//    b->velocity = sqrtf( (b->volume * a.density * (1 - a.temperature / b->temperature) + b->mass*a.gravity + 1.5 * b->volume * a.density / a.gravity * b->acceleration ) / (-.5 * b->drag_coef * (a.density / a.gravity) *  b->S) );
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
