"""
Given a font, generate a C file that can be included in an
Arduino project to provide that font as a bitmap.

Python 3
"""
from PIL import ImageFont
from PIL import Image
from PIL import ImageDraw
import os

LETTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,?!()'-=+:;@"
OUTPUT_LOCATION = os.path.join("arduino", "src")
print(OUTPUT_LOCATION)
# TODO: handle quote marks
os.makedirs(OUTPUT_LOCATION, exist_ok=True)

#load font

#no TTF, they get antialiased!
#font = ImageFont.load("fonts/helvB08.pil") #13, clear, sans
#font = ImageFont.load("fonts/charR08.pil") #14, thin, serif
#font = ImageFont.load("fonts/courB10.pil") #16, messy, serif
#font = ImageFont.load("fonts/helvR08.pil") #13, messy, serif
#font = ImageFont.load("fonts/lubB08.pil") #13, messy, serif
#font = ImageFont.load("fonts/lutBS08.pil") #11, messy, sans
#font = ImageFont.load("fonts/ncenR08.pil") #11, messy, serif, Amiga?
#font = ImageFont.load("fonts/symb08.pil") #no, symbols
#font = ImageFont.load("fonts/timR08.pil") #12, thin

font = ImageFont.load("fonts/helvB10.pil") #17 (14 used), clear, sans
font = ImageFont.load("fonts/helvR10.pil") #17 (14 used), clear, sans
#font = ImageFont.load("fonts/helvB10.pil") #17 (14 used), clear, sans
#font = ImageFont.load("fonts/helvB08.pil") #13 (10 used), clear, sans
#font = ImageFont.load("fonts/helvR12.pil") #20 (17 used), clear, sans

TOP = 3 # unused pixels above text

def _chunk_list(data, width, filler=None):
    """
    Break a list into sublists of given width. If required, pad out final
    sublist using the filler item.
    """
    for i in range(0, len(data), width):
        if width > len(data) - i and filler is not None:
            yield data[i:i+width] + [filler] * (width - (len(data) - i))
        else:
            yield data[i:i+width]

letter_widths = []
letter_height = None
letter_data = []

#for each letter in the list
for letter in LETTERS:
    letter_lines = []
    
    # get its dimensions
    width, height = font.getsize(letter)
    letter_widths.append(width)
    letter_height = height
    
    # generate a white-on-black image of it
    img = Image.new("1", (width, height), 0)
    draw = ImageDraw.Draw(img)
    draw.text((0,0), letter, 1, font=font)
    img = img.rotate(90)

    # convert image to vertical line data
    raw_data = list(img.getdata())
    lines = list(_chunk_list(raw_data, height))
    for line in lines:
        line = line[TOP:] # remove top rows that are not used by these glyphs
        # represent each line as binary encoded value
        value = sum([bit * (2**index) for index, bit in enumerate(reversed(line))])
        letter_lines.append(value)
        #todo: keep value if it's zero (i.e. a whole vertical row that is empty?)
        #maybe it's for kerning?
        #careful about spaces then
    letter_data.append(letter_lines)


#generate the header file with all the font data            
with open(os.path.join(OUTPUT_LOCATION, "font.h"), 'w') as header_file: 
    print("const int LETTERS = %d;" % len(LETTERS), file=header_file)
    print("char letters[LETTERS+1] = \"%s\"; //null terminated" % LETTERS, file=header_file)
    print("int letter_height = %d;" % (letter_height - TOP), file=header_file)
    print("int letter_widths[LETTERS] = {%s};" % ",".join([str(len(letter)) for letter in letter_data]), file=header_file)
    print("", file=header_file)

    for index, letter in enumerate(letter_data):
        print("short letter_data_%d[] = {%s}; // %s" % (index, ",".join(str(line) for line in letter), LETTERS[index]), file=header_file)
    print("", file=header_file)

    print("short* letter_data[] = {%s};" % (",".join(["letter_data_%d" % i for i in range(len(letter_data)) ])), file=header_file)
