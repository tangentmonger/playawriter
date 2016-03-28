/*
Detect the rotation of the wheel, using a magnet on each spoke
and a reed switch on the frame. Flash the LED on every full 
rotation.
*/

#include "font.h"

int reedSwitchPin = 2;
int LEDPin = 13; // the number of the output pin

int state = HIGH; // the current debounced state of the output pin

long last_time = 0; // the last time the state was toggled
long debounce = 5; // the debounce time
int SPOKES = 10; // number of spokes
int spoke = 0; // spoke nearest the switch

void setup()
{
    pinMode(reedSwitchPin, INPUT);
    pinMode(LEDPin, OUTPUT);
}

void loop()
{
    int reading = digitalRead(reedSwitchPin);
    long now = millis();

    if (state == LOW && reading == HIGH && now - last_time > debounce) {
        state = HIGH;
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
}
