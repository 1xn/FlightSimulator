float ALT = 0.0;
float PFM;
float BET;
float VOLUME;
float BPSI;
int currentSecond, lastSecond, elapsedSeconds, fps, lastFrameCount;
StandardAtmosphere atmosphere;
float textSize;
float PAYLOAD;

void setup(){
  // SETUP GRAPHICS ONLY
  size(800,600);
  textSize = height*.09;
  frameRate(15);  // 15 incase running on old computers
  PFont mono = loadFont("TlwgTypewriter-Bold-48.vlw");
  textFont(mono);
  atmosphere = new StandardAtmosphere();
  
  // SETUP VARIABLES
  PAYLOAD = 500;
  VOLUME = 1000;
}
void updateOnce(){  // called once per second

}
void update(){  // called every frame (unreliable rate, though measured into "fps")
  atmosphere.update(ALT);
  BPSI = 0;
  BET = 0;
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
  text("0", width*.75, height*.235);
  text(int(PAYLOAD), width*.85, height*.235);
  
  // DRAW BUTTONS
  fill(255);
  rect(width*.7, height*.4, width*.25, height*.15, height*.01);
  rect(width*.7, height*.575, width*.25, height*.15, height*.01);
  fill(0);
  textSize(textSize);
  text("FIRE", width*.75, height*.5);
  text("VENT", width*.75, height*.65);
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
