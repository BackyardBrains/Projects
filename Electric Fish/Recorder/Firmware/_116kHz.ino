/*
Fast 13 µs conversion time ADC read routines for Arduino M0 Pro.
by H. J. Whitlow 5 September 2015

There are three routines: 
selAnalog(n):      which selects the analog input channel
fastADCsetup(n):   must be called by setup()
anaRead();         which reads the data. 
Here "n" refers to the analog input pin

IMPORTANT: The Arduino M0 Pro must be powered by an external 
power source as the USB supply is not reliable for fast ADC
operation.
*/
//##############################################################
//  Preamble definitions for fastADC
//
//##############################################################


#include "Arduino.h"
#include "wiring_private.h"
#include <Wire.h>

#include <SPI.h>
#include <SD.h>
#include <RTCZero.h>

/* Create an rtc object */
RTCZero rtc;
/* Change these values to set the current initial time */
const byte seconds = 0;
const byte minutes = 0;
const byte hours = 16;

/* Change these values to set the current initial date */
const byte day = 15;
const byte month = 6;
const byte year = 15;

const int chipSelect = 10;
String filename = "rec";
String fname;

bool beenInInterrupt = false;


//Sleepmode code
#define SLEEP_TIMER_COUNT 1600000;
volatile unsigned long countdown = SLEEP_TIMER_COUNT;

const byte signalDetector = 7;

volatile bool shouldBeSleeping = false;







// This is an C/C++ code to insert repetitive code sections in-line pre-compilation
// Wait for synchronization of registers between the clock domains
// ADC
static __inline__ void ADCsync() __attribute__((always_inline, unused));
static void   ADCsync() {
  while (ADC->STATUS.bit.SYNCBUSY == 1); 
}
static void syncGCLK() {
  while (GCLK->STATUS.bit.SYNCBUSY == 1); //Just wait till the ADC is free
}
//##############################################################

// Set up pin 10 as output for oscilloscope timing
#define PIN 3
#ifdef _VARIANT_ARDUINO_ZERO_
volatile uint32_t *setPin = &PORT->Group[g_APinDescription[PIN].ulPort].OUTSET.reg;
volatile uint32_t *clrPin = &PORT->Group[g_APinDescription[PIN].ulPort].OUTCLR.reg;
const uint32_t  PinMASK = (1ul << g_APinDescription[PIN].ulPin);
#endif

// Set up some trivia
#define NUMBER_OF_SAMPLES 400
#define HALF_NUMBER_OF_SAMPLES 200
int circularBuffer[NUMBER_OF_SAMPLES];//circular buffer
int head = 0;//position at which we are writing current sample
uint32_t anaPin = A1; // ADC channel 
uint32_t val = 0;
uint32_t dac = 127;   // This is the dac value

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);          //  setup serial
  pinMode(PIN, OUTPUT);        // setup timing marker
  //analogWriteResolution(10);
  //analogWrite(A0,dac);
  if (!SD.begin(chipSelect)) {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    return;
  }
  Serial.println("card initialized.");
  lookForFile();
  Serial.println(fname);
  
  // Fast ADC setup
  selAnalog(anaPin);
  //fastADCsetup2();
  fastADCsetup2();
   rtc.begin(); // initialize RTC

  // Set the time
  rtc.setHours(hours);
  rtc.setMinutes(minutes);
  rtc.setSeconds(seconds);
  
  // Set the date
  rtc.setDay(day);
  rtc.setMonth(month);
  rtc.setYear(year);
  
  // you can use also
  //rtc.setTime(hours, minutes, seconds);
  //rtc.setDate(day, month, year);
   rtc.begin();
  //pinMode(signalDetector, INPUT);
  
  
  


  
}


// to check that we have a unique filename, if not. 
//Start "for" loop over until we do.
void lookForFile()
{
  String tempName;
  for(int i = 0; i<60000; i++)
  {
    tempName = filename + i + ".txt";
    char charBuf[50]; 
    tempName.toCharArray(charBuf, 50);
    if(!SD.exists(charBuf))//does file exist already on SD card
     {
      fname = filename + i + ".txt";
      break;
    }
  }
}

uint32_t average = 2000;//holds average of signal that we are recording
uint32_t tempaverage = 0;
int counter = -1;//counts how much samples we need to add to buffer in order to get whole spike
uint32_t valueRead;

