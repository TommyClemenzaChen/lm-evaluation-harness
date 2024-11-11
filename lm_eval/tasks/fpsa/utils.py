import datasets

label_map = {
    0: "negative",
    1: "neutral",
    2: "postive",
}

def process_docs(dataset: datasets.Dataset) -> datasets.Dataset:
    def _process_doc(doc):
        out_doc = {
            "query": doc['sentence'],
            "choices": ['negative', 'neutral', 'positive'],
            "gold": label_map[doc['label']],
        }
        return out_doc

    return dataset.map(_process_doc)