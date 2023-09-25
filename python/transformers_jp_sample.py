import torch
from transformers import AutoTokenizer, AutoModelForMaskedLM
from fugashi import Tagger

def preprocessing_text(text):
    tagger = Tagger('-Owakati')
    parsed_text = tagger.parse(text)
    parsed_text = parsed_text.replace("[ MASK ]", "[MASK]")
    return parsed_text

text = "京都大学で自然言語処理を[MASK]する。"
# mecab(fugashi)でテキストパース(unidic-lite)
input_text = preprocessing_text(text)
print(text)
print(input_text)
