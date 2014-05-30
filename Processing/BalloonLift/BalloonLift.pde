float ALT = 0.0;
float PFM;
float BET;
float VOLUME_F, VOLUME_M;
float PSI;
float BFORCE;
float BDENSITY;
float VELOCITY;
int currentSecond, lastSecond, elapsedSeconds, fps, lastFrameCount;
int fontSize;
float MASS;
boolean mouseDown;
boolean FIRE, VENT;
float R = 287.04;  // real gas constant for air, m^2/Ksec^2
float button1X, button1Y, button1H, button1W, button2X, button2Y, button2W, button2H;
float ACCEL;
float DRAGFORCE;

StandardAtmosphere atmosphere;
View view;

void setup(){
  // SETUP GRAPHICS ONLY
  view = new View(800,600);
  
  frameRate(15);  // 15 incase running on old computers
  
  atmosphere = new StandardAtmosphere();

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
