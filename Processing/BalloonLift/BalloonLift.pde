int currentSecond, lastSecond, elapsedSeconds, fps, lastFrameCount;
int fontSize;
boolean mouseDown, FIRE, VENT;
float button1X, button1Y, button1H, button1W, button2X, button2Y, button2W, button2H;

Atmosphere atmosphere;
Balloon balloon, balloonForecast;
View view;

float START_TEMP = 69;
float fireAmount = 0;

void setup(){
  view = new View(800,600);
  atmosphere = new Atmosphere();
  balloon = new Balloon(500, 17, START_TEMP);          // these have to be the same values
  balloonForecast = new Balloon(500, 17, START_TEMP);  //  39.7
  frameRate(15);  // 15 incase running on old computers
}
void updateOnce(){  // called once per second
//  println(fps);
  balloonForecast.loadBalloon(balloon);
  for(int i = 0; i < 10; i++){
    balloonForecast.predict_vertical_motion(1, i*360);
    view.forecast[i] = balloonForecast.altitude/50000.;
  }
//  balloon.log();
}
void update(){  // every frame (variable, screen refresh, corrected by taking account "fps")  
  atmosphere.atmosphereAtAltitude(balloon.altitude);
  balloon.update_vertical_motion(fps);
  view.update();
  if(FIRE){ 
    fireAmount +=random(.00001,.0005);
    if(fireAmount > .05) fireAmount = .05;
    balloon.temperature+=fireAmount;
  }
  if(VENT){ 
    fireAmount +=random(.00005,.0025);
    if(fireAmount > .05) fireAmount = .05;
    balloon.temperature-=fireAmount;
  }
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
  if(elapsedSeconds > 1)
    update();
  view.draw();
}
void mousePressed(){
  mouseDown = true;
}
void mouseReleased(){
  mouseDown = false;
  fireAmount = 0;
}
