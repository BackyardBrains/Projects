//  Test routine heavily inspired by wiring_analog.c from GITHUB site
// Global preamble
#include "Arduino.h"
#include "wiring_private.h"
#include <SD.h>
//

#define PIN 10
#ifdef _VARIANT_ARDUINO_ZERO_
volatile uint32_t *setPin = &PORT->Group[g_APinDescription[PIN].ulPort].OUTSET.reg;
volatile uint32_t *clrPin = &PORT->Group[g_APinDescription[PIN].ulPort].OUTCLR.reg;
const uint32_t  PinMASK = (1ul << g_APinDescription[PIN].ulPin);
#endif

#define CPU_HZ 48000000
#define TIMER_PRESCALER_DIV 64
#define LED_PIN 2

#define sampleRate 25000

bool isLEDOn = false;

void setTimerFrequency(int frequencyHz) {
  int compareValue = (CPU_HZ / (TIMER_PRESCALER_DIV * frequencyHz)) - 1;
  TcCount16* TC = (TcCount16*) TC3;
  // Make sure the count is in a proportional position to where it was
  // to prevent any jitter or disconnect when changing the compare value.
  TC->COUNT.reg = map(TC->COUNT.reg, 0, TC->CC[0].reg, 0, compareValue);
  TC->CC[0].reg = compareValue;
  while (TC->STATUS.bit.SYNCBUSY == 1);
}

File myFile;
String filename = "BIRD0.WAV";
int fileNum = 0;

void sdInit(){
  Serial.begin(9600);

  while(SD.exists(filename)){
    ++fileNum;
    filename = "BIRD" + (String)fileNum + ".WAV";
  }

  myFile = SD.open(filename, FILE_WRITE);

  if(!myFile){
    Serial.println("Open file fail - sdINIT");
    while(1);
  }
  else{
    myFile.seek(44);
  }

  Serial.end();
}


void makeHeader(int totalAudioLen){
  const int totalDataLen = 44 + totalAudioLen;
  const int compressionType = 1;
  const int numOfChannels = 1;
  const int byteRate = (sampleRate * numOfChannels * 16) / 8;

  byte header[44];
  header[0] = 'R';  // RIFF/WAVE header
  header[1] = 'I';
  header[2] = 'F';
  header[3] = 'F';
  header[4] = (byte) (totalDataLen & 0xff);
  header[5] = (byte) ((totalDataLen >> 8) & 0xff);
  header[6] = (byte) ((totalDataLen >> 16) & 0xff);
  header[7] = (byte) ((totalDataLen >> 24) & 0xff);
  header[8] = 'W';
  header[9] = 'A';
  header[10] = 'V';
  header[11] = 'E';
  header[12] = 'f';  // 'fmt ' chunk
  header[13] = 'm';
  header[14] = 't';
  header[15] = ' ';
  header[16] = 16;  // 4 bytes: size of 'fmt ' chunk
  header[17] = 0;
  header[18] = 0;
  header[19] = 0;
  header[20] = (byte)  compressionType;  // format = 1
  header[21] = 0;
  header[22] = (byte)  numOfChannels;
  header[23] = 0;
  header[24] = (byte) (sampleRate & 0xff);
  header[25] = (byte) ((sampleRate >> 8) & 0xff);
  header[26] = (byte) ((sampleRate >> 16) & 0xff);
  header[27] = (byte) ((sampleRate >> 24) & 0xff);
  header[28] = (byte) (byteRate & 0xff);
  header[29] = (byte) ((byteRate >> 8) & 0xff);
  header[30] = (byte) ((byteRate >> 16) & 0xff);
  header[31] = (byte) ((byteRate >> 24) & 0xff);
  header[32] = (byte) (numOfChannels * 2);  // block align
  header[33] = 0;
  header[34] = 16;  // bits per sample (32 for float)
  header[35] = 0;
  header[36] = 'd';
  header[37] = 'a';
  header[38] = 't';
  header[39] = 'a';
  header[40] = (byte) (totalAudioLen & 0xff);
  header[41] = (byte) ((totalAudioLen >> 8) & 0xff);
  header[42] = (byte) ((totalAudioLen >> 16) & 0xff);
  header[43] = (byte) ((totalAudioLen >> 24) & 0xff);

  Serial.begin(9600);
  

  if(myFile){
    myFile.seek(0);
    myFile.write(header, 44);
  }
  else{
    Serial.println("file open fail - header");
    while(1);
  }

  Serial.end();
}


/*
This is a slightly modified version of the timer setup found at:
https://github.com/maxbader/arduino_tools
 */
void startTimer(int frequencyHz) {
  REG_GCLK_CLKCTRL = (uint16_t) (GCLK_CLKCTRL_CLKEN | GCLK_CLKCTRL_GEN_GCLK0 | GCLK_CLKCTRL_ID (GCM_TCC2_TC3)) ;
  while ( GCLK->STATUS.bit.SYNCBUSY == 1 );

  TcCount16* TC = (TcCount16*) TC3;

  TC->CTRLA.reg &= ~TC_CTRLA_ENABLE;

  // Use the 16-bit timer
  TC->CTRLA.reg |= TC_CTRLA_MODE_COUNT16;
  while (TC->STATUS.bit.SYNCBUSY == 1);

  // Use match mode so that the timer counter resets when the count matches the compare register
  TC->CTRLA.reg |= TC_CTRLA_WAVEGEN_MFRQ;
  while (TC->STATUS.bit.SYNCBUSY == 1);

  // Set prescaler to 1024
  TC->CTRLA.reg |= TC_CTRLA_PRESCALER_DIV64;
  while (TC->STATUS.bit.SYNCBUSY == 1);

  setTimerFrequency(frequencyHz);

  // Enable the compare interrupt
  TC->INTENSET.reg = 0;
  TC->INTENSET.bit.MC0 = 1;

  NVIC_EnableIRQ(TC3_IRQn);

  TC->CTRLA.reg |= TC_CTRLA_ENABLE;
  while (TC->STATUS.bit.SYNCBUSY == 1);
}

