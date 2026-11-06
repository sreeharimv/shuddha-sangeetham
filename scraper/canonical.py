"""
Canonical spelling and normalization dictionaries for Carnatic music metadata.
Provides clean, uniform spellings for ragas, composers, and talas, and
strips diacritics and mid-word ITRANS capitalization from lyrics.
"""

import re
import unicodedata
from pathlib import Path

# ---------------------------------------------------------------------------
# Text Normalization
# ---------------------------------------------------------------------------

def strip_diacritics(text: str) -> str:
    """Strip Unicode combining diacritics (e.g. ā -> a, ś -> s, ṭ -> t)."""
    if not text:
        return ""
    text = unicodedata.normalize("NFKD", text)
    return "".join(c for c in text if not unicodedata.combining(c))


def clean_lyrics_text(text: str) -> str:
    """
    Normalizes lyrics text:
      - Strips Unicode diacritics.
      - Converts mid-word ITRANS uppercase letters (e.g. sItApati -> sitapati, balattAl -> balattal).
      - Converts non-first ITRANS capitalized words (e.g. karat Aratii -> karat aratii).
      - Collapses excess spaces per line while preserving poetic line breaks.
    """
    if not text:
        return ""
    text = strip_diacritics(text)
    lines = []
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line:
            continue
        # Preserve stanza markers like "1:", "2:"
        if re.match(r"^\d+:$", line):
            lines.append(line)
            continue
        words = line.split()
        cleaned_words = []
        for i, w in enumerate(words):
            # If word has mid-word capitals (e.g. sItApati, accAm, nInE, kAntimayiyum), lowercase it
            if re.search(r"[a-z][A-Z]", w):
                w = w.lower()
            elif i > 0 and (w.isupper() or (len(w) > 1 and w[0].isupper())):
                # Non-first words with uppercase in lyrics are ITRANS transliterations
                w = w.lower()
            elif w.isupper() and len(w) > 3:
                w = w.lower()
            cleaned_words.append(w)
        lines.append(" ".join(cleaned_words))
    return "\n".join(lines).strip()


def clean_title(title: str) -> str:
    """Clean and title-case a composition title without mid-word ITRANS capitals."""
    if not title:
        return ""
    title = strip_diacritics(title)
    # Remove leading/trailing non-alpha artifacts
    title = re.sub(r"^[^a-zA-Z0-9\(]+", "", title).strip()
    words = title.split()
    cleaned = []
    for w in words:
        if re.search(r"[a-z][A-Z]", w) or (w.isupper() and len(w) > 1):
            w = w.lower()
        if w.startswith("(") and len(w) > 1:
            cleaned.append("(" + w[1:].capitalize())
        else:
            cleaned.append(w.capitalize())
    return " ".join(cleaned)


# ---------------------------------------------------------------------------
# Phonetic Folding & Canonical Dictionaries
# ---------------------------------------------------------------------------

_FOLDS = (
    ("au", "ow"), ("ou", "ow"),
    ("th", "t"), ("dh", "d"), ("bh", "b"), ("kh", "k"), ("gh", "g"), ("ph", "p"), ("jh", "j"),
    ("sh", "s"), ("w", "v"),
    ("aa", "a"), ("ee", "i"), ("ii", "i"), ("oo", "u"), ("uu", "u"),
)
_DOUBLE = re.compile(r"([b-df-hj-mp-tv-z])\1")


def _canon_word(w: str) -> str:
    w = w.lower()
    for a, b in _FOLDS:
        w = w.replace(a, b)
    w = _DOUBLE.sub(r"\1", w)
    if w.endswith("y") and len(w) > 3:
        w = w[:-1] + "i"
    if w.endswith("am") and len(w) > 4:
        w = w[:-1]
    return w


def _canon_key(s: str) -> str:
    s = strip_diacritics(s).lower()
    words = re.findall(r"[a-z0-9]+", s)
    return "".join(_canon_word(w) for w in words)


