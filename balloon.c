// hot air balloon simulator, good to 20,000 m
//
// pacific spaceflight, http://pacificspaceflight.com
// mit open source software license


// some typical balloon dimensions:
//   17m diameter
//   200kg weight (100kg envelope alone)

#include "standard_atmosphere.c"  // get the most recent version at: github.com/PacificSpaceflight/

#define PI  3.14159265358979323846264338
#define R   287.04  // real gas constant for air, m^2/Ksec^2

typedef struct HotAirBalloon HotAirBalloon;
struct HotAirBalloon{
    double altitude;
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
};

//  balloon_mass_kg: what is normally called "weight" even though it is technically mass. a person's mass is ~70kg

HotAirBalloon makeHotAirBalloon(float balloon_mass_kg, float balloon_diameter_m, float internal_temperature_c){
    HotAirBalloon balloon;
    
    balloon.altitude = 0.0;
    balloon.mass = balloon_mass_kg;
    balloon.weight = balloon_mass_kg * 9.8;   //TODO: during updates, make sure to recalculate this at every step since gravity changes
    balloon.S = powf(balloon_diameter_m * .5, 2)*PI;  // AREA: PI*R^2
    balloon.volume = powf(balloon_diameter_m * .5, 3) * 4 / 3. * PI;  // VOLUME: 4/3*PI*r^3
    balloon.temperature = internal_temperature_c;
    balloon.drag_coef = 0.44;          //  also try .4    http://en.wikipedia.org/wiki/Drag_coefficient
    
    balloon.velocity = 0.0;
    balloon.acceleration = 0.0;
    return balloon;
}

void logHotAirBalloon(HotAirBalloon *b){
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

//½

//   L + G + D + I = 0
//
//  L = V wa (1 - Ta / Tg)
//  D = .5 Cd (wa / g) U^2 S
//  I = ma
//  G = gross weight excluding weight of lifting gas
//

void updateVerticalMotion(HotAirBalloon *b){
    
    atmosphere a = atmosphereAtAltitude(b->altitude);
    
//    0 =    V * wa * (1 - Ta / Tg)      +       .5 * Cd * (wa / g) * U^2 * S     +      ma       +      mg
    
//    0 = b->volume*a.density*(1-a.temperature/b->temperature) + .5*b->drag_coef*(a.density/a.gravity)*powf(velocity,2)*b->S + b->mass*accel + b->mass*a.gravity;

//    U   =    sqrtf(    ( balloon->volume * wa * (1 - Ta / Tg)      +      ma       +      mg  )  / (-.5 * Cd * (wa / g) *  S)     )

    float L = b->volume * a.density * (1 - a.temperature / b->temperature);                 // aerostatic lift
    float D = .5 * b->drag_coef * (a.density / a.gravity) * powf(b->velocity, 2) * b->S;    // aerodynamic drag
    float G = b->mass*a.gravity;// fuck! or is it b->mass;                                  // gross weight
    float I = 1.5 * b->volume * a.density / a.gravity * b->acceleration;    // 50% additional or virtual air mass (see paper)

    float D2 = .5 * b->drag_coef * a.density * powf(b->velocity, 2) * b->S;  //½CDρV2A  // aerodynamic drag

    if(L-G > 0) ;              // D is subtracted
    else if(L-G < 0) D2 = -D2; // D is added
    
    float netForce = L - G - D2;

    float accel = netForce/b->mass;
    
    printf("##### VERTICAL MOTION #####\n");
    printf("### L: %.3f\n",L);
    printf("### D: %.3f\n",D);
    printf("### G: %.3f\n",G);
    printf("### I: %.3f\n",I);
//    printf("### NET: %.3f\n", net_force);
    
    b->acceleration = accel;
    b->velocity += b->acceleration;
    if(b->altitude > 0 || b->velocity > 0)
        b->altitude += b->velocity;
    
    // but really L + G + D + I = 0   should be    L = G + D + I
    // "aerostatic lift is balanced by drag, inertia, and weight"
    
//    b->velocity = sqrtf( (b->volume * a.density * (1 - a.temperature / b->temperature) + b->mass*a.gravity + 1.5 * b->volume * a.density / a.gravity * b->acceleration ) / (-.5 * b->drag_coef * (a.density / a.gravity) *  b->S) );
}

