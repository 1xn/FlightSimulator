
class View
{
  public
  View(int w, int h){
    size(w, h);
   
    // FONTS
    textFont(createFont("Courier New",30));
    fontSize = int(height*.09);

    // INTERFACE ELEMENTS
    button1X = width*.7;
    button1Y = height*.315;
    button1W = width*.25;
    button1H = height*.15;
    button2X = width*.7;
    button2Y = height*.49;
    button2W = width*.25;
    button2H = height*.15;
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
    rect(width*.6875, height*.2775, width*.275, height*.4, height*.005);
    rect(width*.1, height/40.+ height/10*5, width*.8, height/11.0, height*.01);
//  rect(width*.675, height*.37, width*.3, height*.4, height*.01);

    textSize(fontSize);
  
    // LARGE TITLES
    fill(255);
    text(" ALT",width*.075, height/10.*1);
    text(" PSI",width*.075, height/10.*2);
    text("ADNS",width*.075, height/10.*3);
    text("BDNS",width*.075, height/10.*4);
    text(" OAT",width*.075, height/10.*5);
    text(" BET",width*.075, height/10.*6);
    text(" VEL", width*.075, height/10.*7);
    text(" ACC", width*.075, height/10.*8);
    textSize(fontSize*.5);  
    text("ft",  width*.59, height/10.*1);
    text("psi", width*.59, height/10.*2);
    text("kgm3",width*.59, height/10.*3);
    text("kgm3",width*.59, height/10.*4);
    text("C",   width*.59, height/10.*5);
    text("C",   width*.59, height/10.*6);
    text("m/s", width*.59, height/10.*7);
    text("m/s2",width*.59, height/10.*8);
    textSize(fontSize);
    // LARGE COLUMN WHITE BACKGROUNDS
    fill(255);
    for(int i = 0; i < 8; i++){
      rect(width*.25, height/40.+ height/10.*i, width*.33, height/11.0, height*.01);
    }
    // LARGE COLUMN VALUES
    fill(0);
    text(int(ALT), width*.29,height/10.*1);
    text(atmosphere.p,width*.25,height/10.*2);
    text(atmosphere.density,width*.25,height/10.*3);
    text(BDENSITY, width*.25,height/10.*4);
    text(atmosphere.T, width*.25,height/10.*5);
    text(BET, width*.25,height/10.*6);
    text(VELOCITY, width*.25, height/10.*7);
    text(ACCEL, width*.25, height/10.*8);

    // SMALL COLUMN VALUES
    textSize(int(fontSize*.4));
    // CLOCK
    fill(255);
    rect(width*.7, height*.05, width*.25, height*.05, height*.005);
    text("HOUR : MIN : SEC", width*.7, height*.133);
    fill(0);
    text(int(elapsedSeconds/3600.) +" : "+ int(elapsedSeconds/60.) +" : "+ elapsedSeconds%60, width*.75, height*.0875);  
    // BUOYANT FORCE, PAYLOAD
    fill(255);
    rect(width*.7, height*.165, width*.115, height*.05, height*.005);
    rect(width*.835, height*.165, width*.115, height*.05, height*.005);
    text("BUOYANT/PAYLOAD", width*.7, height*.25);
    fill(0);
    text(int(BFORCE) + "kg", width*.705, height*.2);
    text(int(MASS) + "kg", width*.85, height*.2);
  
    // DRAW BUTTONS
    textSize(fontSize);
    if(FIRE) fill(0);   else  fill(255);
    rect(button1X, button1Y, button1W, button1H, height*.01);
    if(VENT) fill(0);   else  fill(255);
    rect(button2X, button2Y, button2W, button2H, height*.01);
    if(FIRE) fill(255);   else  fill(0);
    text("FIRE", width*.74, height*.415);
    if(VENT) fill(255);   else  fill(0);
    text("VENT", width*.74, height*.59);
  
    // BORDERS
    strokeWeight(height*.005);
    stroke(255);
    noFill();
    rect(width*.6875, height*.04, width*.275, height*.1, height*.005);
    rect(width*.6875, height*.15, width*.275, height*.115, height*.005);
    rect(width*.025, height*.1, width*.033, height*.8);
  
    // FLIGHT LEVELS
    textSize(int(fontSize*.25));
    noStroke();
    fill(255);
    for(int i = 0; i < 30; i++){
      if(i < 5) text(" "+i*2, 1, height*.9-i*height*.8/30.);
      else      text(i*2, 1, height*.9-i*height*.8/30.);
    }
    float altScale = ALT/60000.0 * height*.8;
    rect(width*.03, height*.9-altScale, width*.025, altScale);
  }
  
}
