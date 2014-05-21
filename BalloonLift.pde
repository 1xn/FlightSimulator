float ALT = 0.0;
float PFM;
float BET;
float VOLUME;
float BPSI;
float BFORCE;
float BDENSITY;
int currentSecond, lastSecond, elapsedSeconds, fps, lastFrameCount;
StandardAtmosphere atmosphere;
float textSize;
float PAYLOAD;
boolean mouseDown;
boolean FIRE, VENT;
  float R = 287.04;  // real gas constant for air, m^2/Ksec^2


void setup(){
  // SETUP GRAPHICS ONLY
  size(640,480);
  textSize = height*.09;
  frameRate(15);  // 15 incase running on old computers
  noStroke();
  // FONTS
  PFont mono = loadFont("TlwgTypewriter-Bold-48.vlw");
  textFont(mono);
  atmosphere = new StandardAtmosphere();
  
  // SETUP VARIABLES
  BET = atmosphere.T;
  PAYLOAD = 500;
  VOLUME = 1000;
}
void updateOnce(){  // called once per second

}
void update(){  // called every frame (unreliable rate, though measured into "fps")
  // DEVICE INPUT
  if(mousePressed && !mouseDown)
    mouseDown = true;
  else if(!mousePressed && mouseDown)
    mouseDown = false;
  if(mouseDown && mouseX > width*.7 && mouseX < width*.95 && mouseY > height*.4 && mouseY < height*.55)
    FIRE = true;
  else FIRE = false;
  if(mouseDown && mouseX > width*.7 && mouseX < width*.95 && mouseY > height*.575 && mouseY < height*.725)
    VENT = true;          
  else VENT = false;  
  if(FIRE) BET+=random(.01,.1);
  if(VENT) BET-=random(.01,.1);
  
  // UPDATE CALCULATIONS
  atmosphere.update(ALT);
  BDENSITY = 101325/(R*(BET+273.15));
  BPSI = 1013.25 * pow(1 - (0.0065 * ALT / (15+273.15)), 5.2561 );
  BPSI *= 0.014503773773;
  BFORCE = (BDENSITY-atmosphere.density) * 9.8 * VOLUME;
}
void drawScreen(){
  background(0);
  
  textSize(textSize);
  
  // LARGE TITLES
  fill(255);
  text(" ALT",width*.075, height/10.*1);
  text("APSI",width*.075, height/10.*2);
  text("BPSI",width*.075, height/10.*3);
  text(" OAT",width*.075, height/10.*4);
  text(" BET",width*.075, height/10.*5);
  text("DENS",width*.075, height/10.*6);
  // LARGE COLUMN WHITE BACKGROUNDS
  fill(255);
  for(int i = 0; i < 7; i++){
    rect(width*.25, height/40.+ height/10.*i, width*.33, height/11.0, height*.01);
  }
  // LARGE COLUMN VALUES
  fill(0);
  text(ALT, width*.25,height/10.*1);
  text(atmosphere.p,width*.25,height/10.*2);
  text(BPSI,width*.25,height/10.*3);
  text(atmosphere.T, width*.25,height/10.*4);
  text(BET, width*.25,height/10.*5);
  text(BDENSITY, width*.25,height/10.*6);

  // SMALL COLUMN VALUES
  textSize(textSize*.4);
  // CLOCK
  fill(255);
  rect(width*.7, height*.05, width*.25, height*.05, height*.005);
  text("HOUR : MIN : SEC", width*.7, height*.133);
  fill(0);
  text(int(elapsedSeconds/3600.) +" : "+ int(elapsedSeconds/60.) +" : "+ elapsedSeconds%60, width*.75, height*.0875);  
  // BUOYANT FORCE, PAYLOAD
  fill(255);
  rect(width*.7, height*.2, width*.25, height*.05, height*.005);
  text("BUOYANT / PAYLOAD", width*.7, height*.3);
  fill(0);
  text(int(BFORCE), width*.75, height*.235);
  text(int(PAYLOAD), width*.85, height*.235);
  
  // DRAW BUTTONS
  textSize(textSize);
  if(FIRE) fill(0);   else  fill(255);
  rect(width*.7, height*.4, width*.25, height*.15, height*.01);
  if(VENT) fill(0);   else  fill(255);
  rect(width*.7, height*.575, width*.25, height*.15, height*.01);
  if(FIRE) fill(255);   else  fill(0);
  text("FIRE", width*.74, height*.5);
  if(VENT) fill(255);   else  fill(0);
  text("VENT", width*.74, height*.675);
}

void draw(){
  currentSecond = second();
  if(lastSecond != currentSecond){
    lastSecond = currentSecond;
    elapsedSeconds++;
    fps = (frameCount-lastFrameCount);
    lastFrameCount = frameCount;
    updateOnce();
    println(elapsedSeconds + ": Frames:" + fps + "/sec");
  }
  update();
  drawScreen();
}

void mousePressed(){
  mouseDown = true;
}

void mouseReleased(){
  mouseDown = false;
}
