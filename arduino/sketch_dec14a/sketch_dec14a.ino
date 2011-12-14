int value; 

void setup() {
  
   Serial.begin (9600); 
   pinMode(2, INPUT);      // set the switch pin to be an input
   pinMode(3, OUTPUT);   // set the yellow LED pin to be an output
   pinMode(4, OUTPUT);   // set the red LED pin to be an output
 }

void loop() {
   // read the switch input:
   
   Serial.write (value); 
   /*
   if (digitalRead(2) == HIGH) {
     // if the switch is closed:
     digitalWrite(3, HIGH);    // turn on the yellow LED
     digitalWrite(4, LOW);     // turn off the red LED
   } 
   else {
     // if the switch is open:
     digitalWrite(3, LOW);     // turn off the yellow LED
     digitalWrite(4, HIGH);    // turn on the red LED
   }
   
   */
 }
