// hot air balloon simulator, good to 20,000 m
//
// pacific spaceflight, http://pacificspaceflight.com
// mit open source software license

float ALT = 0.0;
float PFM;
float BET;
float VOLUME_F, VOLUME_M;
float PSI;
float BFORCE;
float BDENSITY;
float VELOCITY;
float MASS;
float R = 287.04;  // real gas constant for air, m^2/Ksec^2

float ACCEL;
float DRAGFORCE;

#define PI      3.14159265358979323846264338

#include "standard_atmosphere.c"

typedef struct HotAirBalloon HotAirBalloon;
struct HotAirBalloon{
    double altitude;
    float mass_or_weight;   // M or G
    float volume;           // V
    float ambient_internal_balloon_temperature;           // (Tg)
    float ambient_air_temperature;  // standard_atmosphere   (Ta)
    float ambient_air_density;      // standard_atmosphere   (wa)
    float coefficient_of_drag;      // Cd
    float g;  // standard_atmosphere   (acceleration due to gravity)
    float vertical_velocity;  // U
    float S; // horizontal cross sectional area of balloon at maximum diameter
    float a; // vertical acceleration
    float m; // mass
};

HotAirBalloon makeHotAirBalloon(float balloon_mass_km, float balloon_diameter_m, float internal_temperature_c){
    HotAirBalloon balloon;
    balloon.m = balloon_mass_km;
    balloon.S = powf(balloon_diameter_m*.5,2)*PI;  // AREA: PI*R^2
    balloon.ambient_internal_balloon_temperature = internal_temperature_c;
    return balloon;
}

//   L + G + D + I = 0
//
//  L = V wa (1 - Ta / Tg)
//  D = .5 Cd (wa / g) U^2 S
//  I = ma
//  G = gross weight excluding weight of lifting gas
//

float getVelocity(HotAirBalloon *balloon){
//    0 =    V * wa * (1 - Ta / Tg)      +       .5 * Cd * (wa / g) * U^2 * S     +      ma       +      mg
    float velocity      =  sqrtf(    ( balloon->volume * wa * (1 - Ta / Tg)      +      ma       +      mg  )  / (-.5 * Cd * (wa / g) *  S)     )
    return velocity;
}


void setup_balloon(){

    // SETUP VARIABLES
    BET = atmosphere.T;
//  BET = 60.0; // nah, fuck pre-heating.
    MASS = 500;  //kg
    VOLUME_F = 75000;  // f^3
    VOLUME_M = 2777;   // m^3
    VELOCITY = 0;
}
void updateOnce(){  // called once per second
// any calculation which involves units in something/seconds

    // BALLOON ON GROUND. CANNOT GO DOWN FURTHER
    if(ALT <= 0.0 && ACCEL < 0){
      VELOCITY = 0;
      ACCEL = 0;
    }
    VELOCITY += ACCEL;
    // incorporate drag
    float coef = .44;   // http://en.wikipedia.org/wiki/Drag_coefficient
    float area = 18000;
    float dynamic_viscosity = .1; // Pa*s, pascal second, or kg/(m*s), or (N*s)/m^2,
    DRAGFORCE = .5 * atmosphere.p * (VELOCITY*VELOCITY) * coef * area;
    DRAGFORCE = .5*sqrt(VELOCITY);
    if(DRAGFORCE != 0) DRAGFORCE = 1/DRAGFORCE;
    VELOCITY = VELOCITY * DRAGFORCE;
    ALT += VELOCITY;
}
void update(){  // called every frame (unreliable rate, though measured into "fps")
  
    // DEVICE INPUT
    view.update();
  
    if(FIRE) BET+=random(.01,.5);
    if(VENT) BET-=random(.01,.5);
    
    // UPDATE CALCULATIONS
    atmosphere.update(ALT);
    // convert atmosphere pressure back to pa
    BDENSITY = (atmosphere.p * 6894.75728)/(R*(BET+273.15));  // kg/m^3
//  BPSI = 101325 * pow(1 - (0.0065 * ALT / (BET+273.15)), 5.2561 );
//  BPSI *= 0.000145037738;
    BFORCE = -(BDENSITY-atmosphere.density) * VOLUME_M;  // in kilograms
    //*2.20462 kilograms to pounds
    float Fg = -(BDENSITY-atmosphere.density) * 9.8 * 4/3. * 3.14159 * VOLUME_M;
    float NETFORCE = (BFORCE-MASS)*9.8;

    ACCEL = (NETFORCE) / MASS;
  
//  VELOCITY = sqrt( 8* 15 * 9.8 / (3 * .44) * ( 1 - (3*MASS/(4*3.14159*(atmosphere.density-BDENSITY)*VOLUME_M) ) ) );

    float coef = .44;   // http://en.wikipedia.org/wiki/Drag_coefficient
    float area = 18000;
    float dynamic_viscosity = .1; // Pa*s, pascal second, or kg/(m*s), or (N*s)/m^2,
    DRAGFORCE = .5 * atmosphere.p * (VELOCITY*VELOCITY) * coef * area;

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

void draw(){
    currentSecond = second();
    if(lastSecond != currentSecond){
        lastSecond = currentSecond;
        elapsedSeconds++;
        fps = (frameCount-lastFrameCount);
        lastFrameCount = frameCount;
        updateOnce();
//    println(elapsedSeconds + ": Frames:" + fps + "/sec");
    }
    update();
    view.draw();
}

void mousePressed(){
  mouseDown = true;
}

void mouseReleased(){
  mouseDown = false;
}
