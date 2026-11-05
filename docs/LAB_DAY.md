# Lab-day test sheet (10 minutes)

**Need:** Arduino Uno or Nano, 0.96" SSD1306 OLED (I2C, 4 pins), 4 jumper wires, the Arduino IDE with "Adafruit SSD1306" and "Adafruit GFX Library" installed.

1. Wire: OLED VCC → 5V, GND → GND, SDA → A4, SCL → A5.
2. Open `arduino/oled_path/oled_path.ino`, upload. Serial Monitor at 115200: expect `oled_path: drawing the planned path`. (If it says `SSD1306 not found at 0x3C`, try address 0x3D in `display.begin`.)
3. Expect on the display: the room's border, three filled circles, five small crosses (the waypoints), the dotted path, and a triangle driving from left to right in about 5 s, leaving a solid line behind it, pointing along the path at every moment.
4. Compare with `docs/img/oled_preview.png`: the same picture.

**Record:** a short video (5 s) of one run and a photo of the display.

Before the lab day the same sketch can be run in the browser: create an Arduino Uno project at wokwi.com, paste the sketch, `path_data.h`, `wokwi/diagram.json` and `wokwi/libraries.txt`.
