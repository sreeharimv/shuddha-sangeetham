import sys
import unittest
from pathlib import Path

# Ensure scraper package directory is on sys.path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from bs4 import BeautifulSoup
from scraper import parse_krithi_page

FIXTURES_DIR = Path(__file__).parent / "fixtures"


class ScraperParserTestCase(unittest.TestCase):
    def _read_fixture(self, name: str) -> str:
        return (FIXTURES_DIR / name).read_text(encoding="utf-8", errors="replace")

    def test_c1618_abhaya_karattai(self):
        """
        c1618.shtml:
        - Must have clean canonical metadata (Behag, Rupakam, Suddhananda Bharati, Tamil).
        - Must NOT leak Tamil transliteration or Indic script into charanam.
        - Must NOT have navigation debris (first | previous | next, Contact us).
        - Must NOT have mid-word ITRANS capitals (parta pode, accam ozhinden).
        """
        html = self._read_fixture("c1618.html")
        data = parse_krithi_page(html, 1618)
        self.assertIsNotNone(data)
        self.assertEqual(data["name"], "Abhaya Karattai")
        self.assertEqual(data["raga"], "Behag")
        self.assertEqual(data["tala"], "Rupakam")
        self.assertEqual(data["composer"], "Suddhananda Bharati")
        self.assertEqual(data["language"], "Tamil")

        self.assertIn("abhaya karattai parta pode accam ozhinden", data["pallavi"])
        self.assertIn("udaya padam patrum anbar", data["anupallavi"])
        self.assertIn("kuncita pada nizhalinil", data["charanam"])

        # No Indic script, no transliteration label, no footers
        self.assertNotIn("Tamil transliteration", data["charanam"])
        self.assertNotIn("Contact us", data["charanam"])
        self.assertNotIn("first | previous", data["charanam"])
        # No mid-word capitals
        self.assertNotIn("pArta", data["pallavi"])
        self.assertNotIn("ozhindEn", data["pallavi"])

    def test_c6670_abadh_sukhdayi(self):
        """
        c6670.shtml:
        - Must separate inline caraNam 1, 2, 3 into distinct stanzas.
        - Must NOT flatten linebreaks into spaces.
        - Must NOT embed 'caraNam 2' or 'caraNam 3' as raw words in the lyrics.
        - Must NOT contain Meaning, Notation, or contributor credits.
        """
        html = self._read_fixture("c6670.html")
        data = parse_krithi_page(html, 6670)
        self.assertIsNotNone(data)
        self.assertEqual(data["name"], "Abadh Sukhdayi")
        self.assertEqual(data["raga"], "Bhairav")
        self.assertEqual(data["tala"], "Adi")
        self.assertEqual(data["composer"], "Swati Tirunal")

        self.assertEqual(data["pallavi"], "Abadh sukhdayi ab baje badhai")
        self.assertEqual(data["anupallavi"], "")

        # Stanzas must be cleanly formatted
        self.assertIn("1:\nratna simhasan ke par raghupati sita sahit suhayo", data["charanam"])
        self.assertIn("2:\ngav gav jan mangal gavat devan bajayo", data["charanam"])
        self.assertIn("3:\nmata kausalya karat aratii nij man vancit payo", data["charanam"])

        # No trailing commentary / notation / credits
        self.assertNotIn("Meaning:", data["charanam"])
        self.assertNotIn("Notation:", data["charanam"])
        self.assertNotIn("Lakshman Ragde", data["charanam"])

    def test_c1007_enna_thavam(self):
        """
        c1007.shtml:
        - Must NOT leak English line-by-line meanings into charanam.
        - Must NOT have Gayaka / notation links.
        - Must have clean Kapi, Adi, Papanasam Sivan.
        - Must separate caraNam 1 and caraNam 2 into numbered stanzas.
        """
        html = self._read_fixture("c1007.html")
        data = parse_krithi_page(html, 1007)
        self.assertIsNotNone(data)
        self.assertIn("Enna", data["name"])
        self.assertEqual(data["raga"], "Kapi")
        self.assertEqual(data["tala"], "Adi")
        self.assertEqual(data["composer"], "Papanasam Sivan")

        self.assertIn("enna tavam sheidanai yasoda", data["pallavi"])
        self.assertIn("irezu bhuvanangal", data["anupallavi"])
        self.assertIn("1:\nbhramanum indranum", data["charanam"])
        self.assertIn("2:\nsanakadiyar tava yogam", data["charanam"])

        # No meaning prose in charanam
        self.assertNotIn("Yashoda, what tapas", data["charanam"])
        self.assertNotIn("Sanakaa achieved through great tapas", data["charanam"])
        self.assertNotIn("Gayaka", data["charanam"])
        self.assertNotIn("Lakshman Ragde", data["charanam"])
        self.assertNotIn("Contact us", data["charanam"])

    def test_c1009_himadri_sute(self):
        """
        c1009.shtml:
        - Must parse Syama Sastri, Kalyani, Rupakam.
        - Charanams 1, 2, 3 cleanly numbered and formatted.
        """
        html = self._read_fixture("c1009.html")
        data = parse_krithi_page(html, 1009)
        self.assertIsNotNone(data)
        self.assertEqual(data["raga"], "Kalyani")
        self.assertEqual(data["tala"], "Rupakam")
        self.assertEqual(data["composer"], "Syama Sastri")

        self.assertIn("himadrisute pahimam", data["pallavi"])
        self.assertIn("1:\nhemagatri pankajanetri", data["charanam"])
        self.assertIn("2:\nambujari nibhavadane", data["charanam"])
        self.assertIn("3:\nshyamakrsna sodari", data["charanam"])

    def test_canonical_normalization(self):
        from canonical import (
            canon_raga,
            canon_composer,
            canon_tala,
            clean_title,
            clean_lyrics_text,
            strip_diacritics,
        )

        # Diacritics
        self.assertEqual(strip_diacritics("śrī rāma"), "sri rama")

        # Ragas
        self.assertEqual(canon_raga("kaapi"), "Kapi")
        self.assertEqual(canon_raga("kalyaaNi"), "Kalyani")
        self.assertEqual(canon_raga("Dheera Shankarabharanam"), "Shankarabharanam")
        self.assertEqual(canon_raga("Aananda Bhairavi"), "Anandabhairavi")
        self.assertEqual(canon_raga("Thodi"), "Todi")

        # Composers
        self.assertEqual(canon_composer("Tyaagaraaja"), "Tyagaraja")
        self.assertEqual(canon_composer("Thyagaraja"), "Tyagaraja")
        self.assertEqual(canon_composer("Muttuswaamee Dikshitar"), "Muthuswami Dikshitar")
        self.assertEqual(canon_composer("Swaati TirunaaL"), "Swati Tirunal")
        self.assertEqual(canon_composer("Paapanaasam Shivan"), "Papanasam Sivan")
        self.assertEqual(canon_composer("Shyaamaa Shaastree"), "Syama Sastri")

        # Talas
        self.assertEqual(canon_tala("t/Adi"), "Adi")
        self.assertEqual(canon_tala(",,Aadi"), "Adi")
        self.assertEqual(canon_tala("Aadi (2 Kalai)"), "Adi")
        self.assertEqual(canon_tala("c/rUpaka"), "Rupakam")
        self.assertEqual(canon_tala("Roopakam"), "Rupakam")
        self.assertEqual(canon_tala("Mishra Chapu"), "Misra Chapu")
        self.assertEqual(canon_tala("?"), "")
        self.assertEqual(canon_tala("no given tala"), "")

        # Clean title
        self.assertEqual(clean_title("sItApati"), "Sitapati")
        self.assertEqual(clean_title("kAntimayiyum"), "Kantimayiyum")

        # Clean lyrics
        lyrics = "sItApati nA manasuna kAntimayiyum balattAl ozhindEn\n1:\nkarat Aratii"
        cleaned = clean_lyrics_text(lyrics)
        self.assertEqual(
            cleaned,
            "sitapati na manasuna kantimayiyum balattal ozhinden\n1:\nkarat aratii",
        )

    def test_clean_record_from_catalog(self):
        from clean_catalog import clean_record

        old_sample = {
            "page_id": 6670,
            "name": "Abadh sukhdAyi",
            "raga": "bhairav",
            "tala": "Adi",
            "composer": "Swaati TirunaaL",
            "pallavi": "Abadh sukhdAyi ab bAjE badhAi",
            "anupallavi": "",
            "charanam": (
                "ratna simhAsan kE pAr raghupati sItA sahit suhAyO rAm "
                "caraNam 2 gAv gAv jan mangal gAvat dEvan bajAyO "
                "caraNam 3 mAtA kausalyA karat AratiI nij man vAncit pAyO "
                ": Meaning: Rama sitting on the throne... Contact us"
            ),
        }

        cleaned = clean_record(old_sample)
        self.assertEqual(cleaned["name"], "Abadh Sukhdayi")
        self.assertEqual(cleaned["raga"], "Bhairav")
        self.assertEqual(cleaned["composer"], "Swati Tirunal")
        self.assertEqual(cleaned["tala"], "Adi")
        self.assertEqual(cleaned["pallavi"], "Abadh sukhdayi ab baje badhai")
        self.assertIn("1:\nratna simhasan ke par raghupati sita sahit suhayo", cleaned["charanam"])
        self.assertIn("2:\ngav gav jan mangal gavat devan bajayo", cleaned["charanam"])
        self.assertIn("3:\nmata kausalya karat aratii nij man vancit payo", cleaned["charanam"])
        self.assertNotIn("Meaning:", cleaned["charanam"])
        self.assertNotIn("Contact us", cleaned["charanam"])


if __name__ == "__main__":
    unittest.main()