void loop() {

     Serial.print("Loop begining");
  

    char charBuf[50]; 
    fname.toCharArray(charBuf, 50);
    File dataFile = SD.open(charBuf, FILE_WRITE);
    if (dataFile) {//if we can open the file datafile = (1)
      Serial.println(charBuf);//just print name of the file on serial monitor 
      dataFile.close();
    }
    else
    {
      Serial.println("Cannot open file."); //(datafile = 0)
    }
    
     while(1)//this is looping indefinitly
     {
     


        //digitalWrite(PIN, HIGH);
         
        *setPin = PinMASK;
        //------------------------- Read one sample ----------------------------------
        ADC->INTFLAG.bit.RESRDY = 1;              // Data ready flag cleared
        while (ADC->STATUS.bit.SYNCBUSY == 1);
        ADC->SWTRIG.bit.START = 1;                // Start ADC conversion
        while ( ADC->INTFLAG.bit.RESRDY == 0 );   // Wait till conversion done
        while (ADC->STATUS.bit.SYNCBUSY == 1);
        valueRead = ADC->RESULT.reg;     // read the result
        
        while (ADC->STATUS.bit.SYNCBUSY == 1);
        ADC->SWTRIG.reg = 0x01;  
        
       //DEBUG test and serial print to test
       //--------------------------- end of Read one sample -----------------------------
     
      average = (average-(average>>4))+(valueRead>>4); //bit shifting, save processing time
       // tempaverage = 98*average + 2* valueRead;//update average
       // average average>>4
       //average = tempaverage/100;
       *clrPin = PinMASK;
      // hexvalue conversion of unsigned int valueRead
        circularBuffer[head] = valueRead;
        //String valueHex = String(valueRead, HEX);
        //circularBuffer[head] = valueHex;//put sample in our buffer
        head++;//move writing head for one place in circular buffer
        
        
        
        if(head==NUMBER_OF_SAMPLES)//if we get to the end of the circular buffer return to the begining
        {
          head = 0;  
        }
         
         
         
       
        
        if(counter>=0)
        {
          counter--;
        
          if(counter==0)
          {
            counter = -1;//countdown counter is not active anymore
            //save everything
            head++;//go to the begining of the spike (oldest sample)
            //special case when head is right on edge of circularbuffer
            if(head>=NUMBER_OF_SAMPLES)
            {
              head = 0; //go to beginning of buffer 
            }
             File dataFile = SD.open(charBuf, FILE_WRITE);//open file on SD
              
             
            for(int i=0;i<NUMBER_OF_SAMPLES;i++)  // place each sample value from buffer into SD file (char)
            {
                 
                  //if (dataFile) {
                
                    // convert valueRead to hexidecimal before assigning to circular[buffer] loop
                    dataFile.print(circularBuffer[head]);  //serial print sample value in that buffer place holder
                    dataFile.print(",");  //print a comma after each value
                  
                  head++;  //go to next head place in buffer
                  if(head>=NUMBER_OF_SAMPLES) //special case again if on edge of buffer
                  {
                    head = 0;  
                  }
                  
            }
          //File dataFile = SD.open(charBuf, FILE_WRITE);
            //if (dataFile) {
              dataFile.print("\n");
              dataFile.close();
              //Serial.println(charBuf);
            //}
           // else
            //{
              //Serial.println("Cannot open file.");
            //}
            
          }
        }
        else
        {
          //(3.3V/4096)*500 = 0.402 V
          //so we will trigger save if signal is greater than mean value + 0.4V or less than mean value - 0.4V
          if(valueRead>(average+500) || valueRead<(average-500))
          {
            //we detected spike
            //now we need to save last 200 samples (~2ms of signal) and we will need to save 
            //200 samples that will come in future
            //we set counter to 200 and we countdown every time we get new sample 
            //when we hit zero we will save
            //countdown = SLEEP_TIMER_COUNT;
            counter = HALF_NUMBER_OF_SAMPLES;
          }
        }

        
     }
}




//###################################################################################
// ADC select here
//
//###################################################################################

uint32_t selAnalog(uint32_t ulPin){      // Selects the analog input channel in INPCTRL
ADCsync();
ADC->INPUTCTRL.bit.MUXPOS = g_APinDescription[ulPin].ulADCChannelNumber; // Selection for the positive ADC input
}


//###################################################################################
// ADC set-up  here
//
//###################################################################################


uint32_t fastADCsetup2() {
  //Set input control register
  ADCsync();
  ADC->INPUTCTRL.bit.GAIN = ADC_INPUTCTRL_GAIN_1X_Val;      // Gain select as 1X
  //Set ADC reference source
  ADCsync();
  ADC->REFCTRL.bit.REFSEL = ADC_REFCTRL_REFSEL_INTVCC0_Val;//  2.2297 V Supply VDDANA //ADC_REFCTRL_REFSEL_INT1V_Val;   // ref is 1 V band gap internal
  // Set sample length and averaging
  ADCsync();
  ADC->AVGCTRL.reg = 0x00 ;       //Single conversion no averaging
  ADCsync();
  ADC->SAMPCTRL.reg = 0x00;       //Minimal sample length is 1/2 CLK_ADC cycle
  // Set up clock to 8 Mhz oscillator
  syncGCLK();
  GCLK->CLKCTRL.reg = 0x431E; //enable GGCLK for ADC, CLKGEN3 = 8 MHz oscillator 
  syncGCLK();
  //Control B register
  ADCsync();
  ADC->CTRLB.reg =  0x000     ; // Prescale 4, 12 bit resolution, single conversion
  // Enable ADC in control B register
  ADCsync();
  ADC->CTRLA.bit.ENABLE = 0x01;  
}


//##############################################################################
// Fast analogue read anaRead()  
// This is a stripped down version of analogRead() where the set-up commands
// are executed during setup()
// ulPin is the analog input pin number to be read.
//  Mk. 2 - has some more bits removed for speed up
///##############################################################################
uint32_t anaRead() {
  ADC->INTFLAG.bit.RESRDY = 1;              // Data ready flag cleared
  while (ADC->STATUS.bit.SYNCBUSY == 1);
  ADC->SWTRIG.bit.START = 1;                // Start ADC conversion
  while ( ADC->INTFLAG.bit.RESRDY == 0 );   // Wait till conversion done
  while (ADC->STATUS.bit.SYNCBUSY == 1);
  uint32_t valueRead = ADC->RESULT.reg;     // read the result
  while (ADC->STATUS.bit.SYNCBUSY == 1);
  ADC->SWTRIG.reg = 0x01;                    //  and flush for good measure
  return valueRead;
}
//##############################################################################

