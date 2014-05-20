float ALT = 0.0;
float PFM;
float OAT;
float BET;
float APSI;
int currentSecond, lastSecond, elapsedSeconds, fps, lastFrameCount;
StandardAtmosphere atmosphere;
float textSize = 40;

void setup(){
  size(800,600);
  frameRate(15);  // 15 incase running on old computers
  PFont mono = loadFont("TlwgTypewriter-Bold-48.vlw");
  textFont(mono);
  textSize(textSize);
  atmosphere = new StandardAtmosphere();
}
void updateOnce(){  // called once per second

}
void update(){  // called every frame (unreliable rate, though measured into "fps")
  atmosphere.update(ALT);
  OAT = atmosphere.T;
  APSI = atmosphere.p;
}
void drawScreen(){
  background(0);
//  text(" ALT",width*.33, height/12.*1);
//  text("APSI",width*.33, height/12.*2);
//  text("FUEL",width*.33, height/12.*3);
//  text(" OAT",width*.33, height/12.*4);
//  text(ALT, width*.33+120,height/12.*1);
//  text(APSI,width*.33+120,height/12.*2);
//  text(OAT, width*.33+120,height/12.*4);
}

void draw(){
  // FRAME PER SECOND
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
