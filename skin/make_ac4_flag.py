"""Makes Estuary's audio codec flag for AC-4 (flags/audiocodec/ac4.png), in the style of the
others: the AAC flag's box, its text replaced by "AC-4" with capitals as tall as AAC's, in Noto
Sans (OFL) thickened by half a pixel to come near the other flags' weight.
    make_ac4_flag.py <estuary audiocodec folder> <NotoSans-Regular.ttf>"""
import sys

import numpy as np
from PIL import Image, ImageDraw, ImageFont

folder, font_file = sys.argv[1], sys.argv[2]
SCALE = 4                                       # drawn 4 times larger, then scaled down
STROKE = 2                                      # (2 pixels at 4x: half a pixel)

box = Image.open(folder + '/aac.png').convert('LA')
w, h = box.size

# the box stays; everything inside its 6-pixel line goes
inside = (16, 26, w - 16, h - 26)
box.paste(Image.new('LA', (inside[2] - inside[0], inside[3] - inside[1]), (0, 0)), inside[:2])

# "AC-4" with capitals as tall as AAC's (33 pixels, y 44 to 77), centered
size = 40 * SCALE
while True:
    font = ImageFont.truetype(font_file, size)
    cap = ImageDraw.Draw(Image.new('L', (1, 1))).textbbox((0, 0), 'AC', font=font, stroke_width=STROKE)
    if cap[3] - cap[1] >= 33 * SCALE:
        break
    size += 1
big = Image.new('L', (w * SCALE, h * SCALE), 0)
draw = ImageDraw.Draw(big)
tb = draw.textbbox((0, 0), 'AC-4', font=font, stroke_width=STROKE)
x = (w * SCALE - (tb[2] - tb[0])) / 2 - tb[0]
y = 44 * SCALE - cap[1]
draw.text((x, y), 'AC-4', font=font, fill=255, stroke_width=STROKE, stroke_fill=255)
text = big.resize((w, h), Image.LANCZOS)

# white throughout; the opacity is the box's and the text's together
alpha = np.maximum(np.array(box.getchannel('A')), np.array(text))
Image.merge('LA', (Image.new('L', (w, h), 255), Image.fromarray(alpha))).save(folder + '/ac4.png', optimize=True)
print('ac4.png written, font size', size / SCALE)
