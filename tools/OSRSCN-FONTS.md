# OSRSCN: choosing a Chinese font

Notes on how the OSRSCN RuneLite plugin ([Aoldbald/OSRS_CN_Runelite](https://github.com/Aoldbald/OSRS_CN_Runelite)) draws Chinese,
why some fonts look pixelated in-game, and the setup I ended up with. Everything here works in the **normal
Plugin Hub version** of OSRSCN, except the line-spacing setting, which is only in my fork. (For the text-to-speech fork, see `osrscn-tts/TTS-README.md`.)

Checked against plugin source at commit `c4f3061` (OSRSCN 0.3.1, 2026-09-22).

## My setup

| Setting | Value |
|---|---|
| 自定义字体 (custom font) | `C:\Users\Howard\.runelite\osrscn\fonts\ZhuqueFangsong-Regular.ttf` |
| 对话字号 (dialogue font size) | 17pt |
| 对话行距 (dialogue line spacing) | 0 px for now (my fork only; see "Line spacing" below) |

The font is **Zhuque Fangsong** (朱雀仿宋 Zhūquè fǎngsòng), a free, open-source font in the calligraphy-based
仿宋 style. At 17pt it had the lightest, most open shapes of the 9 fonts I compared, so characters stay
distinct across a line.

How I got here: Windows KaiTi (jagged) → LXGW WenKai GB Screen (clean at 22pt, but blobby at 17pt) → Zhuque Fangsong at 17pt.

---

## How OSRSCN draws Chinese

OSRS can't display Chinese text, so OSRSCN **turns each character into a tiny image** and puts image codes
(`<img=…>`) into the game's text. That has three consequences for fonts:

1. **No smoothing, only on/off pixels.** RuneLite's sprites keep only fully opaque pixels, so the plugin draws
   characters with anti-aliasing **off** and flattens them to a 1-bit mask, where each pixel is either on or off
   (`GlyphService.java`). No font can look as smooth in-game as it does in Word or a browser. The code's
   coverage threshold (`0x60`) only matters on macOS; on Windows, drawing with smoothing off is already pure on/off.
2. **Only dialogue size is adjustable.** **对话字号** (dialogue font size, 8–22pt, default 14) affects NPC/player
   dialogue only. Menus, the interface, chat, overhead text and tooltips are fixed at **11px**, so dense UI never
   overflows.
3. **The font only affects Chinese.** English text stays in the game's own fonts.

## The 自定义字体 (custom font) setting

What it accepts: the **full path to one font file**, typed into the box. Changes take effect immediately.

Rules, from `OsrscnConfig.fontPath()` and `GlyphService.reloadFont()`:
- **`.ttf` or `.otf` only.** The plugin uses Java's single-font loader, so **`.ttc` collections** (most of Windows'
  own Chinese fonts) **may not load**.
- **It has to contain Chinese.** The plugin checks whether the font can draw 中, and rejects it if not.
- **Failures are silent.** If the file is missing, misspelled, or the wrong kind, the plugin quietly goes back to its
  built-in font. If your font change "does nothing", check the path first.

Font priority, highest first:
1. The path in **自定义字体**
2. A drop-in file in `%USERPROFILE%\.runelite\osrscn\font\` (note: **`font`**, singular). The first `.ttf`/`.otf`
   found there is used when the setting is blank. I don't use this; my files are in `fonts\` and set by path.
3. The bundled font: **Source Han Sans SC** (思源黑体, SIL OFL)
4. Any system font that can draw Chinese

## Fonts already on Windows (checked on my PC)

| File | Works? |
|---|---|
| `C:\Windows\Fonts\NotoSansSC-Regular.ttf` | ✅ Yes, but it's the same design as the bundled Source Han Sans, so nothing visibly changes |
| `msyh.ttc` (微软雅黑 Microsoft YaHei), `simsun.ttc` (宋体 SimSun) | ⚠️ Probably not, because they're `.ttc` collections |
| `simsunb.ttf`, `SimsunExtG.ttf` | ❌ No. These only hold rare extension characters and can't draw 中 |
| `KaiTi.ttf` (楷体) | ✅ Loads, but looks pixelated (see below) |

---

## Why fonts look jagged or blobby, and what fixes it

Two opposite problems, both caused by the on/off pixel drawing:

- **Jagged or broken strokes (thin, uneven fonts).** Windows **KaiTi** imitates a brush, so its strokes change
  width. When they're snapped to on/off pixels, the thin parts land awkwardly: dots in 么 and 话 shrink to
  specks, and hooks in 续 break up.
- **Blobs (heavy fonts at small sizes).** At 17pt a character is only about 17 pixels wide. Dense characters like
  熊, 像 and 继 stack 8–10 strokes in that space, so the gaps between strokes are often 1 pixel. A heavy font
  (about 2-pixel strokes) fills those gaps and the character turns into a blob. That's what happened with LXGW
  WenKai **Screen** at 17pt.

So the right stroke weight depends on size:

| Dialogue size | Better choice |
|---|---|
| About 20pt and up | A heavier font (e.g. LXGW WenKai GB Screen): there's room, and it looks fuller |
| Below about 20pt | A lighter font with even strokes (e.g. Zhuque Fangsong, LXGW WenKai GB Regular): keeps the gaps in complex characters open |

### What I tested (all at 17pt, drawn exactly the way OSRSCN draws them)

I used a small Java tool that copies the plugin's rendering (Java2D, smoothing off, one image per character) to
compare fonts side by side before touching the game:

| Font | Style | Result |
|---|---|---|
| **Zhuque Fangsong** 朱雀仿宋 | calligraphy-based 仿宋 | ✅ **Chosen.** Lightest and most open; characters stay distinct across the line |
| LXGW WenKai GB Regular 霞鹜文楷 | handwriting 楷体 | ✅ Runner-up. Same look as Screen but lighter, so far fewer blobs |
| LXGW WenKai GB Light | 楷体 | Looks the same as Regular at 17pt |
| LXGW WenKai GB Screen / Medium | 楷体, heavy | ❌ Blobby at 17pt (fine at 22pt) |
| Windows KaiTi 楷体 | brush 楷体 | ❌ Jagged |
| Xiaolai 小赖, Ma Shan Zheng 马善政, ZCOOL XiaoWei 站酷小薇 | handwriting / brush | ❌ Too heavy at 17pt |
| Long Cang 龙藏 | casual handwriting | ❌ Non-standard shapes, bad for learning |

I also checked character coverage against all 3,842 different characters in OSRSCN's translation tables and the HSK
reading list. Every font above has all HSK characters. Zhuque Fangsong lacks 6 rare game characters (0.0005% of
game text). The LXGW fonts and KaiTi have everything.

Other things that help:
- **Bigger dialogue size** (up to 22pt), if you don't mind bigger text.
- **Line spacing.** OSRSCN stacks wrapped dialogue lines with **no gap**, because each line is exactly as tall as
  the characters' ink. My fork adds a **对话行距** (dialogue line spacing) setting; see below.
- **Pixel fonts** (Fusion Pixel 缝合像素字体, Zpix 最像素) are perfectly crisp in this renderer but look nothing
  like handwriting.

## Where to get the fonts

| Font | File | Source | Licence |
|---|---|---|---|
| Zhuque Fangsong | `ZhuqueFangsong-Regular.ttf` (inside the release zip) | [TrionesType/zhuque releases](https://github.com/TrionesType/zhuque/releases) (v0.212) | SIL OFL 1.1 |
| LXGW WenKai GB Regular | `LXGWWenKaiGB-Regular.ttf` (26 MB) | [lxgw/LxgwWenkaiGB releases](https://github.com/lxgw/LxgwWenkaiGB/releases) (v1.522) | SIL OFL 1.1 |
| LXGW WenKai GB Screen | `LXGWWenKaiGBScreen.ttf` (26 MB) | [lxgw/LxgwWenKai-Screen releases](https://github.com/lxgw/LxgwWenKai-Screen/releases) (v1.522) | SIL OFL 1.1 |

For LXGW, pick a file with **GB** in the name: its characters follow mainland China's standard shapes
(通用规范汉字表), which is what the HSK uses. The non-GB files have some older or Japanese-style components.
**Mono** files have evenly spaced English letters for code, which you don't need.

## Setup steps

1. Save the `.ttf` to `C:\Users\Howard\.runelite\osrscn\fonts\` (create the folder if needed).
2. RuneLite → wrench (Configuration) → search **OSRSCN** → gear → **外观** (Appearance) section.
3. **自定义字体** (custom font): `C:\Users\Howard\.runelite\osrscn\fonts\ZhuqueFangsong-Regular.ttf`
4. **对话字号** (dialogue font size): 17pt.
5. Fork only: **对话行距** (dialogue line spacing), 0–12 px. Start at about 4.

If the text still looks like the old font, check the path for typos. A bad path fails silently.

### Line spacing (fork only)

`对话行距` adds that many pixels between wrapped dialogue lines. The OSRS dialogue box has a fixed height, so on a
long speech that wouldn't fit, the spacing automatically shrinks (down to 0) instead of letting lines spill outside
the box. A change takes effect from the next line of dialogue. It's in `hooks/DialogueHandler.java` (`lineGap`) and
`OsrscnConfig.dialogueLineGap()` in the `osrscn-tts` fork.

---

## Not a font problem: the whole game looking pixelated

If **all** of RuneLite (English text, icons, the map) suddenly looks bigger and blocky, that's display scaling,
not the Chinese font. It happened when I ran the developer-mode client for the TTS fork: the plugin's
`runClient` task forces 150% scale, while my Windows display is at 125%. Java enlarges the difference by
duplicating pixels. The fix was running with `-PuiScale=1.25` to match Windows (see `osrscn-tts/TTS-README.md`).
The normal Plugin Hub RuneLite isn't affected.

---

## Words from the settings panel

| Word | Pinyin | Meaning |
|---|---|---|
| 字体 | zìtǐ | font / typeface |
| 自定义字体 | zì dìngyì zìtǐ | custom font |
| 字号 | zìhào | font size |
| 对话字号 | duìhuà zìhào | dialogue font size |
| 外观 | wàiguān | appearance |
| 楷体 | kǎitǐ | regular-script style (brush-like) |
| 黑体 | hēitǐ | sans-serif style (even strokes) |
| 宋体 | sòngtǐ | serif / print style |
| 仿宋 | fǎngsòng | calligraphy-based print style (Zhuque Fangsong) |
| 行距 | hángjù | line spacing (行 = line, read háng here, not xíng) |
| 字距 | zìjù | character spacing |
| 思源黑体 | Sīyuán hēitǐ | Source Han Sans (the plugin's built-in font) |
| 霞鹜文楷 | Xiáwù wénkǎi | LXGW WenKai |
| 屏幕阅读版 | píngmù yuèdú bǎn | screen-reading edition |

## Sources

- OSRSCN plugin source: [Aoldbald/OSRS_CN_Runelite](https://github.com/Aoldbald/OSRS_CN_Runelite): `OsrscnConfig.java`, `glyph/GlyphService.java`
- [LXGW WenKai Screen](https://github.com/lxgw/LxgwWenKai-Screen)
