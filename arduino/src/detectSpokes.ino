/*
Detect the rotation of the wheel, using a magnet on each spoke
and a reed switch on the frame. Flash the LED on every full 
rotation.
*/

//#include <avr/pgmspace.h>
#include <string.h>
#include "Adafruit_WS2801.h"
#include "font.h"

int reedSwitchPin = 2;
int LEDPin = 13; // built in LED
int LED_DATA_PIN = 4; // LED White wire 
int LED_CLOCK_PIN = 5; // LED Green wire

int state = HIGH; // the current debounced state of the output pin

long last_time = 0; // the last time the state was toggled
long debounce = 5; // the debounce time
int SPOKES = 10; // number of spokes
int spoke = 0; // spoke nearest the switch

char MESSAGE[] = " Hello world!";
int current_letter = 0;
unsigned short* current_letter_data; //16 bits
int current_line = 0;
int current_letter_width = 0;
int SPRAY_DURATION = 500; //ms
long spray_end_time;

int N_PIXELS = 16;
Adafruit_WS2801 strip = Adafruit_WS2801(N_PIXELS, LED_DATA_PIN, LED_CLOCK_PIN);

void setup()
{
    pinMode(reedSwitchPin, INPUT);
    pinMode(LEDPin, OUTPUT);
    Serial.begin(9600);
    Serial.println("OK");
    strip.begin();

}

void loop()
{
    long now = millis();

    // check for wheel movement
    int reading = digitalRead(reedSwitchPin);
    if (state == LOW && reading == HIGH && now - last_time > debounce) {
        state = HIGH;
        flash_next_line();
        last_time = now;    
        spoke++;
        if (spoke == SPOKES) {
            digitalWrite(LEDPin, HIGH);
            spoke = 0;
        } else {
            digitalWrite(LEDPin, LOW);
        }
    } else if (state == HIGH && reading == LOW && now - last_time > debounce) {
        state = LOW;
        last_time = now;
    }

    // useful for testing
    //digitalWrite(LEDPin, !reading);

    // turn off lights if it's time
    if (now >= spray_end_time) {
        clear_line();
    }
}

void flash_next_line()
{
    if (current_line >= current_letter_width - 1)
    {
        // advance to the next letter in the message
        if (MESSAGE[current_letter + 1] == NULL)
        {
            current_letter = 0; // repeat message, for now
        } else {
            current_letter++;
        }
        // load up letter data
        int current_letter_index = strchr(LETTER_INDEX, MESSAGE[current_letter]) - LETTER_INDEX;
        current_letter_data = LETTER_DATA[current_letter_index];
        current_letter_width = LETTER_WIDTHS[current_letter_index];
        current_line = 0;
        //Serial.println(MESSAGE[current_letter]);
    }
    
    // convert from digital to binary to get line pattern
    unsigned short line_value = current_letter_data[current_line];
    for(int i=0; i<N_PIXELS; i++)
    {
        bool bit_value = (line_value & ( 1 << i )) >> i;
        if (bit_value == true)
        {
            strip.setPixelColor(i, Color(0, 0, 80)); 
            //Serial.print("0 ");
        } else {
            strip.setPixelColor(i, Color(0, 0, 0)); 
            //Serial.print("  ");
        }
    }
    
    Serial.println();
    current_line++;
    strip.show();
    spray_end_time = millis() + SPRAY_DURATION;
}

void clear_line()
{
    for(int i=0; i<N_PIXELS; i++)
    {
        strip.setPixelColor(i, Color(0, 0, 0)); 
    }
    strip.show();
}

// Create a 24 bit color value from R,G,B
uint32_t Color(byte r, byte g, byte b)
{
    uint32_t c;
    c = r;
    c <<= 8;
    c |= g;
    c <<= 8;
    c |= b;
    return c;
}

