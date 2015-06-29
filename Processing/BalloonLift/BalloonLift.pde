int currentSecond, lastSecond, elapsedSeconds, fps, lastFrameCount;
int fontSize;
boolean mouseDown, FIRE, VENT;
float button1X, button1Y, button1H, button1W, button2X, button2Y, button2W, button2H;

Atmosphere atmosphere;
Balloon balloon, balloonForecast;
View view;

float START_TEMP = 69;
float firePower = 0;
float deltaTemp = 0;
float deltaTempDueToEquilibrium;
float deltaTempDueToFire;
float heatConduct;

void setup(){
  view = new View(800,600);
  size(800,600);
  atmosphere = new Atmosphere();
  balloon = new Balloon(500, 17, START_TEMP);          // these have to be the same values
  balloonForecast = new Balloon(500, 17, START_TEMP);  //  39.7
  frameRate(15);  // 15 incase running on old computers
  
  deltaTempDueToEquilibrium = -0.0001;
}
void updateOnce(){  // called once per second
//  println(fps);
  balloonForecast.loadBalloon(balloon);
  for(int i = 0; i < 10; i++){
    balloonForecast.predict_vertical_motion(1, i*360);
    view.forecast[i] = balloonForecast.altitude/50000.;
  }
  boolean isClimbing = false;
  boolean isInTheAir = false;
  if(view.forecast[0] < view.forecast[1])
    isClimbing = true;
    
  if(view.forecast[0] > 0)
    isInTheAir = true;
    
//  println(isClimbing+" "+isInTheAir);
    
//  boolean forecastHasPeak;
//  int forecastPeakTime;
//  boolean forecastHasLanding;
//  float forecastLandingTime;
  view.forecastHasPeak = false;
  if(isClimbing){
    for(int i = 1; i < 9; i++){
      if(!view.forecastHasPeak  && view.forecast[i] > view.forecast[i+1]){
        view.forecastHasPeak = true;
        view.forecastPeakTime = i;
      }      
    }
  }
  if(currentSecond % 2 == 0)
    view.flashAlpha = 0;
  else
    view.flashAlpha = 255;
//  balloon.log();
}
void update(){  // every frame (variable, screen refresh, corrected by taking account "fps")  
  atmosphere.atmosphereAtAltitude(balloon.altitude);
  balloon.update_vertical_motion(fps);
  view.update();
  if(FIRE){ 
    firePower = firePower + random(.00002,.0001);
    if(firePower > .0025) firePower = .025;
  }
  if(VENT){ 
    firePower = -random(.00005,.00025);
    if(firePower < -.05) firePower = -.05;
  }
  if(!mousePressed && (deltaTemp > 0 || deltaTemp < -.0025) ){
    deltaTemp *= 0.95;
  }
  deltaTempDueToFire = firePower;
//  println("DIFFERENCE: "+ (balloon.temperature + atmosphere.temperature)*.5);
  
  float tempDiff = ( (balloon.temperature + atmosphere.temperature)*.5);
  heatConduct = 0.00005 * tempDiff;   // (stored positive, usually used as a negative) about .0025 
  deltaTempDueToEquilibrium = -heatConduct * .05;
  
  if(deltaTemp > -heatConduct) 
    deltaTemp += deltaTempDueToEquilibrium;
    
  if(deltaTemp > -.09 && deltaTemp < .045)
    deltaTemp += deltaTempDueToFire;
    
  balloon.temperature += deltaTemp * tempDiff/50;
  if(balloon.temperature < atmosphere.temperature) balloon.temperature = atmosphere.temperature;
}
void draw(){
  currentSecond = second();
  if(lastSecond != currentSecond){
    lastSecond = currentSecond;
    elapsedSeconds = elapsedSeconds + 1;
    fps = (frameCount-lastFrameCount);
    lastFrameCount = frameCount;
    updateOnce();
//    println("HEAT Conductivity: " + heatConduct);
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
  firePower = 0;
}