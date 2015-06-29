class View
{
  public
  
  int flashAlpha = 0;
  float[] forecast = new float[10];
  boolean forecastHasPeak;
  int forecastPeakTime;
  boolean forecastHasLanding;
  float forecastLandingTime;

  View(int w, int h){
   
    // FONTS
    textFont(createFont("Courier New",30));
    fontSize = int(height*.09);

    // INTERFACE ELEMENTS
    button1X = width*.7;
    button1Y = height*.175;
    button1W = width*.25;
    button1H = height*.15;
    button2X = width*.7;
    button2Y = height*.34;
    button2W = width*.25;
    button2H = height*.15;
    
    for(int i = 0; i < 10; i++) forecast[i] = 0.0;
  }
  
  void update(){
    if(mousePressed && !mouseDown)
      mouseDown = true;
    else if(!mousePressed && mouseDown)
      mouseDown = false;
    if(mouseDown && mouseX > button1X && mouseX < button1X+button1W && mouseY > button1Y && mouseY < button1Y+button1H)
      FIRE = true;
    else FIRE = false;
    if(mouseDown && mouseX > button2X && mouseX < button2X+button2W && mouseY > button2Y && mouseY < button2Y+button2H)
      VENT = true;          
    else VENT = false;  
  }
  
  void textBox(float str, float centerX, float centerY){
    noStroke();
    fill(255);    
    rect(centerX, centerY, width*.12, height*.05, height*.005);    
    fill(0);
    text(str, centerX+width*.005, centerY + height*.035);  
  }
  void draw(){
  
    background(0);  
    noStroke();
    // BACKGROUND GRAY
    fill(84);
    rect(button1X-height*.015, button1Y-height*.015, width*.275, height*.35, height*.005);
    rect(width*.1, height/40.+ height/10*3, width*.8, height/11.0, height*.01);
//  rect(width*.675, height*.37, width*.3, height*.4, height*.01);
    rect(0, height*.01, width*.0775, height*.645, height*.005);
    rect(0, height/40.+ height/10*0, width*.65, height/11.0, height*.01);
    rect(button1X-height*.015, height*.525, width*.275, height*.36, height*.005);

    textSize(fontSize);
  
    // LARGE TITLES
    fill(255);
    text(" ALT",width*.075, height/10.*1);
    text(" VEL", width*.075, height/10.*2);
//    text(" ACC", width*.075, height/10.*3);
//    text("ADNS",width*.075, height/10.*3);
//    text("BDNS",width*.075, height/10.*4);
    text(" BET",width*.075, height/10.*4);
    text(" OAT",width*.075, height/10.*5);
    text(" DNS",width*.075, height/10.*6);
    textSize(fontSize*.5);  
    text("ft",  width*.59, height/10.*1);
    text("m/s", width*.59, height/10.*2);
//    text("m/s²",width*.59, height/10.*3);
//    text("kgm3",width*.59, height/10.*3);
//    text("kgm3",width*.59, height/10.*4);
    text("°C",   width*.59, height/10.*4);
    text("°C",   width*.59, height/10.*5);
    text("kg/m³", width*.59, height/10.*6);
    textSize(fontSize);
    // LARGE COLUMN WHITE BACKGROUNDS
    fill(255);
    for(int i = 0; i < 6; i++){
      rect(width*.25, height/40.+ height/10.*i, width*.33, height/11.0, height*.01);
    }
    // LARGE COLUMN VALUES
    fill(0);
    text(int(balloon.altitude*METERS_TO_FEET), width*.29,height/10.*1);
//    text(atmosphere.density,width*.25,height/10.*3);
//    text(balloon.density, width*.25,height/10.*4);
    text(balloon.velocity, width*.25, height/10.*2);
//    text(balloon.acceleration, width*.25, height/10.*3);
    text(balloon.temperature, width*.25,height/10.*4);
    text(atmosphere.temperature, width*.25,height/10.*5);
    text(balloon.density,width*.25,height/10.*6);

    // SMALL COLUMN VALUES
    textSize(int(fontSize*.4));
    // CLOCK
    fill(255);
    rect(width*.7, height*.05, width*.25, height*.05, height*.005);
    text("HOUR : MIN : SEC", width*.695, height*.133);
    fill(0);
    int hr = int(elapsedSeconds/3600.);
    int min = int(elapsedSeconds/60.)%60;
    int sec = elapsedSeconds%60;
    String hrString, minString, secString;
    if(hr < 10) hrString = "0" + hr;
    else        hrString = "" + hr;
    if(min < 10) minString = "0" + min;
    else         minString = "" + min;
    if(sec < 10) secString = "0" + sec;
    else         secString = "" + sec;
    text(hrString +" : "+ minString +" : "+ secString, width*.725, height*.0875);  
  
    // FIRE VENT BUTTONS
    textSize(fontSize);
    if(FIRE) fill(0);   else  fill(255);
    rect(button1X, button1Y, button1W, button1H, height*.01);
    if(VENT) fill(0);   else  fill(255);
    rect(button2X, button2Y, button2W, button2H, height*.01);
    if(FIRE) fill(255);   else  fill(0);
    text("FIRE", width*.74, height*.28);
    if(VENT) fill(255);   else  fill(0);
    text("VENT", width*.74, height*.44);
  
    // BORDERS
    strokeWeight(height*.005);
    stroke(255);
    noFill();
    rect(width*.6875, height*.04, width*.275, height*.1, height*.005);
//    rect(width*.6875, height*.15, width*.275, height*.115, height*.005);
    rect(width*.033, height*.025, width*.033, height*.6);
  
    // FLIGHT LEVELS
    textSize(int(fontSize*.25));
    noStroke();
    fill(255);
    for(int i = 0; i < 30; i++){
      if(i < 5) text(" "+i*2, width*.005, height*.625-i*height*.6/30.);
      else      text(i*2, width*.005, height*.625-i*height*.6/30.);
    }
    text(" k ft", width*.005, height*.625-(-1)*height*.6/30.);
    float altScale = balloon.altitude*METERS_TO_FEET/60000.0 * height*.6;
    rect(width*.0366, height*.625-altScale, width*.025, altScale);
      
    // BALLOON AND BALLOON STATISTICS
    float ballX = width*.82;
    float ballY = height*.675;
    stroke(255);
    strokeWeight(1);
    noFill();
    float diameter = 0;
    for(float i = 2; i < 8; i++){
      diameter = sin(i/8.0*1.5708)*height*.2;
      ellipse(ballX, ballY, diameter, diameter);
    }
    line(ballX-diameter*.5, ballY-diameter*.58, ballX+diameter*.5, ballY-diameter*.58);
    line(ballX-diameter*.5, ballY-diameter*.56, ballX-diameter*.5, ballY-diameter*.6);
    line(ballX+diameter*.5, ballY-diameter*.56, ballX+diameter*.5, ballY-diameter*.6);
    textSize(int(fontSize*.3));
    fill(255);
    text(balloon.diameter + "m diameter", ballX*.9, height*.55);
//    text(int(balloon.volume) + "m³ volume", ballX*.9, height*.575);
    text(balloon.mass + "kg ship", ballX*.91, ballY+height*.125);
    text(int(balloon.mass_air*10)/10.0 + "kg air mass", ballX*.895, ballY+height*.145);
    text("+", ballX*.86, ballY+height*.145);
    line(ballX-diameter*.6, ballY+height*.15, ballX+diameter*.8, ballY+height*.15);
    text(int(10*(balloon.mass + balloon.mass_air))/10.0 + "kg total", ballX*.895, ballY+height*.175);
    text(int(balloon.volume * atmosphere.density*10)/10.0 + "kg displaced", ballX*.895, ballY+height*.195);  

    // LIFT AND DRAG
    textSize(int(fontSize*.4));
    textBox(int(balloon.forceLift*10)/10.0, ballX-width*.15, height*.9);
    textBox(int(-balloon.forceDrag*10)/10.0, ballX+width*.035, height*.9);
    fill(255);
    text("  LIFT", ballX-width*.17, height*.98);
    text("  DRAG", ballX+width*.04, height*.98);
    text("DIFF", ballX-width*.03, height*.98);
    text("kg", ballX-width*.19, height*.942);
    textSize(fontSize);
    fill(flashAlpha*.33+168, 255); 
    if(balloon.velocity > 0){       text("▲", ballX-fontSize*.3, ballY+fontSize*.22);   }
    else if(balloon.velocity < 0){  text("▼", ballX-fontSize*.3, ballY+fontSize*.353); }
      
    // DIFFERENCE BETWEEN LIFT AND DRAG
    float diff = balloon.forceLift - balloon.forceDrag;
    
    fill(255);    
    rect(ballX-width*.02, height*.9, width*.045, height*.05, height*.005);    
    fill(0);
    textSize(fontSize*.66);
    if(diff > 0.01) text(">", ballX-fontSize*.16, height*.942);
    if(diff < -0.01) text("<", ballX-fontSize*.16, height*.942);
//    if(diff > 0.01) text("▲", ballX-fontSize*.16, height*.942);
//    if(diff < -0.01) text("▼", ballX-fontSize*.16, height*.942);
      
    // PREDICTION GRAPH  
    float boxX = width*.12;
    float boxY = height*.7;
    float boxW = width*.45;
    float boxH = width*.15;
    
    fill(84);  
    rect(boxX-width*.025, boxY-width*.025, boxW+width*.05, boxH+width*.05, height*.01);    

    noFill();
    stroke(192);
    strokeWeight(1);
    rect(boxX, boxY, boxW, boxH);
    line(boxX+boxW*.25, boxY, boxX+boxW*.25, boxY+boxH);
    line(boxX+boxW*.5, boxY, boxX+boxW*.5, boxY+boxH);
    line(boxX+boxW*.75, boxY, boxX+boxW*.75, boxY+boxH);
    line(boxX, boxY+boxH*.25, boxX+boxW, boxY+boxH*.25);
    line(boxX, boxY+boxH*.5, boxX+boxW, boxY+boxH*.5);
    line(boxX, boxY+boxH*.75, boxX+boxW, boxY+boxH*.75);
    
    stroke(255);
    strokeWeight(3);
    for(int i = 1; i < 10; i++){
      line(boxX+boxW*(i-1)/9., boxY+boxH-width*.5*forecast[i-1], boxX + boxW*i/9., boxY+boxH-width*.5*forecast[i]);
    }
     
    fill(255);
    textSize(int(fontSize*.25));
    text("0 hr", boxX, boxY+boxH+width*.02);
    text("1 hr", boxX+boxW-width*.02, boxY+boxH+width*.02);
    text("0", boxX-width*.02, boxY+boxH);
    text("16", boxX-width*.02, boxY+boxH*.75);
    text("32", boxX-width*.02, boxY+boxH*.5);
    text("49", boxX-width*.02, boxY+boxH*.25);
    text("65,000 ft", boxX-width*.02, boxY);
     
    stroke(255);
    strokeWeight(1);
    if(forecastHasPeak){
      line(boxX+boxW*(forecastPeakTime/9.0), boxY+boxH-width*.5*forecast[forecastPeakTime], boxX+boxW*(forecastPeakTime/9.0), boxY+boxH);
      text(60*forecastPeakTime/10.0 +" min", boxX+boxW*(forecastPeakTime/9.0), boxY+boxH+width*.02);
//      text(forecast[forecastPeakTime]*50000 +" ft", boxX+boxW*(forecastPeakTime/9.0), boxY+boxH-width*.5*forecast[forecastPeakTime]-width*.005);
    }
  } 
}