#define BUFFER_SIZE 25000
byte buffer[BUFFER_SIZE];
byte *anaHead = &buffer[0];
byte *sdHead = &buffer[0];

uint16_t anaVal;

const long limit = 2 * sampleRate;
long counter = limit;
bool saveToCard = 0;

void TC3_Handler() {
  TcCount16* TC = (TcCount16*) TC3;
  // If this interrupt is due to the compare register matching the timer count
  // we toggle the LED.
  if (TC->INTFLAG.bit.MC0 == 1) {
    TC->INTFLAG.bit.MC0 = 1;
    digitalWrite(2, HIGH);
    anaVal = anaRead();
    
    *anaHead = anaVal&0xFF;
    ++anaHead;
    *anaHead = (anaVal>>8)&0xFF;
    ++anaHead;
    if(anaHead >= &buffer[BUFFER_SIZE-1]){
      anaHead = &buffer[0];
    }
    
    digitalWrite(2, LOW);
    saveToCard = digitalRead(7);
    if(!saveToCard){
      if (counter < limit){
        ++counter;
      }
    }
    else{
      counter = 0;
    }
  }
}

// This is an C/C++ code to insert repetitive code sections in-line pre-compilation
// Wait for synchronization of registers between the clock domains
// ADC
static __inline__ void ADCsync() __attribute__((always_inline, unused));
static void   ADCsync() {
  while (ADC->STATUS.bit.SYNCBUSY == 1); //Just wait till the ADC is free
}

// DAC
static __inline__ void DACsync() __attribute__((always_inline, unused));
static void DACsync() {
  while (DAC->STATUS.bit.SYNCBUSY == 1);
}

// Variables defined
uint32_t Status = 0x00000000;
uint32_t ulPin = A1;      //This is the analog pin to read
uint32_t val = 0;           // variable to store the value read



void setup()
{
  SD.begin(8);
  sdInit();
  pinMode(PIN, OUTPUT);        // setup timing marker

  //###################################################################################
  // ADC setup stuff
  //###################################################################################
  ADCsync();
  ADC->INPUTCTRL.bit.GAIN = ADC_INPUTCTRL_GAIN_1X_Val;      // Gain select as 1X
  ADC->REFCTRL.bit.REFSEL = ADC_REFCTRL_REFSEL_INTVCC0_Val; //  2.2297 V Supply VDDANA

  
  // Set sample length and averaging
  ADCsync();
  ADC->AVGCTRL.reg = 0x00 ;       //Single conversion no averaging
  ADCsync();
  ADC->SAMPCTRL.reg = 0x0A;  ; //sample length in 1/2 CLK_ADC cycles Default is 3F
  
  //Control B register
  int16_t ctrlb = 0x400;       // Control register B hibyte = prescale, lobyte is resolution and mode 
  ADCsync();
  ADC->CTRLB.reg =  ctrlb     ; 
  anaRead();  //Discard first conversion after setup as ref changed


  pinMode(2, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(7, INPUT);
  startTimer(sampleRate);
}





int curHeadPos;
int newPos;
bool hasSaved = 1;
void loop()
{
  if(counter >= limit){
    if(!hasSaved){
      makeHeader(myFile.size());
      myFile.flush();
      myFile.close();
      sdInit();
      hasSaved = 1;
    }
  }
  else{
    hasSaved = 0;
    int numBytes = anaHead - sdHead;
    if(numBytes >0){
      digitalWrite(5, HIGH);
      myFile.write(sdHead, numBytes);
      digitalWrite(5,LOW);
      sdHead += numBytes;
    }
    else
    {
      if(numBytes!=0)
      {
        numBytes += BUFFER_SIZE;
        curHeadPos = sdHead - &buffer[0];
        newPos = numBytes - (BUFFER_SIZE - curHeadPos);
        digitalWrite(5, HIGH);
        myFile.write(&buffer[curHeadPos], BUFFER_SIZE - curHeadPos);
        myFile.write(&buffer[0], newPos);
        digitalWrite(5, LOW);
        sdHead = &buffer[newPos];
      }
    }
  }
}

//##############################################################################
// Stripped-down fast analogue read anaRead()
// ulPin is the analog input pin number to be read.
////##############################################################################
uint16_t anaRead() {

  ADCsync();
  ADC->INPUTCTRL.bit.MUXPOS = g_APinDescription[ulPin].ulADCChannelNumber; // Selection for the positive ADC input

  ADCsync();
  ADC->CTRLA.bit.ENABLE = 0x01;             // Enable ADC

  ADC->INTFLAG.bit.RESRDY = 1;              // Data ready flag cleared

  ADCsync();
  ADC->SWTRIG.bit.START = 1;                // Start ADC conversion

  while ( ADC->INTFLAG.bit.RESRDY == 0 );   // Wait till conversion done
  ADCsync();
  uint16_t valueRead = ADC->RESULT.reg;

  ADCsync();
  ADC->CTRLA.bit.ENABLE = 0x00;             // Disable the ADC 
  ADCsync();
  ADC->SWTRIG.reg = 0x01;                    //  and flush for good measure
  return valueRead;
}
//##############################################################################

