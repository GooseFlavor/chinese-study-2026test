# HSK 3.0 — verified reference

Everything here was extracted from the **official documents** in [sources/](sources/) and checked on 2026-10-02. Where a fact comes only from third-party sites, it's marked *(unofficial)*.

## Official documents

| File | What it is |
|---|---|
| [sources/HSK考试大纲-2025-11.pdf](sources/HSK考试大纲-2025-11.pdf) | 《中文水平考试 HSK 考试大纲》, published by 中外语言交流合作中心 (CLEC) in 2025-11, effective 2026-07. It holds the word, character and grammar lists, 317 pages. |
| [sources/新版HSK1-6级考试结构与样题示例-2025-12.pdf](sources/新版HSK1-6级考试结构与样题示例-2025-12.pdf) | 《新版HSK（1-6级）考试结构与样题示例》, published by 汉考国际 (CTI) in 2025-12. It gives the exam structure and sample questions. |

**Not to be confused with:** the 2021 《国际中文教育中文水平等级标准》 (GF 0025-2021). That standard had about 500 / 1,272 / 2,245 / … / 11,092 words. Many sites, apps and Anki decks labelled "HSK 3.0" are built on it. The 2025 syllabus is a different list, with a much easier entry level, and **it is the one the exam uses.** Treat any list that doesn't total exactly 300 / 500 / 1,000 / 2,000 / 3,600 / 5,400 / 11,000 words as outdated.

## Structure
- 3 stages × 9 levels: 初等 (1–3), 中等 (4–6), 高等 (7–9).
- Levels 1–6 each have their own exam paper (一卷一考). Levels 7–9 share one paper (一卷三考), and the score decides the level awarded.
- 5 skills: listening, speaking, reading, writing, translation. Translation (into your mother tongue) is **only tested at 7–9.**

## Syllabus counts (official, verified by parsing the PDF)

| Level | New words | Cumulative words | New recognition chars | Cumulative recognition | Handwriting chars (cumulative) |
|---|---|---|---|---|---|
| 1 | 300 | 300 | 246 | 246 | 100 (shared 1–2) |
| 2 | 200 | 500 | 125 | 371 | 100 |
| 3 | 500 | 1,000 | 284 | 655 | 250 |
| 4 | 1,000 | 2,000 | 441 | 1,096 | 400 |
| 5 | 1,600 | 3,600 | 431 | 1,527 | 550 |
| 6 | 1,800 | 5,400 | 413 | 1,940 | 700 |
| 7–9 | 5,600 | 11,000 | 1,148 | 3,088 | 1,200 |

Notes on the word list:
- Each word is listed once, at the level where it first appears. The `also_levels` column records the syllabus notation `1（4）`, which means the word enters at level 1 and **additional senses or parts of speech** are tested at level 4. Parts of speech in （parentheses） belong to that later level.
- `homograph` = the superscript number in the syllabus (本1, 点1, 和1 …).
- Optional parts are kept as printed, e.g. 没（有）, 有（一）点儿.

## Exam structure, levels 1–6 (official, 2025-12)

| Level | Listening (Qs / min) | Reading (Qs / min) | Writing (Qs / min) | Total Qs | Total time |
|---|---|---|---|---|---|
| 1 | 20 / ~12 | 20 / 20 | — | 40 | ~40 min |
| 2 | 25 / ~17 | 25 / 25 | 10 / 10 | 60 | ~60 min |
| 3 | 30 / ~23 | 30 / 30 | 10 / 20 | 70 | ~83 min |
| 4 | 32 / ~20 | 32 / 30 | 6 / 25 | 70 | ~85 min |
| 5 | 35 / ~25 | 35 / 35 | 2 / 40 | 72 | ~110 min |
| 6 | 40 / ~30 | 40 / 40 | 2 / 45 | 82 | ~125 min |

Total time includes filling in personal information and the answer sheet.

