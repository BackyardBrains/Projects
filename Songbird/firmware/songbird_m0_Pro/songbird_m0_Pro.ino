#include <RTClib.h>

//  Test routine heavily inspired by wiring_analog.c from GITHUB site
// Global preamble
#include "Arduino.h"
#include "wiring_private.h"
#include <SD.h>
#include "DHT.h"
#define DHTPIN 3
#define DHTTYPE DHT22
#define recordPin 11
#define sdPin 13
DHT dht(DHTPIN, DHTTYPE);
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

bool isLEDOn = false;

//This sets the sample rate for analog sampling
#define sampleRate 24000
void setTimerFrequency(int frequencyHz) {
  int compareValue = (CPU_HZ / (TIMER_PRESCALER_DIV * frequencyHz)) - 1;
  TcCount16* TC = (TcCount16*) TC3;
  // Make sure the count is in a proportional position to where it was
  // to prevent any jitter or disconnect when changing the compare value.
  TC->COUNT.reg = map(TC->COUNT.reg, 0, TC->CC[0].reg, 0, compareValue);
  TC->CC[0].reg = compareValue;
  while (TC->STATUS.bit.SYNCBUSY == 1);
}

//Initializs the Real-time Clock
RTC_DS1307 rtc;
//Gets the current timestamp in a format that can be used later by the SD library
void dateTime(uint16_t* date, uint16_t* time) {
 DateTime now = rtc.now();
 
 *date = FAT_DATE(now.year(), now.month(), now.day());

 // return time using FAT_TIME macro to format fields
 *time = FAT_TIME(now.hour(), now.minute(), now.second());
}

File myFile;
String filename = "BIRD0.WAV";
int fileNum = 0;
bool fileOpen = 0;

//Opens a new file on the sd-card for writing
void sdInit(){
  Serial.begin(9600);

  //Get Environmental Data
  float temp = dht.readTemperature();
  float hum = dht.readHumidity();

  //Loop ensures that files won't be overwritten on the card in the device is reset
  while(SD.exists(filename)){
    ++fileNum;
    filename = "BIRD" + (String)fileNum + ".WAV";
  }

  //Set file creation date and open for writing
  SdFile::dateTimeCallback(dateTime);
  myFile = SD.open(filename, FILE_WRITE);

  if(!myFile){
    Serial.println("Open file fail - sdINIT");
    while(1);
  }
  else{
    //The 1st 44 bytes of a wav file are the header, this will be written later
    myFile.seek(44);
    fileOpen = 1;
    //Turn of the led connected to pin 13 to indicate that it is unsafe to remove the card
    digitalWrite(sdPin, !fileOpen);
  }

  Serial.end();
}