# Curated base dictionaries
BASE_RAGAS: list[tuple[str, str]] = [
    ("Kapi", "Kapi"),
    ("Kaapi", "Kapi"),
    ("Kapilam", "Kapi"),
    ("Kalyani", "Kalyani"),
    ("Kalyaani", "Kalyani"),
    ("Kalyan", "Kalyani"),
    ("Mechakalyani", "Kalyani"),
    ("Mohanam", "Mohanam"),
    ("Mohana", "Mohanam"),
    ("Bhairavi", "Bhairavi"),
    ("Bhairawi", "Bhairavi"),
    ("Anandabhairavi", "Anandabhairavi"),
    ("Ananda Bhairavi", "Anandabhairavi"),
    ("Aananda Bhairavi", "Anandabhairavi"),
    ("Sindhubhairavi", "Sindhubhairavi"),
    ("Sindu Bhairavi", "Sindhubhairavi"),
    ("Natabhairavi", "Natabhairavi"),
    ("Nata Bhairavi", "Natabhairavi"),
    ("Todi", "Todi"),
    ("Thodi", "Todi"),
    ("Hanumatodi", "Todi"),
    ("Kambhoji", "Kambhoji"),
    ("Kamboji", "Kambhoji"),
    ("Kambhodi", "Kambhoji"),
    ("Shankarabharanam", "Shankarabharanam"),
    ("Shankaraabharanam", "Shankarabharanam"),
    ("Sankarabharanam", "Shankarabharanam"),
    ("Dheera Shankarabharanam", "Shankarabharanam"),
    ("Behag", "Behag"),
    ("Behaag", "Behag"),
    ("Byag", "Behag"),
    ("Saveri", "Saveri"),
    ("Saaveri", "Saveri"),
    ("Shaveri", "Saveri"),
    ("Suddha Saveri", "Suddha Saveri"),
    ("Shuddha Saveri", "Suddha Saveri"),
    ("Arabhi", "Arabhi"),
    ("Arabi", "Arabhi"),
    ("Bilahari", "Bilahari"),
    ("Hamsadhwani", "Hamsadhwani"),
    ("Hamsadhvani", "Hamsadhwani"),
    ("Kharaharapriya", "Kharaharapriya"),
    ("Khara Harapriya", "Kharaharapriya"),
    ("Madhyamavati", "Madhyamavati"),
    ("Madhyamavathi", "Madhyamavati"),
    ("Hindolam", "Hindolam"),
    ("Hindola", "Hindolam"),
    ("Charukesi", "Charukesi"),
    ("Chaarukesi", "Charukesi"),
    ("Shanmukhapriya", "Shanmukhapriya"),
    ("Sanmukhapriya", "Shanmukhapriya"),
    ("Purvikalyani", "Purvikalyani"),
    ("Poorvikalyani", "Purvikalyani"),
    ("Gowla", "Gowla"),
    ("Gaula", "Gowla"),
    ("Kedaragowla", "Kedaragowla"),
    ("Kedara Gowla", "Kedaragowla"),
    ("Ritigowla", "Ritigowla"),
    ("Riti Gowla", "Ritigowla"),
    ("Mayamalavagowla", "Mayamalavagowla"),
    ("Mayamalavagaula", "Mayamalavagowla"),
    ("Abhogi", "Abhogi"),
    ("Dhanyasi", "Dhanyasi"),
    ("Danyasi", "Dhanyasi"),
    ("Mukhari", "Mukhari"),
    ("Begada", "Begada"),
    ("Surati", "Surati"),
    ("Sahana", "Sahana"),
    ("Sama", "Sama"),
    ("Reethigowla", "Ritigowla"),
    ("Chakravakam", "Chakravakam"),
    ("Vachaspati", "Vachaspati"),
    ("Harikambhoji", "Harikambhoji"),
    ("Simhendramadhyamam", "Simhendramadhyamam"),
    ("Khamas", "Khamas"),
    ("Kamaas", "Khamas"),
    ("Subhapantuvarali", "Subhapantuvarali"),
    ("Pantuvarali", "Pantuvarali"),
    ("Kamavardhani", "Pantuvarali"),
    ("Nattai", "Nattai"),
    ("Naattai", "Nattai"),
    ("Sriranjani", "Sriranjani"),
    ("Shreeranjani", "Sriranjani"),
    ("Kalyanavasantam", "Kalyanavasantam"),
    ("Bhairav", "Bhairav"),
    ("Ahir Bhairav", "Ahir Bhairav"),
    ("Kanada", "Kanada"),
    ("KaanaDaa", "Kanada"),
    ("Kaanada", "Kanada"),
    ("Darbar", "Darbar"),
    ("Nayaki", "Nayaki"),
    ("Varali", "Varali"),
    ("Devagandhari", "Devagandhari"),
    ("Surutti", "Surati"),
    ("Yadukulakambhoji", "Yadukulakambhoji"),
    ("Natakurinji", "Natakurinji"),
    ("Naattakurinji", "Natakurinji"),
    ("Saranga", "Saranga"),
    ("Hameerkalyani", "Hameerkalyani"),
    ("Kedar", "Kedaram"),
    ("Kedaram", "Kedaram"),
    ("Kuntalavarali", "Kuntalavarali"),
    ("Malayamarutam", "Malayamarutam"),
    ("Ranjani", "Ranjani"),
    ("Sindhubharavi", "Sindhubhairavi"),
]