**Writing tasks (from the sample questions):**
- **HSK 2:** part 1 is a matching task (the sample isn't clear in text form), then fill a character into a sentence from its pinyin (你想喝(chá)还是喝咖啡? → 茶).
- **HSK 3:** fill in a character from its pinyin, then write a sentence using a given word (羽毛球 → 她每周末都去打羽毛球。).
- **HSK 4:** write sentences using given words (结账), then a short essay of ≥80 characters.
- **HSK 5:** a story from 4 pictures (≥100 characters), then an essay on a topic (≥200 characters).
- **HSK 6:** a practical text such as a notice or listing (≥150 characters), then an opinion essay (≥300 characters).

**Speaking:** levels 3–6 must be registered together with the speaking test of the same level, so it is mandatory (chinesetest.cn trial notice). *(Unofficial: HSKK has been reorganised into 4 levels of about 15–23 min.)*

**Paper vs. computer:** both formats are offered. On the computer-based test you type, using pinyin input. Handwriting matters only on the paper test. The handwriting character list is still part of the syllabus.

**Pass marks / scoring:** not in either official document. Still to be confirmed.

## Timeline
- 2025-11: syllabus published. 2025-12: exam structure and sample questions published.
- 2026-01-31 and 2026-09-20: global trial sittings.
- *(Unofficial)* 2026-11-07: last HSK 2.0 sitting.
- **2026-12-13: first official HSK 3.0 sitting.** HSK 2.0 is discontinued completely at that point, with no parallel running (multiple sources citing CTI; confirm at chinesetest.cn).

## Files
- [vocab/](vocab/) — `hsk-1.csv` … `hsk-7-9.csv` (new words per level), `hsk-all.csv` (all 11,000 words). Columns: `id, level, also_levels, word, homograph, pinyin, pos`.
- [characters/recognition.csv](characters/recognition.csv) — 认读字 by level. [characters/handwriting.csv](characters/handwriting.csv) — 书写字 by level.
- [grammar/](grammar/) — the official grammar syllabus per level, as text extracted from the PDF.

## Verification
- All 11,000 word entries were parsed from the official PDF with no gaps in the numbering. The per-level counts match the syllabus exactly.
- The list was cross-checked against [uranbekanarbaev/hsk-3.0-vocabulary-dataset](https://github.com/uranbekanarbaev/hsk-3.0-vocabulary-dataset). Every word/level pair matches. The only differences are cosmetic: 6 entries where the dataset drops the optional （…） parts, and the style of apostrophe in pinyin.
- The character counts match the totals published by hsklord.com (246 / 655 / 1,940 / 3,088; 100 / 250 / 400 / 550 / 700 / 1,200).

## Sources
- [CLEC syllabus PDF](https://hsk.cn-bj.ufileos.com/3.0/%E6%96%B0%E7%89%88HSK%E8%80%83%E8%AF%95%E5%A4%A7%E7%BA%B21219.pdf) (mirror used: mandarinzone.com)
- [CTI exam structure PDF](https://s3.eu-central-1.amazonaws.com/konfuzius-institut-heidelberg.de/wp-content/uploads/2026/02/19110129/%E6%96%B0%E7%89%88HSK%EF%BC%881-6%E7%BA%A7%EF%BC%89%E8%80%83%E8%AF%95%E7%BB%93%E6%9E%84%E4%B8%8E%E6%A0%B7%E9%A2%98%E7%A4%BA%E4%BE%8B.pdf) (Konfuzius-Institut Heidelberg mirror)
- [chinesetest.cn notices](https://www.chinesetest.cn/notice)
- [hsklord.com — New HSK 3.0 complete guide](https://hsklord.com/blog/new-hsk-3-0-complete-guide)
- [Hilingo — HSK 3.0 launch Dec 2026](https://www.hilingo.cn/news/95.html)
- [studycli.org — The new HSK](https://studycli.org/hsk/the-new-hsk/)
- [Guangming Daily — 与时俱进的中文水平考试](https://news.gmw.cn/2025-11/11/content_38404192.htm)
