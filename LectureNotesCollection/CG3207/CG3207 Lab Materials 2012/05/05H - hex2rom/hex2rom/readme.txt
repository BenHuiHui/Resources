This program converts Intel hex format file into the rom format for CG3207/EE3207e project.
The .exe Works only on Microsoft Windows, and has been tested on the lab computers. For other platforms, the source file is given, and you can compile yourself using your own compiler.

_____

Instruction on running:
1. open a command prompt by running "cmd"
2. navigate to the directory with this program "hex2rom.exe" and your hex file
3. run "hex2rom.exe myfile.hex", substitute your hex file name
4. a file named "romcontent.txt" is generated in the same directory. Open it, and copy the content into your int_rom.vhdl

_____

Example:

Suppose the folder where the "hex2rom.exe" and "myfile.hex" is at "c:\my_cg3207_folder"

Open command prompt

Type "cd c:\my_cg3207_folder"

Then type "hex2rom.exe myfile.hex"

The rom file will be created. All the hex codes can be copied directly to the int_rom.vhdl file