BASE_COMPOSERS: list[tuple[str, str]] = [
    ("Tyagaraja", "Tyagaraja"),
    ("Thyagaraja", "Tyagaraja"),
    ("Tyaagaraaja", "Tyagaraja"),
    ("Tyaagarajaa", "Tyagaraja"),
    ("Tyagarajar", "Tyagaraja"),
    ("Saint Tyagaraja", "Tyagaraja"),
    ("Muthuswami Dikshitar", "Muthuswami Dikshitar"),
    ("Muttuswaamee Dikshitar", "Muthuswami Dikshitar"),
    ("Muttuswaami Dikshitar", "Muthuswami Dikshitar"),
    ("Muttiswaamee Dikshitar", "Muthuswami Dikshitar"),
    ("Muttuswaamy Dikshitar", "Muthuswami Dikshitar"),
    ("Dikshitar", "Muthuswami Dikshitar"),
    ("Syama Sastri", "Syama Sastri"),
    ("Shyama Sastri", "Syama Sastri"),
    ("Shyaamaa Shaastree", "Syama Sastri"),
    ("Syama Shastri", "Syama Sastri"),
    ("Swati Tirunal", "Swati Tirunal"),
    ("Swathi Thirunal", "Swati Tirunal"),
    ("Swaati TirunaaL", "Swati Tirunal"),
    ("Swati Tirunaal", "Swati Tirunal"),
    ("Papanasam Sivan", "Papanasam Sivan"),
    ("Paapanaasam Shivan", "Papanasam Sivan"),
    ("Paapanasam Shivan", "Papanasam Sivan"),
    ("Purandara Dasa", "Purandara Dasa"),
    ("Purandaradasa", "Purandara Dasa"),
    ("Purandara Daasa", "Purandara Dasa"),
    ("Kanaka Dasa", "Kanaka Dasa"),
    ("Kanakadasa", "Kanaka Dasa"),
    ("Oottukkadu Venkata Kavi", "Oottukkadu Venkata Kavi"),
    ("Ootukkaadu Venkatasubbaiyyar", "Oottukkadu Venkata Kavi"),
    ("Ootukaadu Venkatasubbaiyyar", "Oottukkadu Venkata Kavi"),
    ("Oothukkaadu Venkatasubbaiyyar", "Oottukkadu Venkata Kavi"),
    ("Ootukkaadu Venkatasubba Iyer", "Oottukkadu Venkata Kavi"),
    ("Oottukkadu Venkatasubba Iyer", "Oottukkadu Venkata Kavi"),
    ("Annamacharya", "Annamacharya"),
    ("Tallapaka Annamacharya", "Annamacharya"),
    ("Annamayya", "Annamacharya"),
    ("Suddhananda Bharati", "Suddhananda Bharati"),
    ("Suddhaananda Bhaarati", "Suddhananda Bharati"),
    ("Shuddhananda Bharati", "Suddhananda Bharati"),
    ("Gopalakrishna Bharati", "Gopalakrishna Bharati"),
    ("Gopalakrishna Bharathi", "Gopalakrishna Bharati"),
    ("GopaalakrshNa Bhaarati", "Gopalakrishna Bharati"),
    ("Arunachala Kavi", "Arunachala Kavi"),
    ("Arunachala Kavirayar", "Arunachala Kavi"),
    ("Muthiah Bhagavathar", "Muthiah Bhagavathar"),
    ("Harikesanallur Muthiah Bhagavathar", "Muthiah Bhagavathar"),
    ("Koteeswara Iyer", "Koteeswara Iyer"),
    ("KOTEESWARA IYER", "Koteeswara Iyer"),
    ("Patnam Subramania Iyer", "Patnam Subramania Iyer"),
    ("Subramania Bharati", "Subramania Bharati"),
    ("Subramanya Bhaarati", "Subramania Bharati"),
    ("Bharathiyar", "Subramania Bharati"),
    ("Narayana Teertha", "Narayana Teertha"),
    ("NaaraayaNa Teertha", "Narayana Teertha"),
    ("Lalgudi Jayaraman", "Lalgudi Jayaraman"),
    ("Balamuralikrishna", "M. Balamuralikrishna"),
    ("M. Balamuralikrishna", "M. Balamuralikrishna"),
    ("GN Balasubramaniam", "G. N. Balasubramaniam"),
    ("G. N. Balasubramaniam", "G. N. Balasubramaniam"),
    ("Mysore Vasudevachar", "Mysore Vasudevachar"),
    ("Mysore VaasudEvaacaar", "Mysore Vasudevachar"),
    ("Periyasamy Thooran", "Periyasamy Thooran"),
    ("Ambujam Krishna", "Ambujam Krishna"),
    ("Mayuram Viswanatha Sastri", "Mayuram Viswanatha Sastri"),
    ("Vedanayakam Pillai", "Vedanayakam Pillai"),
    ("Dhandapani Desikar", "Dhandapani Desikar"),
]

