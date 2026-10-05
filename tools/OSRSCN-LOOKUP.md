# OSRSCN: in-game word lookup (design notes)

Status: **steps 1–2 built 2026-10-04, working in game 2026-10-05** (NPC and player lines only, not
the option list yet). Previews from outside the game: `lookup-preview/`. Lets me look up Chinese words in OSRS dialogue to
learn them, not just translate them. Builds on the TTS fork (`osrscn-tts/`).

## Decisions so far
- **Hover first.** Hold a lookup key (configurable; avoid Shift/Ctrl, which RuneLite already uses) and
  hover over Chinese text to show a popup. Clicks are blocked while the key is held, so dialogue options
  can't be picked by accident.
- **No English until I ask for it.** The popup opens in Chinese: characters, pinyin with colour-coded
  tones, HSK level, play-word button. One press reveals all the English at once (definitions, character
  meanings, example translations). There's no step-by-step reveal.
- **Word first, then characters.** Split each line into words when it's displayed. Hovering any character
  picks the whole word (响 in 影响 shows 影响). Each character is listed underneath with its parts and
  radical. Scroll or arrow keys widen or narrow the selection.
- **Side panel later.** Make the RuneLite panel's dialogue history clickable, using the same lookup engine.
- **Saving words: backlog.** Save the word, its sentence, the NPC and the time, then export to Anki.

## Feasibility (checked in the fork's code)
- `DialogueHandler.java` breaks lines itself, and every Chinese character is the same width, so the
  plugin can work out which character is under the mouse with simple arithmetic.
- The popup is a RuneLite overlay drawn with normal Java graphics, so it can use smooth, large fonts.
  The blocky 1-bit characters only apply to text inside the game's own windows.

## Popup contents
| Section | Before reveal | After reveal |
|---|---|---|
| Word, pinyin with tone colours, 🔊 | ✅ | |
| HSK 3.0 level (from `reference/hsk3/`) | ✅ | |
| Characters: parts, radical, other HSK words using them | ✅ (Chinese) | + English meaning of each |
| Common word pairings (常见搭配) | ✅ | |
| Example sentences, target word highlighted, click to hear | ✅ | + English |
| Definitions (CC-CEDICT), measure word, traditional form | | ✅ |

## Example sentences: sources
1. **The game's own dialogue.** `~/.runelite/osrscn/zh/transcript_zh_dialogue.tsv` has 62,800 lines,
   each paired with the original English. Lines found: 影响 73, 尽管 72, 坚持 39. Prefer short lines whose
   other words are at or below my level, and skip lines with game names (`transcript_zh_name.tsv` can
   detect them). Caveat: these are community translations of English, so some may read like translations.
2. **Word pairings** found in the same dialogue file (e.g. 产生…影响, 影响排名).
3. **Tatoeba** (CC BY 2.0 FR) Mandarin–English sentence pairs, for everyday Chinese outside the game.
   Quality varies, so keep simplified-character sentences only.
4. **AI-written sentences**, saved after first use, as a last resort. Check that every other word is
   within my HSK range using the word splitter and official lists. Label them as AI-written, because
   that check doesn't prove they sound natural.

## Data (free, used offline)
CC-CEDICT (CC BY-SA), Make Me a Hanzi (character parts and radicals), official HSK 3.0 lists,
Tatoeba, and the OSRSCN translation files.

## Setup
Download the dictionary data once (about 39 MB downloaded, 14 MB kept in `~/.runelite/osrscn/dict/`):
`python osrscn-tts/dict-build/build_dict.py`. The HSK 3.0 lists are bundled with the plugin
(`src/main/resources/com/osrscn/dict/`, copied from `reference/hsk3/`).

To check the engine without the game, put words on line 1 of a UTF-8 file (`影响,坚持`), and optionally
sentences to split on line 2 (separated by `|`), then run
`gradlew lookupDemo -Pwords=@file.txt -Pout=cards.txt`. Use `-Pout`, because Gradle garbles Chinese
printed to the console, even when it's redirected to a file.

## Step 1: what's built (`osrscn-tts/src/main/java/com/osrscn/dict/`)
- `Dictionary`: loads CC-CEDICT, jieba frequencies, Make Me a Hanzi, the HSK lists, and NPC/place names
  from the game. Takes about 0.6 s and 110 MB of memory.
- `Segmenter`: splits text into words the way jieba does (best total word frequency). `spansAt` lists
  every word covering a character, for widening or narrowing the selection.
- `Lookup` → `WordCard`: readings ordered by HSK pinyin and level (行 xíng HSK 3 before háng HSK 5),
  measure words, traditional form, parts of 3+ character words (影响力 = 影响 + 力), and each character
  with its pinyin in this word, parts (sound or meaning), radical and other HSK words. Also word
  pairings and up to 3 examples each from the game and Tatoeba. A card takes 2–80 ms.
