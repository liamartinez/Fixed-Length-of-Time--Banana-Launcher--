import ddf.minim.*;
/*
import ddf.minim.signals.*;
 import ddf.minim.analysis.*;
 import ddf.minim.effects.*;
 */


import processing.video.*;
import processing.serial.*;

Serial myPort;        
int switchValue; 
int lastFrame; 

Minim minim;
AudioPlayer[] baba; 
AudioPlayer[] nana;

Movie movie;
int numFrame = 0;
PFont font;
boolean isPlaying; 
int numMovie; 

int state; 
int timer; 

Banana[] banana; 
int [] frames;  
String [] splits; 

//-----------------------------------------------------------------
void setup () {
  size (720, 480); 
  background (0); 
  smooth(); 
  noStroke(); 

  println(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);

  minim = new Minim (this); 
  baba = new AudioPlayer [14]; 
  nana = new AudioPlayer [14]; 

  for (int i = 0; i < baba.length; i++) {
    baba[i] = minim.loadFile ("bananas/baba_" + i + ".aif", 2048);
  }

  for (int i = 0; i < nana.length; i++) {
    nana[i] = minim.loadFile ("bananas/nana_" + i + ".aif", 2048);
  }

  String []input = loadStrings ("bananas.csv"); 
  movie = new Movie(this, "bananas2.mov");
  state = 0; 
  timer = 0; 

  movie.play();
  movie.goToBeginning();
  movie.pause();
  isPlaying = false;  

  font = loadFont("DejaVuSans-24.vlw");
  textFont(font, 24);

  banana = new Banana [input.length]; 
  //println ("banana is:" + " " + banana.length + " input is " +  input.length); 

  frames = new int [input.length]; 
  splits = new String [input.length]; 

  for (int i = 1; i < input.length; i++) {
    splits = input[i].split(","); 
    //banana[i].releaseVideo = int(splits[0]);
    frames[i] =  int(splits[0]);
    //banana[i].releaseVideo = int(splits[0]);

    //println (lia); 
    println (frames[i]); 
    //println ("releasevideo " + banana[i].releaseVideo);
  }
}

//-----------------------------------------------------------------
void draw () {
  image(movie, 0, 0, width, height);
  fill(240, 20, 30);

  text(getFrame() + " / " + (getLength() - 1), 10, 30);

  timer = getFrame(); 



  switch (state) {

  case 0: //restingstate
    movie.pause(); 
    textSize (30); 
    text ("Banaaaa", width/2, height/2); 
    if (numFrame < banana.length-1) {   //another looping thing
      if (timer < frames[numFrame+1] ) {
        movie.play();
      } 
      else {
        movie.pause();

      }
    } 
    else {
      movie.play();
      baba[numFrame].play();
    } 
    
    //if the current frame is bigger than 0, and if the old one is still playing
    if (numFrame > 0) { 
        if (nana[numFrame-1].isPlaying()) nana[numFrame-1].pause();            
    } 
    
    baba[numFrame].play();
      
    //baba[numFrame].trigger();
    break; 

  case 1: //launching
    if (numFrame < banana.length-1) {   //another looping thing

      if (timer < frames[numFrame+1] ) {
        movie.play();
        
      } 
      else {
        movie.pause();
        
      }
    } 
    else {
      movie.play();
    } 
    
    nana[numFrame].play();
    
    if (numFrame > 0) { 
        if (baba[numFrame-1].isPlaying()) baba[numFrame-1].pause();     
    } 
    
    text ("naaaaa!", width/2, height/2);    
    break;
  }//close looping thing
}


//-----------------------------------------------------------------
void movieEvent(Movie movie) {
  movie.read();
}

//------------------------------------------------------------------
void mouseClicked () {

   
  if (numFrame < banana.length-1) {
    numFrame++ ;
  } 
  else {
    numFrame = 0;
  }
  
  //create a lastPlayed variable before you enter this
  /*
  numFrame = (int)random (0, baba.length); 
  if (numFrame != lastFrame) lastFrame = numFrame; 
  */

  setFrame (frames[numFrame]);
  
   //save the current frame here 
   lastFrame = numFrame; 
   
   println ("numframe " + numFrame + " last frame " + lastFrame); 
  //println (numFrame); 



  if (state <1) {
    state++;


  

    
  } 
  else {
    state = 0;

  }
  println ("state is: " + state);
}











//-----------------------------------------------------------------

void keyPressed() {
  if (key == 'p') {
    // toggle pausing
    if (!isPlaying) {
      movie.play();
    } 
    else {
      movie.pause();
    }
    isPlaying = !isPlaying;
  }

  if (key == 'q') {
    numFrame++ ;
    
    for (int i = 0; i<frames.length; i++) {
      setFrame (frames[numFrame]);
      println (numFrame);
    }
  }
} 





//------------------------------------------------------------------

int getFrame() {    
  return ceil(movie.time() * movie.getSourceFrameRate()) - 1;
}

//-------------------------------------------------------------------
void setFrame(int n) {
  movie.play();

  float srcFramerate = movie.getSourceFrameRate();

  // The duration of a single frame:
  float frameDuration = 1.0 / srcFramerate;

  // We move to the middle of the frame by adding 0.5:
  float where = (n + 0.5) * frameDuration; 

  // Taking into account border effects:
  float diff = movie.duration() - where;
  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }

  movie.jump(where);

  movie.pause();
}  
//---------------------------------------------------------------------

int getLength() {
  return int(movie.duration() * movie.getSourceFrameRate());
}  

//---------------------------------------------------------------------

void serialEvent (Serial myPort) {
  // get the byte:

  int inByte = myPort.read(); 
  switchValue = inByte; 
  // print it:
  println(inByte);
}

//---------------------------------------------------------------------
void stop()
{
  // always close Minim audio classes when you are done with them

  minim.stop();

  super.stop();
}

