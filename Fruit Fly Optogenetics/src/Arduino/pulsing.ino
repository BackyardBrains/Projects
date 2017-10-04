//
//
//
// Optogenetics stimulation 100ms pulse at 1Hz
// Inputs:
// D0  D1  D4  D5  D12  D13  A0  A1
// Corresponding outputs
// D2  D3  D6  D7  D8   D9   D10 D11
//
//


// defines for setting and clearing register bits
#ifndef cbi
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif
#ifndef sbi
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif



int interrupt_Number=1999;//1 ms period of timer


int counters[8];
int inputs[8] =  {0, 1, 4, 5, 12, 13, 14, 15};
int outputs[8] = {2, 3, 6, 7, 8,  9,  10, 11};
#define PERIOD 1000
#define OFF_PULS_LENGTH 900


int i;
void setup(){ 
  for(i=0;i<8;i++)
  {
    pinMode(inputs[i], INPUT);
    pinMode(outputs[i], OUTPUT);
  }

  
   
  // TIMER SETUP- the timer interrupt allows preceise timed measurements of the reed switch
  //for mor info about configuration of arduino timers see http://arduino.cc/playground/Code/Timer1
  cli();//stop interrupts

  //Make ADC sample faster. Change ADC clock
  //Change prescaler division factor to 16
  sbi(ADCSRA,ADPS2);//1
  cbi(ADCSRA,ADPS1);//0
  cbi(ADCSRA,ADPS0);//0

  //set timer1 interrupt at 10kHz
  TCCR1A = 0;// set entire TCCR1A register to 0
  TCCR1B = 0;// same for TCCR1B
  TCNT1  = 0;//initialize counter value to 0;
  OCR1A = interrupt_Number;// Output Compare Registers 
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

      for(i=0;i<8;i++)
      {
            //check what should be outputs
            if(counters[i]>0)
            {
              counters[i] = counters[i] -1;  
              if(counters[i]>OFF_PULS_LENGTH)
              {
                  digitalWrite(outputs[i],HIGH);
              }
              else
              {
                 digitalWrite(outputs[i],LOW);
              }
            }
            else
            {
              digitalWrite(outputs[i],LOW);
            }
    
            //check inputs
            if(digitalRead(inputs[i])>0)
            {
                if(counters[i] ==0)
                {
                  counters[i] = PERIOD;
                }
            }  
      }  
}
   



void loop(){
    
    
}
