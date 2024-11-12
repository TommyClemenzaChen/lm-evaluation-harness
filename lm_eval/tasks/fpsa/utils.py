import datasets


def process_docs(dataset: datasets.Dataset) -> datasets.Dataset:
    def _process_doc(doc):
        out_doc = {
            "query": doc['sentence'],
            "choices": ['negative', 'neutral', 'positive'],
            "gold": doc['label'],
        }
        return out_doc

    return dataset.map(_process_doc)