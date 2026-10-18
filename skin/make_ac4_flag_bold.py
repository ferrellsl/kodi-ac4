"""The AC-4 codec badge in the heavier style of skins like Estuary MOD V2 (HEVC, 16:9, 5.1 badges):
a thick white box with bold capitals filling most of it.  Noto Sans Bold (SIL OFL).
    make_ac4_flag_bold.py <out.png> <NotoSans-Bold.ttf>"""
import sys

import numpy as np
from PIL import Image, ImageDraw, ImageFont

out, font_file = sys.argv[1], sys.argv[2]
SCALE = 4
W, H = 270, 120                  # (the size of Estuary's codec badges; skins scale them to fit)
LINE = 9                         # box line
TEXT_H = 62                      # height of the capitals

big = Image.new('L', (W * SCALE, H * SCALE), 0)
draw = ImageDraw.Draw(big)
inset = 6 * SCALE
draw.rounded_rectangle((inset, inset, W * SCALE - inset, H * SCALE - inset), radius=6 * SCALE,
                       outline=255, width=LINE * SCALE)

size = 40 * SCALE
while True:
    font = ImageFont.truetype(font_file, size)
    cap = draw.textbbox((0, 0), 'AC', font=font)
    if cap[3] - cap[1] >= TEXT_H * SCALE:
        break
    size += 2
tb = draw.textbbox((0, 0), 'AC-4', font=font)
x = (W * SCALE - (tb[2] - tb[0])) / 2 - tb[0]
y = (H * SCALE - (cap[3] - cap[1])) / 2 - cap[1]
draw.text((x, y), 'AC-4', font=font, fill=255)

alpha = big.resize((W, H), Image.LANCZOS)
Image.merge('LA', (Image.new('L', (W, H), 255), alpha)).save(out, optimize=True)
print(out, 'written')