- `LookupService`: loads everything in the background after the translation tables. Not connected to
  the plugin yet; that happens with the popup.
- Tests: `DictTest`. The demo output looked right for 影响, 坚持, 尽管, 行, 了, 把, 一点儿, 胡多 and 工具包.

## Step 2: how to use it in game
Start the game with `osrscn-tts/start-tts.bat` as usual (it rebuilds the plugin). The dictionary loads a
few seconds after the plugin starts.

While a translated NPC or player line is showing, **hold Alt** (the default; Howard has it set to **Tab**):
- The line is redrawn over the dialogue box in a smooth font, with a faint underline under each word.
- **Hover** a word to see its popup, in Chinese only.
- **Right-click** to show or hide the English (definitions, character meanings, example translations).
- **Click** to hear the word in the voice of whoever said the line: that NPC's voice, or the player voice for your own lines (needs the TTS server).
- **Scroll** for a longer or shorter word (响 → 影响 → 影响力).
- **S** or **middle-click** to save the word with the sentence it came from. The popup confirms it, and
  marks saved words 已保存 whenever they come up again.
- **D** to open the word in an online dictionary (Wiktionary's Chinese section; change it with 在线词典,
  where `{word}` stands for the word).
- **E** to show the whole line in English, in a strip above the dialogue box (the game's original English,
  which the plugin keeps). E again hides it; it also hides itself on the next line. The Chinese is a
  community translation of that English, so they won't always match word for word.
- **Let go of Alt** to close it. Clicks and scrolling don't reach the game while it's showing.

Settings are under **查词 (word lookup)**: on/off, the key, your HSK level for choosing examples (default
4), the text size, the study log, and the name / game-word colours (below). Labels in the popup: 繁 = traditional form, 又读 = other reading, 量词 = measure
word, 组成 = parts of the word, 声 = the part that gives the sound, 形 = the part that gives the meaning,
搭配 = common pairings, 游戏 = an example from the game, 超纲 = not on the HSK syllabus.

Code: `osrscn-tts/src/main/java/com/osrscn/ui/lookup/` (`LookupOverlay`, `DialogueLayer`, `CardPainter`).
The preview PNGs come from `com.osrscn.ui.lookup.PopupPreview` in the test sources (arguments: output folder, optional font path).

Checked in the real game (2026-10-05): Alt works as a held key, the popup lands in a usable place, and
hovering picks the right word at 1.25× display scaling.

## Colours for names and game words (built 2026-10-05)
NPC and player lines colour two kinds of words, in the dialogue box itself and in the Tab overlay
(lightened there for the dark panel). Settings under 查词: 名字上色 / 名字颜色 (default dark purple
`#6A1B9A`), 游戏词上色 / 游戏词颜色 (default dark teal `#00695C`). Words inside the game's own coloured
text keep the game's colour.

- **Names (purple):** names that mean nothing outside the game. Only the sound-spelled part is coloured:
  酋长**布伦特** (Brundt the Chieftain), **维洛克**城 (Varrock), **霍拉西奥**公爵 (Duke Horacio), **汉斯** (Hans).
  Source: the NPC, place and monster names in OSRSCN's name table. Real words are peeled off each end
  (酋长, 公爵, 城, 镇, 村…); what's left is a name if it's mostly characters used to spell foreign names, or a
  known proper noun. The name part is also recognised on its own (维洛克 without 城).
