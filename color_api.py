from flask import Flask, request, jsonify
import cv2
import numpy as np
from sklearn.cluster import KMeans
from collections import Counter
import colorsys

app = Flask(__name__)

# ========== Functions ==========

def get_central_crop(image, crop_percent=0.6):
    h, w, _ = image.shape
    ch = int(h * crop_percent)
    cw = int(w * crop_percent)
    start_y = (h - ch) // 2
    start_x = (w - cw) // 2
    return image[start_y:start_y + ch, start_x:start_x + cw]

def get_dominant_color(image_bytes, k=3):
    npimg = np.frombuffer(image_bytes, np.uint8)
    image = cv2.imdecode(npimg, cv2.IMREAD_COLOR)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    image = get_central_crop(image)
    image = cv2.resize(image, (150, 150))

    pixels = image.reshape(-1, 3)
    kmeans = KMeans(n_clusters=k)
    kmeans.fit(pixels)

    counts = Counter(kmeans.labels_)
    center_colors = kmeans.cluster_centers_
    dominant = center_colors[counts.most_common(1)[0][0]]

    return tuple(map(int, dominant))

def rgb_to_hex(rgb):
    return '#%02x%02x%02x' % rgb

def rgb_to_hsv(rgb):
    r, g, b = [x / 255.0 for x in rgb]
    return colorsys.rgb_to_hsv(r, g, b)

def hsv_to_rgb(hsv):
    r, g, b = colorsys.hsv_to_rgb(*hsv)
    return tuple(int(x * 255) for x in (r, g, b))

def get_complementary_color(rgb):
    h, s, v = rgb_to_hsv(rgb)
    h = (h + 0.5) % 1.0
    return hsv_to_rgb((h, s, v))

def get_monochromatic_colors(rgb, variations=3):
    h, s, v = rgb_to_hsv(rgb)
    results = []
    for i in range(1, variations + 1):
        factor = 1 - (i * 0.15)
        new_v = max(0, min(1, v * factor))
        results.append(hsv_to_rgb((h, s, new_v)))
    return results

# ========== Color ==========

