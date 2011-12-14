import processing.video.*;

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

  String []input = loadStrings ("bananas.csv"); 
  movie = new Movie(this, "bananas.mov");
  state = 0; 
  timer = 0; 

  movie.play();
  movie.goToBeginning();
  movie.pause();
  isPlaying = false;  

  font = loadFont("DejaVuSans-24.vlw");
  textFont(font, 24);

  banana = new Banana [input.length]; 
  println ("banana is:" + " " + banana.length + " input is " +  input.length); 

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
  case 0: 
    movie.pause(); 
    textSize (30); 
    text ("Banaaaa", width/2, height/2); 
    break; 


  case 1: 
  
  
    if (numFrame < banana.length-1) {
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
    text ("naaaaa!", width/2, height/2); 
    break;
  }





  /*
      for (int i = 0; i< frames.length; i++) {
   switch (state) {
   case 0:
   //resting state
   //play audio + random break loop
   ellipse (width/2, height/2, 100, 100); 
   break; 
   
   case 1: 
   //throwing state  
   setFrame (frames[numFrame]);
   //movie.play(); 
  /*
   if (timer < frames[numFrame+1]) {
   movie.play(); 
   } else {
   movie.stop(); 
   }
   
   break;
   }
   }
   */
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

  setFrame (frames[numFrame]);
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

