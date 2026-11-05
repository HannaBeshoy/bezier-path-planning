/*
 * oled_path.ino - draws the planned path on a 0.96" SSD1306 OLED (128 x 64, I2C)
 * and drives a small car along it.
 *
 * Wiring (Arduino Uno or Nano): OLED VCC -> 5V, GND -> GND, SDA -> A4, SCL -> A5.
 * Libraries (Library Manager): "Adafruit SSD1306" and "Adafruit GFX Library".
 * The path comes from path_data.h, which run_all.m writes: 120 points evenly
 * spaced along the Bezier path, so the car moves at a constant speed, and the
 * heading at each point (the direction of the tangent vector).
 */
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Wire.h>
#include "path_data.h"

Adafruit_SSD1306 display(128, 64, &Wire, -1);

static void drawScene(uint8_t upto)
{
    display.clearDisplay();
    display.drawRect(0, 0, 128, 64, SSD1306_WHITE);                  // the room
    for (uint8_t i = 0; i < OBST_N; i++)
        display.fillCircle(pgm_read_byte(&OBST[i][0]), pgm_read_byte(&OBST[i][1]),
                           pgm_read_byte(&OBST[i][2]), SSD1306_WHITE);
    for (uint8_t i = 0; i < WAYPOINT_N; i++) {                      // waypoints as small crosses
        int x = pgm_read_byte(&WAYPOINT[i][0]), y = pgm_read_byte(&WAYPOINT[i][1]);
        display.drawPixel(x, y, SSD1306_WHITE);
        display.drawPixel(x - 1, y - 1, SSD1306_WHITE); display.drawPixel(x + 1, y + 1, SSD1306_WHITE);
        display.drawPixel(x - 1, y + 1, SSD1306_WHITE); display.drawPixel(x + 1, y - 1, SSD1306_WHITE);
    }
    for (uint8_t i = 0; i < PATH_N; i += 2)                          // the path, dotted
        display.drawPixel(pgm_read_byte(&PATH_X[i]), pgm_read_byte(&PATH_Y[i]), SSD1306_WHITE);
    for (uint8_t i = 1; i <= upto; i++)                              // the part already driven, solid
        display.drawLine(pgm_read_byte(&PATH_X[i - 1]), pgm_read_byte(&PATH_Y[i - 1]),
                         pgm_read_byte(&PATH_X[i]), pgm_read_byte(&PATH_Y[i]), SSD1306_WHITE);
}

static void drawCar(uint8_t i)
{
    // a triangle pointing along the tangent: heading 0..255 = one turn, y up in the world
    float a = pgm_read_byte(&PATH_HEADING[i]) * (2 * PI / 256.0);
    float cx = pgm_read_byte(&PATH_X[i]), cy = pgm_read_byte(&PATH_Y[i]);
    float dx = cos(a), dy = -sin(a);                                 // screen y points down
    display.fillTriangle(cx + 5 * dx, cy + 5 * dy,
                         cx - 3 * dx - 3 * dy, cy - 3 * dy + 3 * dx,
                         cx - 3 * dx + 3 * dy, cy - 3 * dy - 3 * dx, SSD1306_INVERSE);
}

void setup()
{
    Serial.begin(115200);
    if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
        Serial.println(F("SSD1306 not found at 0x3C: check the wiring"));
        for (;;) { }
    }
    Serial.println(F("oled_path: drawing the planned path"));
}

void loop()
{
    for (uint8_t i = 0; i < PATH_N; i++) {
        drawScene(i);
        drawCar(i);
        display.display();
        delay(40);                                                   // about 5 s per run
    }
    delay(1000);
}