BASE_TALAS: list[tuple[str, str]] = [
    ("Adi", "Adi"),
    ("Aadi", "Adi"),
    ("Adhi", "Adi"),
    ("t/Adi", "Adi"),
    (",,Aadi", "Adi"),
    ("Rupakam", "Rupakam"),
    ("Roopakam", "Rupakam"),
    ("Rupaka", "Rupakam"),
    ("Roopaka", "Rupakam"),
    ("c/rUpaka", "Rupakam"),
    ("Misra Chapu", "Misra Chapu"),
    ("Mishra Chapu", "Misra Chapu"),
    ("Misrachapu", "Misra Chapu"),
    ("Misra Caapu", "Misra Chapu"),
    ("m/capu", "Misra Chapu"),
    ("m/chapu", "Misra Chapu"),
    ("Khanda Chapu", "Khanda Chapu"),
    ("Khandachapu", "Khanda Chapu"),
    ("Khanda Caapu", "Khanda Chapu"),
    ("k/capu", "Khanda Chapu"),
    ("k/caou", "Khanda Chapu"),
    ("k/chapu", "Khanda Chapu"),
    ("Sankeerna Chapu", "Sankeerna Chapu"),
    ("s/capu", "Sankeerna Chapu"),
    ("s/chapu", "Sankeerna Chapu"),
    ("Chapu", "Chapu"),
    ("Caapu", "Chapu"),
    ("Tisra Eka", "Tisra Eka"),
    ("t/eka", "Tisra Eka"),
    ("Khanda Eka", "Khanda Eka"),
    ("k/eka", "Khanda Eka"),
    ("Misra Eka", "Misra Eka"),
    ("m/eka", "Misra Eka"),
    ("Chatusra Eka", "Chatusra Eka"),
    ("c/eka", "Chatusra Eka"),
    ("c?eka", "Chatusra Eka"),
    ("Sankeerna Eka", "Sankeerna Eka"),
    ("s/eka", "Sankeerna Eka"),
    ("Eka", "Eka"),
    ("Tisra Triputa", "Tisra Triputa"),
    ("Triputa", "Triputa"),
    ("Khanda Triputa", "Khanda Triputa"),
    ("Jhampa", "Jhampa"),
    ("Khanda Jhampa", "Khanda Jhampa"),
    ("Misra Jhampa", "Misra Jhampa"),
    ("Ata", "Ata"),
    ("Khanda Ata", "Khanda Ata"),
    ("Dhruva", "Dhruva"),
    ("Matya", "Matya"),
    ("Desadi", "Desadi"),
    ("Deshadi", "Desadi"),
    ("Madhyadi", "Madhyadi"),
]


