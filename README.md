stole an fpga for ts.

What this supposed to do:

Loads BRAM with hex files (audio) IP and coe (not done yet) -> puts that in a BRAM controller with uart configuration for each sample (hex 8 bit stuff) -> uses switches to alter the type of sound effect needed -> puts that into the i2s protocal transmitter to your audio dac of choise

in other words:
pre loaded audio samples stored into BRAM blocks which are outputted to the dac if a keyborad is pressed. the switches on the fpga are for sound effects like bit crushing to make your sound like crinkly or something or decrease volume. pitch and echo coming soon

eli5:
button make sound. sound play. switch on, button push, sound different x4. switch can volume up or other switch can make bit crush.

parts:
-solder
-fpga
-pcm5102 dac
-wires

trunk full of old 100s
