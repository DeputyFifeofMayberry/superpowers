import unittest
from app.search import normalize_query

class SearchTest(unittest.TestCase):
    def test_trim(self):
        self.assertEqual(normalize_query(" release status "), "release status")
