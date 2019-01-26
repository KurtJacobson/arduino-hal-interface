//   HAL userspace component to interface with Arduino board
//   Copyright (C) 2007 Jeff Epler <jepler@unpythonic.net>
//
//   This program is free software; you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation; either version 2 of the License, or
//   (at your option) any later version.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of the GNU General Public License
//   along with this program; if not, write to the Free Software
//   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

void setup() {
    Serial.begin(9600);
}   

uint8_t adc=0;
uint8_t firstbyte=0;
uint8_t pinmap[6] = {2,4,7,8,12,13};
uint8_t dacpinmap[6] = {3,5,6,9,10,11};
void loop() {
  while(Serial.available()) {
        uint8_t byte = Serial.read();
        if(((firstbyte & 0x80) == 0x80) && ((byte & 0x80) == 0)) {
            // got a packet
            uint16_t payload = (firstbyte << 7) | byte;
            uint8_t address = (firstbyte >> 4) & 7;
            uint8_t dac = payload & 0xff;
            uint8_t dir = (payload & 0x100) == 0x100;
            uint8_t out = (payload & 0x200) == 0x200;
            if(address < 6) {
                analogWrite(dacpinmap[address], dac);
                digitalWrite(pinmap[address], out);
                pinMode(pinmap[address], dir);
            }
        }
        firstbyte = byte;
    }
    uint16_t v = analogRead(adc) | (adc << 11);
    if(digitalRead(pinmap[adc])) v |= (1<<10);
    Serial.print((v >> 7) | 0x80, BYTE);
    Serial.print(v & 0x7f, BYTE);
    adc = (adc + 1) % 6;
}
