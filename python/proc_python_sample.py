import pandas
import torch
from transformers import pipeline

unmasker = pipeline("fill-mask")

unmasker("This course will teach you all about <mask> models.", top_k=5)