def _build_maps():
    r_map = {_canon_key(k): v for k, v in BASE_RAGAS}
    c_map = {_canon_key(k): v for k, v in BASE_COMPOSERS}
    t_map = {_canon_key(k): v for k, v in BASE_TALAS}

    # Attempt to load studio/assets/tags files if available
    tag_dirs = [
        Path(__file__).resolve().parent.parent.parent / "studio" / "assets" / "tags",
        Path("/home/sreeh007/shuddha-sangeetham/studio/assets/tags"),
    ]
    for tag_dir in tag_dirs:
        rf = tag_dir / "ragas.txt"
        cf = tag_dir / "composers.txt"
        if rf.exists():
            for line in rf.read_text(encoding="utf-8", errors="replace").splitlines():
                line = line.strip()
                if not line or line.startswith("#") or line.startswith("["):
                    continue
                name, _, aliases = line.lstrip("*").partition("|")
                name = name.strip()
                k = _canon_key(name)
                if k not in r_map:
                    r_map[k] = name
                for a in aliases.split(","):
                    a = a.strip()
                    if a and _canon_key(a) not in r_map:
                        r_map[_canon_key(a)] = name
        if cf.exists():
            for line in cf.read_text(encoding="utf-8", errors="replace").splitlines():
                line = line.strip()
                if not line or line.startswith("#") or line.startswith("["):
                    continue
                name, _, aliases = line.lstrip("*").partition("|")
                name = name.strip()
                k = _canon_key(name)
                if k not in c_map:
                    c_map[k] = name
                for a in aliases.split(","):
                    a = a.strip()
                    if a and _canon_key(a) not in c_map:
                        c_map[_canon_key(a)] = name
        if rf.exists() or cf.exists():
            break

    # Re-apply explicit priority overrides
    for k, v in BASE_COMPOSERS:
        c_map[_canon_key(k)] = v
    for k, v in BASE_RAGAS:
        r_map[_canon_key(k)] = v

    return r_map, c_map, t_map


CANON_RAGAS, CANON_COMPOSERS, CANON_TALAS = _build_maps()


def canon_raga(name: str) -> str:
    """Return canonical raga spelling, or clean title-cased name."""
    if not name:
        return ""
    name = re.sub(r"[\.:,;]+$", "", name).strip()
    key = _canon_key(name)
    if not key or key == "unknown":
        return ""
    return CANON_RAGAS.get(key, clean_title(name))


def canon_composer(name: str) -> str:
    """Return canonical composer spelling, or clean title-cased name."""
    if not name:
        return ""
    name = re.sub(r"[\.:,;]+$", "", name).strip()
    key = _canon_key(name)
    if not key or "unknown" in key:
        return ""
    return CANON_COMPOSERS.get(key, clean_title(name))


def canon_tala(name: str) -> str:
    """Return canonical tala spelling, filtering noisy debris."""
    if not name:
        return ""
    clean = re.sub(r"^(?:no given tALA|given|t/|c/|,+)", "", name, flags=re.I).strip()
    clean = re.sub(r"[\.:,;/?\(\)]+$", "", clean).strip()
    clean = re.sub(r"^[\.:,;/?\(\)]+", "", clean).strip()
    key = _canon_key(clean)
    if not key or key in ("unknown", "nogivental", "nogiventala") or "bageshri" in key or "beat" in key:
        return ""
    if key in CANON_TALAS:
        return CANON_TALAS[key]
    for pattern, canonical in [
        (r"\bk/?c[ha]apu\b|\bkhanda\s*c[ha]apu\b", "Khanda Chapu"),
        (r"\bm/?c[ha]apu\b|\bmisra\s*c[ha]apu\b|\bmishra\s*c[ha]apu\b", "Misra Chapu"),
        (r"\bt/?aadi\b|\bt/?adi\b|\baadi\b|\badi\b", "Adi"),
        (r"\broopaka\b|\brupaka\b|\broopakam\b|\brupakam\b", "Rupakam"),
        (r"\bc/?c[ha]apu\b|\bc[ha]apu\b", "Chapu"),
        (r"\btriputa\b", "Triputa"),
        (r"\bjhampa\b", "Jhampa"),
        (r"\bata\b", "Ata"),
        (r"\bdhruva\b", "Dhruva"),
        (r"\bmatya\b", "Matya"),
        (r"\bdes[ha]di\b", "Desadi"),
    ]:
        if re.search(pattern, clean, re.I):
            return canonical
    return clean_title(clean) if len(clean) < 30 else ""