- **Game words (teal):** real Chinese nouns that the game's item, NPC, object and place names are made of,
  aren't on HSK 1–6, and are at least 15× more common in the game's dialogue than in everyday Chinese
  (jieba's corpus). So 哥布林 goblin, 符文 rune, 城堡 castle (18×), 骑士 knight, 巫师 wizard are teal, but
  胡萝卜 carrot and 酋长 chieftain (9×) are not. Decided 2026-10-05: Howard wants game-specific vocabulary
  marked, not "off the syllabus" in general, because the goal is Chinese, not just the HSK.
- In all game dialogue: names are 2.7% of characters, game words 3.2%; about 1 line in 4 has a colour.
- Known misses: some everyday words OSRS overuses still score as game words (卷心菜 cabbage, 洋葱 onion,
  青蛙 frog, 企鹅 penguin), and a few names stay uncoloured (沙林港 Port Sarim).

**Fixing wrong ones:** `chinese/vocab/word-colors.tsv` (beside the saved-words file). One word per line,
then `name`, `game` or `plain`. Read when the game starts, so restart after editing. To check the
results outside the game: `gradlew wordKindsDemo -Pout=kinds.txt -Poverrides=<path to word-colors.tsv>`
prints sample names, the most common names and game words, and sample lines with {names} and [game words].

Code: `dict/WordKinds.java` (sorting and colouring), used by `hooks/DialogueHandler.java` (dialogue box)
and `ui/lookup/LookupOverlay.java` (Tab overlay). Tests: `WordKindsTest`.

## Study log (built 2026-10-05)
`chinese/vocab/game-log.tsv`, beside the saved-words file, gets one row per event: `time, event, word,
sentence, sentence_en, speaker`. Events: `line` (each NPC/player line shown in Chinese), `hover` (a word
kept under the mouse for a second while holding Tab, once per line), `reveal` (a word's English shown),
`line_en` (E pressed), `save` (S). Setting: 记录学习数据 (on by default). Nothing is sent anywhere. This
is the data for coverage stats, review decks and spotting words that aren't sticking.

## Chinese definitions (释义, AI)
No free Chinese-only dictionary suits mainland learners, so the local Ollama model writes short, simple
definitions (about HSK 1–4 vocabulary), each with an example. Settings: **AI 中文释义** (on/off) and
**释义模型** (blank = the AI 翻译 model; tested with `qwen3.8`, about 7 s per word). Each word is written once,
then saved in `~/.runelite/osrscn/dict/zh-defs.jsonl`. They're labelled AI, and checked before showing:
- A sense whose part of speech the official HSK list doesn't give the word is dropped (要 is only 动 in the
  list, so the model's 形 "important" sense goes; 助动 counts as 动).
- A definition that uses the word itself (circular) is dropped, and so is an example that lacks the word.
The model still gets some wrong: treat it like a classmate's note, not a dictionary.

### Writing them ahead of time (HSK 1–6, done 2026-10-05)
**Status: HSK 1–6 all written on 2026-10-05 (5,336 words, `qwen3.8`, no failures logged). 36 of the entries have no senses (e.g. 大, 二, 没有, 是, 下); the popup shows nothing AI-written for those. HSK 7–9 not generated.**
So the popup never waits, `osrscn-tts/dict-build/pregen_zh_defs.py` writes definitions for whole HSK
levels into the same file the plugin uses. HSK 1–6 is 5,336 words (those in CC-CEDICT), about 1.3 MB and
roughly 7 s per word on `qwen3.8`: about 11 hours in all. Level 5 and 6 are about 3.5 hours each.
- **Start a level in its own window:** `dict-build\pregen-zh-defs.bat 1` (or `1-3`, or no argument for
  1–6). It keeps going if the Claude session ends. To start it from a Claude session, go through
  `explorer.exe` so it runs outside the app (see the AppData note in TTS-README.md).
- **Progress:** `python pregen_zh_defs.py --status` prints done / total per level.
- **Stopping is safe:** close the window or shut down at any time; each word is saved as it's finished,
  and running the same command again skips everything done. Words that failed three times are logged in
  `dict-build/pregen-failures.log` and retried on the next run.
- The game reads the file at start-up, so restart it to see new definitions. Running the game during
  generation is fine, but both share the GPU, so each runs a little slower.
- A Claude session only needs to start the launcher and check `--status`: Sonnet at medium effort is
  plenty, since the script does the work. Several agents wouldn't help, because the single GPU is the
  bottleneck.

## Pairings (搭配)
Only real grammatical pairs, using the HSK part of speech (jieba's tag for words not on the list): verb +
object (受影响), adverb + verb or adjective (一定要, 很重要), adjective + noun, noun + noun, classifier + noun
(个任务), number + classifier, verb + result (影响到). A pair must also appear at least twice (three times for
a common word), and at least 3× more often than chance. This replaced plain "words seen side by side",
which gave 要去 and 工作要 (2026-10-04).

## Saved words (for Anki and Pleco)
Saved to `chinese/vocab/saved-words.tsv`; the 保存文件 setting can change that. It's a tab-separated file,
one row per word and sentence, appended as you play. Columns:
`saved_at, word, traditional, pinyin, pinyin_numbered, hsk, definitions, measure_words, sentence,
sentence_en, speaker, source`.

Every row keeps the full sentence and the game's original English, so Anki and Pleco exports can be built
from the file later without losing anything. Audio can be generated then from the text with the Kokoro
voices. Saving the same word from a different sentence adds a new row (a new context); the exact same
word and sentence is skipped.

## Build order
1. ✅ Lookup engine: load the dictionary, word splitter, HSK levels, character data, example search.
2. ✅ Popup while holding the key, over the NPC/player dialogue box. (Working in game, 2026-10-05.)
3. Extend the popup to dialogue options and chat.
4. Clickable side panel.
5. ✅ Save words to a file (S) and open an online dictionary (D). Built 2026-10-04, not yet tried in game.
6. Backlog: export saved words to Anki (cards with the sentence and Kokoro audio, via AnkiConnect or
   file import) and Pleco (its import format). Both, from the same file.