//This function creates a header for the wav file and writes it to the 1st 44 bytes of the currently open file
void makeHeader(int totalAudioLen){
  
  float t = dht.readTemperature();
  float h = dht.readHumidity();

  String temperature = (String)t;
  String humidity = (String)h;
 
  byte metaData[36];
  metaData[0] = 'L';
  metaData[1] = 'I';
  metaData[2] = 'S';
  metaData[3] = 'T';
  metaData[4] = 0x1;
  metaData[5] = 0x1C;
  metaData[6] = 0;
  metaData[7] = 0;
  metaData[8] = 'I';
  metaData[9] = 'N';
  metaData[10] = 'F';
  metaData[11] = 'O';
  metaData[12] = 'T';
  metaData[13] = 'E';
  metaData[14] = 'M';
  metaData[15] = 'P';
  metaData[16] = 4;
  metaData[17] = 0;
  metaData[18] = 0;
  metaData[19] = 0;
  metaData[20] = 0;
  metaData[21] = 0;
  metaData[22] = 0;
  metaData[23] = 0;
  
  int j=20;
  for(int i=0; i<temperature.length(); ++i){
    metaData[j] = temperature[i];
    ++j;
  }
  
  metaData[24] = 'H';
  metaData[25] = 'U';
  metaData[26] = 'M';
  metaData[27] = 'I';
  metaData[28] = 4;
  metaData[29] = 0;
  metaData[30] = 0;
  metaData[32] = 0;
  metaData[33] = 0;
  metaData[34] = 0;
  metaData[35] = 0;

  int k=32;
  for(int l=0; l<humidity.length(); ++l){
    metaData[k] = humidity[l];
    ++k;
  }
  

  myFile.write(metaData, 36);
  
  const int compressionType = 1;
  const int numOfChannels = 1;
  const int byteRate = (sampleRate * numOfChannels * 16) / 8;
  const int totalDataLen = myFile.size();

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
//Function starts the timer which will trigger an interrupt at the set sample rate to sample from the analog pin
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

//The buffer stores audio data until it can be written to the card
#define BUFFER_SIZE 25000
byte buffer[BUFFER_SIZE];
byte *anaHead = &buffer[0];
byte *sdHead = &buffer[0];

uint16_t anaVal;

const long limit = 2 * sampleRate;
long counter = limit;
bool saveToCard = 0;

//Interrupt triggered by the timer at the set sample rate; Takes one analog sample and adds it to the buffer
void TC3_Handler() {
  TcCount16* TC = (TcCount16*) TC3;
  // If this interrupt is due to the compare register matching the timer count
  // we toggle the LED.
  if (TC->INTFLAG.bit.MC0 == 1) {
    TC->INTFLAG.bit.MC0 = 1;
    //digitalWrite(2, HIGH);
    
    //Does a single read from the analog pin and adds it to the buffer
    anaVal = anaRead();
    
    *anaHead = anaVal&0xFF;
    ++anaHead;
    *anaHead = (anaVal>>8)&0xFF;
    ++anaHead;
    if(anaHead >= &buffer[BUFFER_SIZE-1]){
      anaHead = &buffer[0];
    }
    
    //digitalWrite(2, LOW);
    //reads from the activity detector (sound threshold) on pin 7 
    //Increments a counter that will reach it's maximum value after 2 seconds of inactivity
    //This will be used later to trigger the end of the recording
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


bool doRecord = 1;

//Interrupt function to set the variable that determines whether we should continue recording after the current file
bool buttonPressed = 0; //Keeps track of whether the stop button has been pressed since the end of the last recording
void recordToggle(){
  if(!buttonPressed){
    doRecord = !doRecord;
    buttonPressed = 1;
  }
}

void setup()
{
  dht.begin();
  digitalWrite(recordPin, LOW);
  //Sets the rtc if it's not running
  if(!rtc.begin()){
    Serial.begin(9600);
    Serial.println("RTC cannot start");
    Serial.end();
  }
  if(!rtc.isrunning()){
    rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
    //If the rtc loses power at any point it will reset back to the time when this sketch was compiled
  }
  
  //Initialize the sd card and the sd-activity led on pin 13
  pinMode(sdPin, OUTPUT);
  pinMode(recordPin, OUTPUT);
  digitalWrite(sdPin,LOW);
  digitalWrite(recordPin, LOW);
  if(!SD.begin(8)){
    Serial.begin(9600);
    Serial.println("Cannot connect to SD Card");
    Serial.end();
    digitalWrite(sdPin,HIGH);
    while(1);
  }
  
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

  //Start reading from the activity detection pin and start sampling from the analog pin
  pinMode(7, INPUT);
  startTimer(sampleRate);
  //Attaches an interrupt to the button on pin 12 to flip a variable that will tell the device not to open a new file after the current 
  //one finishes, so the sd-card can be safely removed
  attachInterrupt(digitalPinToInterrupt(12), recordToggle, RISING);
}





int curHeadPos;
int newPos;
bool hasSaved = 1;
void loop()
{
  if(fileOpen){
    //When 2 seconds of inactivity has passed this will finish the file by adding the header then closing the file
    //If the stop button (d12) has not been pressed it will open a new file for writing
    if(counter >= limit){
      if(!hasSaved || !doRecord){
        makeHeader(myFile.size()-44);
        myFile.flush();
        myFile.close();
        digitalWrite(recordPin, LOW);
        fileOpen = 0;
        digitalWrite(sdPin, !fileOpen);
        if(doRecord){
          sdInit();
        }
        hasSaved = 1;
        buttonPressed = 0;
      }
    }
    //When less than 2 seconds of inactivity has passed this will write data from the buffer to the currently open file
    else{
      digitalWrite(recordPin, HIGH);
      hasSaved = 0;
      int numBytes = anaHead - sdHead;
      if(numBytes >0){
        //digitalWrite(5, HIGH);
        myFile.write(sdHead, numBytes);
        //digitalWrite(5,LOW);
        sdHead += numBytes;
      }
      else
      {
        if(numBytes!=0)
        {
          numBytes += BUFFER_SIZE;
          curHeadPos = sdHead - &buffer[0];
          newPos = numBytes - (BUFFER_SIZE - curHeadPos);
          //digitalWrite(5, HIGH);
          myFile.write(&buffer[curHeadPos], BUFFER_SIZE - curHeadPos);
          myFile.write(&buffer[0], newPos);
          //digitalWrite(5, LOW);
          sdHead = &buffer[newPos];
        }
      }
    }
  }
  //This should restart recording if the button on d12 is pressed again after recording has stopped
  else if(doRecord){
    sdInit();
    buttonPressed = 0;
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