css_colors = {
    "black": (0, 0, 0),
    "white": (255, 255, 255),
    "off white": (250, 250, 245),
    "ivory": (255, 255, 240),
    "linen": (250, 240, 230),
    "seashell": (255, 245, 238),
    "snow": (255, 250, 250),
    "floral white": (255, 250, 240),
    "ghost white": (248, 248, 255),
    "mint cream": (245, 255, 250),
    "honeydew": (240, 255, 240),
    "azure": (240, 255, 255),
    "white smoke": (245, 245, 245),
    "gainsboro": (220, 220, 220),
    "cream white": (255, 253, 208),
    "eggshell": (252, 234, 187),
    "pearl": (234, 224, 200),
    "red": (255, 0, 0),
    "green": (0, 128, 0),
    "blue": (0, 0, 255),
    "yellow": (255, 255, 0),
    "gold": (255, 215, 0),
    "lemon": (255, 247, 0),
    "mustard": (255, 219, 88),
    "flax": (238, 220, 130),
    "light khaki": (240, 230, 140),
    "light goldenrod": (250, 250, 210),
    "moccasin": (255, 228, 181),
    "cornsilk": (255, 248, 220),
    "cream": (255, 253, 208),
    "vanilla": (243, 229, 171),
    "buff": (240, 220, 130),
    "daffodil": (255, 255, 49),
    "canary yellow": (255, 239, 0),
    "school bus yellow": (255, 216, 0),
    "orange": (255, 165, 0),
    "gray": (128, 128, 128),
    "purple": (128, 0, 128),
    "hot pink": (255, 105, 180),
    "light pink": (255, 182, 193),
    "deep pink": (255, 20, 147),
    "tan": (210, 180, 140),
    "burlywood": (222, 184, 135),
    "wheat": (245, 222, 179),
    "saddle brown": (139, 69, 19),
    "rosy brown": (188, 143, 143),
    "indigo": (75, 0, 130),
    "violet": (143, 0, 255),
    "lavender": (230, 230, 250),
    "orchid": (218, 112, 214),
    "thistle": (216, 191, 216),
    "plum": (221, 160, 221),
    "amethyst": (153, 102, 204),
    "heliotrope": (223, 115, 255),
    "mauve": (224, 176, 255),
    "periwinkle": (204, 204, 255),
    "wisteria": (201, 160, 220),
    "lilac": (200, 162, 200),
    "pale purple": (230, 190, 255),
    "pastel violet": (203, 153, 201),
    "sienna": (160, 82, 45),
    "peru": (205, 133, 63),
    "chocolate": (210, 105, 30),
    "sandy brown": (244, 164, 96),
    "beaver": (159, 129, 112),
    "raw umber": (115, 74, 18),
    "mocha": (150, 93, 62),
    "coffee": (111, 78, 55),
    "camel": (193, 154, 107),
    "taupe": (72, 60, 50),
    "pink": (255, 192, 203),
    "brown": (139, 69, 19),
    "dark green": (34, 139, 34),
    "light green": (144, 238, 144),
    "beige": (245, 245, 220),
    "khaki": (195, 176, 145),
    "cream": (255, 253, 208),
    "olive": (128, 128, 0),
    "maroon": (128, 0, 0),
    "navy": (0, 0, 128),
    "teal": (0, 128, 128),
    "turquoise": (64, 224, 208),
    "rosy brown": (188, 143, 143),
    "lavender blush": (255, 240, 245),
    "misty rose": (255, 228, 225),
    "pale violet red": (219, 112, 147),
    "light salmon": (255, 160, 122),
    "salmon": (250, 128, 114),
    "thistle": (216, 191, 216),
    "charcoal": (54, 69, 79),
    "jet": (52, 52, 52),
    "onyx": (53, 56, 57),
    "dark slate gray": (47, 79, 79),
    "eerie black": (27, 27, 27),
    "outer space": (65, 74, 76),
    "raisin black": (36, 33, 36),
    "gunmetal": (42, 52, 57),
    "black olive": (59, 60, 54),
    "dim gray": (105, 105, 105),
    "navy blue": (0, 0, 128),
    "midnight blue": (25, 25, 112),
    "royal blue": (65, 105, 225),
    "steel blue": (70, 130, 180),
    "cadet blue": (95, 158, 160),
    "cornflower blue": (100, 149, 237),
    "light steel blue": (176, 196, 222),
    "slate blue": (106, 90, 205),
    "powder blue": (176, 224, 230),
    "baby blue": (137, 207, 240),
    "alice blue": (240, 248, 255),
    "air force blue": (93, 138, 168),
    "denim": (21, 96, 189),
    "periwinkle": (204, 204, 255),
    "dusty blue": (119, 158, 203),
    "black": (0, 0, 0),
    "jet black": (52, 52, 52),
    "charcoal": (54, 69, 79),
    "onyx": (53, 56, 57),
    "eerie black": (27, 27, 27),
    "outer space": (65, 74, 76),
    "raisin black": (36, 33, 36),
    "licorice": (26, 17, 16),
    "smoky black": (16, 12, 8),
    "gunmetal": (42, 52, 57),
    "rich black": (0, 64, 64),
    "dim gray": (105, 105, 105),
    "taupe": (72, 60, 50),
    "dark slate gray": (47, 79, 79),
    "deep space sparkle": (74, 100, 108),
    "red": (255, 0, 0),
    "crimson": (220, 20, 60),
    "scarlet": (255, 36, 0),
    "vermilion": (227, 66, 52),
    "cherry red": (222, 49, 99),
    "ruby": (224, 17, 95),
    "carmine": (150, 0, 24),
    "fire engine red": (206, 32, 41),
    "rose": (255, 0, 127),
    "raspberry": (227, 11, 93),
    "burgundy": (128, 0, 32),
    "oxblood": (75, 0, 0),
    "brick red": (203, 65, 84),
    "tomato": (255, 99, 71),
    "bittersweet": (254, 111, 94),
    "light gray": (211, 211, 211),
    "dark gray": (169, 169, 169),
    "dim gray": (105, 105, 105),
    "slate gray": (112, 128, 144),
    "cool gray": (140, 146, 172),
    "warm gray": (149, 140, 132),
    "charcoal": (54, 69, 79),
    "ash gray": (178, 190, 181),
    "gainsboro": (220, 220, 220),
    "smoke": (115, 130, 118),
    "granite": (103, 103, 103),
    "silver": (192, 192, 192),
    "platinum": (229, 228, 226),
    "pewter": (139, 139, 131),
    "tangerine": (242, 133, 0),
    "pumpkin": (255, 117, 24),
    "amber": (255, 191, 0),
    "burnt orange": (204, 85, 0),
    "carrot orange": (237, 145, 33),
    "dark orange": (255, 140, 0),
    "coral": (255, 127, 80),
    "persimmon": (236, 88, 0),
    "bittersweet": (254, 111, 94),
    "apricot": (251, 206, 177),
    "melon": (253, 188, 180),
    "vermilion": (227, 66, 52),
    "flame": (226, 88, 34),
    "persian orange": (217, 144, 88),
    "light beige": (245, 245, 220),
    "linen": (250, 240, 230),
    "light taupe": (210, 200, 190),
    "peach puff": (255, 218, 185),
    "misty rose": (255, 228, 225),
    "blanched almond": (255, 235, 205),
    "papaya whip": (255, 239, 213),
    "moccasin": (255, 228, 181),
    "wheat": (245, 222, 179),
    "light salmon": (255, 160, 122),
    "light coral": (240, 128, 128),
    "thistle": (216, 191, 216),
    "light steel blue": (176, 196, 222),
    "powder blue": (176, 224, 230),
    "pale turquoise": (175, 238, 238),
    "light goldenrod yellow": (250, 250, 210),
    "light khaki": (240, 230, 140),
    "pale green": (152, 251, 152),
    "glaucous": (96, 130, 182),
    "feldgrau": (77, 93, 83),
    "wenge": (100, 84, 82),
    "smalt": (0, 51, 153),
    "falu red": (128, 24, 24),
    "caput mortuum": (89, 39, 32),
    "amaranth": (229, 43, 80),
    "gamboge": (228, 155, 15),
    "zinnwaldite brown": (44, 22, 8),
    "pistachio": (147, 197, 114),
    "malachite": (11, 218, 81),
    "coquelicot": (255, 56, 0),
    "aero": (124, 185, 232),
    "mikado yellow": (255, 196, 12),
    "russian violet": (50, 23, 77),
    "razzmatazz": (227, 37, 107),
    "eburnean": (255, 255, 245),
    "xanadu": (115, 134, 120),
    "french beige": (166, 123, 91),
    "byzantium": (112, 41, 99),
    "argentin": (201, 192, 187),
    "vermilion red": (233, 66, 66),
    "phthalo blue": (0, 15, 137),
    "celadon": (172, 225, 175),
    "peridot": (230, 226, 0),
    "sinopia": (203, 65, 11),
    "azurite": (0, 93, 135),
    "bistre": (61, 43, 31),
    "isabelline": (244, 240, 236),
    "taupe gray": (139, 133, 137),
    "flax": (238, 220, 130),
    "ecru": (194, 178, 128),
    "rosewood": (101, 0, 11),
    "ebony": (85, 93, 80),
    "heliotrope gray": (170, 152, 169),
    "persian green": (0, 166, 147),
    "rufous": (168, 28, 7),
    "payne's gray": (83, 104, 120),
    "naples yellow": (250, 218, 94),
    "amber brown": (150, 113, 23),
    "cordovan": (137, 63, 69),
    "liver": (103, 76, 71),
    "old gold": (207, 181, 59),
    "antique fuchsia": (145, 92, 131),
    "pomp and power": (134, 96, 142),
    "raisin": (88, 58, 60),
    "seal brown": (50, 20, 20),
    "burnt sienna": (233, 116, 81),
    "pale chestnut": (221, 173, 175),
    "champagne pink": (241, 221, 207),
    "tea green": (208, 240, 192),
    "cambridge blue": (163, 193, 173),
    "mountbatten pink": (153, 122, 141),
    "rose ebony": (103, 72, 70),
    "ash gray": (178, 190, 181),
    "antique bronze": (102, 93, 30),
    "pale silver": (201, 192, 187),
    "english vermilion": (204, 71, 75),
    "tuscan red": (124, 72, 72),
    "feldspar": (253, 213, 177),
    "harlequin": (63, 255, 0),
    "fandango": (181, 51, 137),
    "icterine": (252, 247, 94),
    "mindaro": (227, 249, 136),
    "jonquil": (244, 202, 22),
    "blue yonder": (80, 114, 167),
    "platinum": (229, 228, 226),
    "antique white": (250, 235, 215),
    "desert sand": (237, 201, 175),
    "tumbleweed": (222, 170, 136),
    "grullo": (169, 154, 134),
    "pearl": (234, 224, 200),
    "stormcloud": (79, 102, 106),
    "alice blue": (240, 248, 255),
    "caribbean green": (0, 204, 153),
    "medium orchid": (186, 85, 211),
    "light periwinkle": (197, 203, 225),
    "moonstone blue": (115, 169, 194),
    "bleu de france": (49, 140, 231),
    "prussian blue": (0, 49, 83),
    "languid lavender": (214, 202, 221),
    "aegean blue": (28, 57, 187),
    "desire": (234, 60, 83),
    "beaver": (159, 129, 112),
    "puce": (204, 136, 153),
    "moss green": (138, 154, 91),
    "feldspar pink": (248, 201, 195),
    "tea rose": (248, 131, 121),
    "nyanza": (233, 255, 219),
    "outer space": (65, 74, 76),
    "viridian": (64, 130, 109),
    "rose gold": (183, 110, 121),
    "dim lavender": (148, 129, 183),
    "twilight lavender": (138, 73, 107),
    "amaranth pink": (241, 156, 187),
    "lapis lazuli": (38, 97, 156),
    "umber": (99, 81, 71),
    "onyx": (53, 56, 57),
    "taupe rose": (183, 145, 131),
    "deep champagne": (250, 214, 165),
}

def closest_webcolor_name(rgb):
    min_dist = float('inf')
    closest = "unknown"
    for name, ref_rgb in css_colors.items():
        dist = sum((c1 - c2) ** 2 for c1, c2 in zip(rgb, ref_rgb))
        if dist < min_dist:
            min_dist = dist
            closest = name
    return closest



# ========== Flask API ==========

@app.route('/detect-color', methods=['POST'])
def detect_color():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400

    image = request.files['image'].read()
    rgb = get_dominant_color(image)
    hex_color = rgb_to_hex(rgb)
    name = closest_webcolor_name(rgb)
    comp = get_complementary_color(rgb)
    mono = get_monochromatic_colors(rgb)

    return jsonify({
        "color": name,
        "rgb": rgb,
        "hex": hex_color,
        "complementary": comp,
        "monochromatic": mono
    })

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5050)
