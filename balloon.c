// hot air balloon simulator, good to 20,000 m
//
// pacific spaceflight, http://pacificspaceflight.com
// mit open source software license


// some typical balloon dimensions:
//   17m diameter
//   200kg weight (100kg envelope alone)

#include "standard_atmosphere.c"  // most recent version at: https://github.com/PacificSpaceflight/ISA

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
    
    float net_force = L-(G+D+I);
    float MA = L - G - .5 * b->drag_coef * a.density * powf(b->velocity, 2) * b->S; //½CDρV2A
    float accel = MA/b->mass;
    
    printf("##### VERTICAL MOTION #####\n");
    printf("### L: %.3f\n",L);
    printf("### D: %.3f\n",D);
    printf("### G: %.3f\n",G);
    printf("### I: %.3f\n",I);
//    printf("### NET: %.3f\n", net_force);
    
//    if(net_force > 0){
        b->acceleration = accel;
        b->velocity += b->acceleration;
    if(b->altitude > 0 || b->velocity > 0)
        b->altitude += b->velocity;
//    }
    
    // but really L + G + D + I = 0   should be    L = G + D + I
    // "aerostatic lift is balanced by drag, inertia, and weight"
    
//    b->velocity = sqrtf( (b->volume * a.density * (1 - a.temperature / b->temperature) + b->mass*a.gravity + 1.5 * b->volume * a.density / a.gravity * b->acceleration ) / (-.5 * b->drag_coef * (a.density / a.gravity) *  b->S) );
}

void updateOneSecond(HotAirBalloon *b){  // called once per second
// any calculation which involves units in something/seconds

    atmosphere a = atmosphereAtAltitude(b->altitude);
    
    // BALLOON ON GROUND. CANNOT GO DOWN FURTHER
    if(b->altitude <= 0.0 && b->velocity < 0){
      b->velocity = 0;
      b->acceleration = 0;
    }
    b->velocity += b->acceleration;
    // incorporate drag

    float dynamic_viscosity = .1; // Pa*s, pascal second, or kg/(m*s), or (N*s)/m^2,
    float DRAGFORCE = .5 * a.pressure * powf(b->velocity, 2) * b->drag_coef * b->S;
    DRAGFORCE = .5*sqrt(b->velocity);
    if(DRAGFORCE != 0) DRAGFORCE = 1/DRAGFORCE;
    b->velocity *= DRAGFORCE;
    b->altitude += b->velocity;
}

void update(HotAirBalloon *b){  // called every frame (unreliable rate, though measured into "fps")
  
//    if(FIRE) BET+=random(.01,.5);
//    if(VENT) BET-=random(.01,.5);
    
    atmosphere a = atmosphereAtAltitude(b->altitude);
    // convert atmosphere pressure back to pa
    b->density = (a.pressure * 6894.75728)/(R*(b->temperature+273.15));  // kg/m^3
//    BPSI = 101325 * pow(1 - (0.0065 * ALT / (BET+273.15)), 5.2561 );
//    BPSI *= 0.000145037738;
    float buoyant_force = -(b->density-a.density) * b->volume;  // in kilograms
    //*2.20462 kilograms to pounds
//    float Fg = -(BDENSITY-atmosphere.density) * 9.8 * 4/3. * 3.14159 * VOLUME_M;
//    float NETFORCE = (BFORCE-MASS)*9.8;

//    ACCEL = (NETFORCE) / MASS;
  
//  VELOCITY = sqrt( 8* 15 * 9.8 / (3 * .44) * ( 1 - (3*MASS/(4*3.14159*(atmosphere.density-BDENSITY)*VOLUME_M) ) ) );

    float dynamic_viscosity = .1; // Pa*s, pascal second, or kg/(m*s), or (N*s)/m^2,
    float DRAGFORCE = .5 * a.pressure * powf(b->velocity, 2) * b->drag_coef * b->S;

  // http://www.engineeringtoolbox.com/air-absolute-kinematic-viscosity-d_601.html
  // imperial units (feet)
  // air kinematic viscosity = 1.26 x 10^-4
  // air dynamic viscosity   = 3.38 x 10^-7
  // metric:
  // 1.983 x 10-5
  // this one might be better
  // http://www.engineeringtoolbox.com/dynamic-absolute-kinematic-viscosity-d_412.html
    float mu = 15;
  // settling velocity units in feet
//  SETTLINGVELOCITY = (2 * (BDENSITY-atmosphere.density) * 9.8 * area) / (9*mu);
}

