class View
{
  public
  
  float[] forecast = new float[10];

  View(int w, int h){
    size(w, h);
   
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
  void draw(){
  
    background(0);  
    noStroke();
    // BACKGROUND GRAY
    fill(128);
    rect(button1X-height*.015, button1Y-height*.015, width*.275, height*.35, height*.005);
    rect(width*.1, height/40.+ height/10*3, width*.8, height/11.0, height*.01);
//  rect(width*.675, height*.37, width*.3, height*.4, height*.01);

    textSize(fontSize);
  
    // LARGE TITLES
    fill(255);
    text(" ALT",width*.075, height/10.*1);
    text(" VEL", width*.075, height/10.*2);
    text(" ACC", width*.075, height/10.*3);
//    text("ADNS",width*.075, height/10.*3);
//    text("BDNS",width*.075, height/10.*4);
    text(" BET",width*.075, height/10.*4);
    text(" OAT",width*.075, height/10.*5);
    text(" PSI",width*.075, height/10.*6);
    textSize(fontSize*.5);  
    text("ft",  width*.59, height/10.*1);
    text("m/s", width*.59, height/10.*2);
    text("m/s2",width*.59, height/10.*3);
//    text("kgm3",width*.59, height/10.*3);
//    text("kgm3",width*.59, height/10.*4);
    text("C",   width*.59, height/10.*4);
    text("C",   width*.59, height/10.*5);
    text("psi", width*.59, height/10.*6);
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
    text(balloon.acceleration, width*.25, height/10.*3);
    text(balloon.temperature, width*.25,height/10.*4);
    text(atmosphere.temperature, width*.25,height/10.*5);
    text(atmosphere.pressure,width*.25,height/10.*6);

    // SMALL COLUMN VALUES
    textSize(int(fontSize*.4));
    // CLOCK
    fill(255);
    rect(width*.7, height*.05, width*.25, height*.05, height*.005);
    text("HOUR : MIN : SEC", width*.7, height*.133);
    fill(0);
    text(int(elapsedSeconds/3600.) +" : "+ int(elapsedSeconds/60.) +" : "+ elapsedSeconds%60, width*.75, height*.0875);  
  
    // DRAW BUTTONS
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
    rect(width*.025, height*.1, width*.033, height*.8);
  
    // FLIGHT LEVELS
    textSize(int(fontSize*.25));
    noStroke();
    fill(255);
    for(int i = 0; i < 30; i++){
      if(i < 5) text(" "+i*2, 1, height*.9-i*height*.8/30.);
      else      text(i*2, 1, height*.9-i*height*.8/30.);
    }
    float altScale = balloon.altitude*METERS_TO_FEET/60000.0 * height*.8;
    rect(width*.03, height*.9-altScale, width*.025, altScale);
  
    // BOTTOM VISUALIZATIONS
    stroke(255);
    strokeWeight(1);
    noFill();
    for(float i = 0; i < 8; i++){
      float r = sin(i/8.0*1.5708)*height*.2;
      ellipse(width*.575, height*.75, r, r);
    }
    text(balloon.mass + "kg gross", width*.5, height*.9);
    text(balloon.diameter + "m diameter", width*.5, height*.925);
    text(int(balloon.volume) + "m3 volume", width*.5, height*.95);
    // SMALL COLUMN VALUES
    textSize(int(fontSize*.4));
    fill(255);
    // data boxes
    rect(width*.25, height*.665, width*.15, height*.05, height*.005);    
    rect(width*.25, height*.74, width*.15, height*.05, height*.005);    
    rect(width*.25, height*.815, width*.15, height*.05, height*.005);    
    rect(width*.25, height*.89, width*.15, height*.05, height*.005);  
      // up down boxes  
    text("   LIFT", width*.1, height*.7);
    text("   DRAG", width*.1, height*.775);
    text(" WEIGHT", width*.1, height*.85);
    text("INERTIA", width*.1, height*.925);
    fill(0);
    noStroke();
    text(balloon.L, width*.25, height*.7);  
    text(balloon.D, width*.25, height*.775);  
    text(balloon.G, width*.25, height*.85);  
    text(balloon.I, width*.25, height*.925);  

    textSize(int(fontSize*.75));
    if(balloon.L > 0){       fill(0);  rect(width*.42, height*.665, height*.05, height*.05, height*.005);   fill(255);  text("▲", width*.425, height*.71);   }
    else if(balloon.L < 0){  fill(255);  rect(width*.42, height*.665, height*.05, height*.05, height*.005); fill(0);  text("▼", width*.425, height*.71); }
    if(balloon.D < 0){       fill(0);  rect(width*.42, height*.74, height*.05, height*.05, height*.005);    fill(255);  text("▲", width*.425, height*.785);  }
    else if(balloon.D > 0){  fill(255);  rect(width*.42, height*.74, height*.05, height*.05, height*.005);  fill(0);  text("▼", width*.425, height*.785);}
    if(balloon.G < 0){       fill(0);  rect(width*.42, height*.815, height*.05, height*.05, height*.005);   fill(255);  text("▲", width*.425, height*.86);   }
    else if(balloon.G > 0){  fill(255);  rect(width*.42, height*.815, height*.05, height*.05, height*.005); fill(0);  text("▼", width*.425, height*.86); }
    if(balloon.I < 0){       fill(0);  rect(width*.42, height*.89, height*.05, height*.05, height*.005);    fill(255);  text("▲", width*.425, height*.935);  }
    else if(balloon.I > 0){  fill(255);  rect(width*.42, height*.89, height*.05, height*.05, height*.005);  fill(0);  text("▼", width*.425, height*.935);}
    
    
    
    fill(255);  
    rect(width*.71, height*.6, width*.25, width*.25, height*.01);    

    stroke(0);
    strokeWeight(3);
    for(int i = 1; i < 10; i++){
      line(width*.71+width*.25*(i-1)/10., height*.6+width*.22-width*.25*forecast[i-1], width*.71 + width*.25*i/10., height*.6+width*.22-width*.25*forecast[i]);
    }
     
     
     

  } 
}
