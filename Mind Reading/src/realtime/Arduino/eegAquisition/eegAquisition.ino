#define EKG A0 //we are reading from AnalogIn 0
#define BUFFER_SIZE 100
#define SIZE_OF_COMMAND_BUFFER 30
// defines for setting and clearing register bits
#ifndef cbi
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif
#ifndef sbi
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif

int buffersize = BUFFER_SIZE;
int head = 0;
int tail = 0;
byte writeByte;
char commandBuffer[SIZE_OF_COMMAND_BUFFER];
byte reading[BUFFER_SIZE]; //we have two buffers of 30 elements, this go back and forth to the serial port - needed to proper timing
////This sets up serial communication values can 9600, 14400, 19200, 28800, 31250, 38400, 57600, and 115200, also 300, 600, 1200, 2400, 4800, but that's too slow for us

/// Interrupt number - very important in combination with bit rate to get accurate data
int interrupt_Number=199;//199; // = (16*10^6) / (1000*8) - 1 // IMPORTANT!!!!! set to 1999 for 1000 Hz sampling, set to 3999 for 500 Hz sampling, set to 7999 for 250Hz sampling, 15999 for 125 Hz Sampling
int numberOfChannels = 6;
int tempSample = 0;
int commandMode = 0;

void setup(){ 
  Serial.begin(2000000);//for MAC use 921600 and for windows 2000000
  

  // TIMER SETUP- the timer interrupt allows preceise timed measurements of the reed switch
  //for mor info about configuration of arduino timers see http://arduino.cc/playground/Code/Timer1
  cli();//stop interrupts

  //Make ADC sample faster
  sbi(ADCSRA,ADPS2);
  cbi(ADCSRA,ADPS1);
  cbi(ADCSRA,ADPS0);

  //set timer1 interrupt at 1kHz
  TCCR1A = 0;// set entire TCCR1A register to 0
  TCCR1B = 0;// same for TCCR1B
  TCNT1  = 0;//initialize counter value to 0;
  // set timer count for 500 Hz increments
  OCR1A = (interrupt_Number+1)*numberOfChannels - 1;// = (16*10^6) / (1000*8) - 1 // IMPORTANT!!!!! set to 1999 for 1000 Hz sampling, set to 3999 for 500 Hz sampling, set to 7999 for 250Hz sampling
  // turn on CTC mode
  TCCR1B |= (1 << WGM12);
  // Set CS11 bit for 8 prescaler
  TCCR1B |= (1 << CS11);   
  // enable timer compare interrupt
  TIMSK1 |= (1 << OCIE1A);




  
  sei();//allow interrupts
  //END TIMER SETUP
}


ISR(TIMER1_COMPA_vect) {
   //Interrupt at the timing frequency you set above to measure to measure AnalogIn, and filling the buffers
   if(commandMode!=1)
   {
       //tempSample = analogRead(A0);
       tempSample = analogRead(A0);
       reading[head] =  (tempSample>>7)|0x80;
       head = head+1;
       if(head==BUFFER_SIZE)
       {
         head = 0;
       }
       reading[head] =  tempSample & 0x7F;
       head = head+1;
       if(head==BUFFER_SIZE)
       {
         head = 0;
       }

         //tempSample = analogRead(A1);
         tempSample = analogRead(A1);
         reading[head] =  (tempSample>>7) & 0x7F;
         head = head+1;
         if(head==BUFFER_SIZE)
         {
           head = 0;
         }
         reading[head] =  tempSample & 0x7F;
         head = head+1;
         if(head==BUFFER_SIZE)
         {
           head = 0;
         }
     

        // tempSample = analogRead(A2);
         tempSample = analogRead(A2);
         reading[head] =  (tempSample>>7) & 0x7F;
         head = head+1;
         if(head==BUFFER_SIZE)
         {
           head = 0;
         }
         reading[head] =  tempSample & 0x7F;
         head = head+1;
         if(head==BUFFER_SIZE)
         {
           head = 0;
         }


        // tempSample = analogRead(A3);
         tempSample = analogRead(A3);
         reading[head] =  (tempSample>>7) & 0x7F;
         head = head+1;
         if(head==BUFFER_SIZE)
         {
           head = 0;
         }
         reading[head] =  tempSample & 0x7F;
         head = head+1;
         if(head==BUFFER_SIZE)
         {
           head = 0;
         }
 

        // tempSample = analogRead(A4);
         tempSample = analogRead(A4);
         reading[head] =  (tempSample>>7) & 0x7F;
         head = head+1;
         if(head==BUFFER_SIZE)
         {
           head = 0;
         }
         reading[head] =  tempSample & 0x7F;
         head = head+1;
         if(head==BUFFER_SIZE)
         {
           head = 0;
         }

          tempSample = analogRead(A5);
         reading[head] =  (tempSample>>7) & 0x7F;
         head = head+1;
         if(head==BUFFER_SIZE)
         {
           head = 0;
         }
         reading[head] =  tempSample & 0x7F;
         head = head+1;
         if(head==BUFFER_SIZE)
         {
           head = 0;
         }
   
      
   }
}
   

void loop(){
    
    while(head!=tail && commandMode!=1)
    {
      Serial.write(reading[tail]);
   
      tail = tail+1;
      if(tail==BUFFER_SIZE)
      {
        tail = 0;
      }
    }
}
