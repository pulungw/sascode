import torch
from transformers import AutoTokenizer, AutoModelForMaskedLM
from fugashi import Tagger

# parse text using fugashi (mecab + unidic-lite)
def preprocessing_text(text):
    tagger = Tagger('-Owakati')
    parsed_text = tagger.parse(text)
    parsed_text = parsed_text.replace("[ MASK ]", "[MASK]")
    return parsed_text

text = "京都大学で自然言語処理を[MASK]する。"
parsed_text = preprocessing_text(text)

print(text)
print(parsed_text)

# import japanese language model from huggingface
tokenizer = AutoTokenizer.from_pretrained('ku-nlp/deberta-v2-base-japanese', cache_dir='./tmp')
model = AutoModelForMaskedLM.from_pretrained('ku-nlp/deberta-v2-base-japanese', cache_dir='./tmp')

# encode input parsed text
encoded_input = tokenizer(parsed_text, return_tensors='pt')
input_ids = encoded_input.input_ids
print(encoded_input)

# get location of mask token
masked_index = torch.where(input_ids == tokenizer.mask_token_id)[1].tolist()[0]
print(masked_index)

# predict mask
result = model(encoded_input.input_ids)
print(result)

# get top 5 result
pred_list = []
pred_ids = result[0][:, masked_index].topk(5).indices.tolist()[0]
for pred_id in pred_ids:
    output_ids = input_ids.tolist()[0]
    output_ids[masked_index] = pred_id
    pred_list.append(tokenizer.decode(output_ids))

print(pred_list)