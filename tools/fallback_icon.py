"""备用图标生成：CDN 下载失败时在 CI 里画一个 1024×1024 的 App 图标。

用法： python3 tools/fallback_icon.py 输出路径.png
"""
import sys
from PIL import Image, ImageDraw

W = 1024
BG = (27, 42, 65)
WHITE = (255, 255, 255)
ORANGE = (243, 146, 55)

img = Image.new("RGB", (W, W), BG)
d = ImageDraw.Draw(img)

# 相机机身 + 顶部取景凸起
d.rounded_rectangle([170, 330, 854, 770], radius=64, fill=WHITE)
d.rounded_rectangle([376, 250, 648, 348], radius=32, fill=WHITE)
# 镜头
d.ellipse([344, 384, 680, 720], fill=BG)
d.ellipse([398, 438, 626, 666], fill=WHITE)
# 机身左下角的橙色扳手示意
d.rounded_rectangle([246, 686, 420, 730], radius=20, fill=ORANGE)
d.ellipse([222, 674, 268, 720], fill=ORANGE)

out = sys.argv[1] if len(sys.argv) > 1 else "AppIcon-1024.png"
img.save(out, "PNG")
print("fallback icon ->", out)
