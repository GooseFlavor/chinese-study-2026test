# Chinese (HSK) self-study

Howard is self-teaching Mandarin, with Claude as tutor. The long-term goal is to **pass HSK 6 at minimum** under **HSK 3.0**. Budget: about 2–3 hours a week.

## Source of truth
- [reference/hsk3/README.md](reference/hsk3/README.md) is the verified HSK 3.0 reference: levels, counts, exam format and timeline.
- The word / character / grammar lists in `reference/hsk3/` are parsed from the official CLEC 2025-11 syllabus. **Always look up a word's level there; never guess from memory.** Older 2.0 lists and the 2021 GF 0025-2021 lists give different levels for the same words.
- HSK 3.0 cumulative words: 300 / 500 / 1,000 / 2,000 / 3,600 / **5,400 at HSK 6**.

## Learner profile (placement, 2026-10-02 — provisional; skills differ a lot)
- **Listening:** self-reported strongest skill. Not tested.
- **Reading:** solid on simple sentences. Handles 把, 如果…就, 虽然…但是. When unsure, guesses a word from its component characters (影响 → "shadow"; 尽管 confused with 器官). Missed 影响 and 坚持 (HSK 3); 随着 and 尽管 (HSK 4); 避免 and 抱怨 (HSK 5); 与其 (HSK 6).
- **Pinyin/tones:** weaker than recognition. Often knows a word's meaning but not its sound.
- **Handwriting:** weak. Couldn't produce 学习, 医院, 喜欢 (HSK 1) or 因为, 所以, 懂 (HSK 2) from memory. Says typing with pinyin input is near 100%.
- Some Taiwan-influenced habits: wrote 個 for 个 and used 电动 for "video games". HSK uses simplified characters; point out mainland usage.

## Tools (OSRS in Chinese for immersion)
Howard plays Old School RuneScape with the OSRSCN translation plugin, and runs a local fork of it that reads dialogue aloud.
- [tools/osrscn-tts/TTS-README.md](tools/osrscn-tts/TTS-README.md): the fork (TTS + word lookup). Kokoro offline voices, NPC voice by type from OSRS Wiki data, setup, troubleshooting. Its own git repository (branch `tts-dictionary`), backed up to the private GitHub repo GooseFlavor/osrscn-tts-with-dictionary. `tools/osrscn-tts.patch` is an older TTS-only snapshot.
- [tools/OSRSCN-FONTS.md](tools/OSRSCN-FONTS.md): how the plugin draws Chinese, and the font comparison (currently Zhuque Fangsong at 17pt).
- [tools/OSRSCN-LOOKUP.md](tools/OSRSCN-LOOKUP.md): the hover-to-look-up dictionary popup in the fork (hold Alt over dialogue).
- `vocab/saved-words.tsv`: words Howard saved in game with the S key, each with its sentence and the game's English. Created on
  the first save. Use it in tutoring sessions: quiz these words, and notice which kinds of words keep getting saved.

## Tutoring approach
- Test the skills separately. Don't infer one skill from another.
- Plan for the **computer-based** exam (typed answers). Handwriting is low priority: just enough of the official 书写字 list to support recall.
- Correct directly, with the right form, pinyin with tones, and a one-line reason.
- Track progress in files in this folder rather than relying on chat memory.

## Backups
This folder is a git repository, backed up to the private GitHub repo GooseFlavor/chinese-study (the fork in
`tools/osrscn-tts/` is excluded; it has its own). `backup.bat` copies the AI definitions
(`~/.runelite/osrscn/dict/zh-defs.jsonl`) into `data/`, then commits and pushes both repositories. Commit
here after changing notes or progress files.
