int currentSecond, lastSecond, elapsedSeconds, fps, lastFrameCount;
int fontSize;
boolean mouseDown, FIRE, VENT;
float button1X, button1Y, button1H, button1W, button2X, button2Y, button2W, button2H;

Atmosphere atmosphere;
Balloon balloon;
View view;

void setup(){
  view = new View(800,600);
  atmosphere = new Atmosphere();
  balloon = new Balloon(200, 17, 38);
  frameRate(15);  // 15 incase running on old computers
}
void updateOnce(){  // called once per second
  balloon.log();
}
void update(){  // called every frame (unreliable rate, though measured into "fps")  
  atmosphere.atmosphereAtAltitude(balloon.altitude);
  balloon.update_vertical_motion(fps);
  view.update();
  if(FIRE) balloon.temperature+=random(.01,.5);
  if(VENT) balloon.temperature-=random(.01,.5);
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
