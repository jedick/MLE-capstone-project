# Functions to evaluate predictions from multivers
# 20241216 jmd first version
# 20241219 added baseline()

# Usage:
#import eval
#data = eval.read_data('data/citint', 'test')
#predictions = eval.read_predictions('predictions/fever_citint_test.jsonl')
#f1 = eval.calc_metric(data, predictions)
#f1.round(2)

import numpy as np
import pandas as pd
from sklearn.metrics import f1_score, precision_score, recall_score, roc_auc_score
from matplotlib import pyplot as plt
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
import errno
import os

def read_data(datadir, fold):
    """
    Reads dataset (specified in datadir) with the given fold (train, dev, test).
    Returns a DataFrame
    """
    file = f'{datadir}/claims_{fold}.jsonl'
    # https://stackoverflow.com/questions/36077266/how-do-i-raise-a-filenotfounderror-properly
    if not os.path.isfile(file):
        raise FileNotFoundError(errno.ENOENT, os.strerror(errno.ENOENT), file)
    else:
        df = pd.read_json(file, lines=True)
    ## Print range of claim IDs
    #print('Range of claim IDs in '+fold+' in '+datadir+' is '+str(df['id'].min())+'..'+str(df['id'].max()))
    # Prepend a 'fold' column with the name of the fold
    df.insert(0, 'fold', fold)
    df['fold'] = df['fold'].astype('category')
    # To get the sentences and labels, use list comprehension to index into each of the dictionaries in the evidence column.
    sentences = [list(x.values())[0][0]['sentences'] if not (x == {} or pd.isnull(x)) else None for x in df['evidence']]
    label = [list(x.values())[0][0]['label'] if not (x == {} or pd.isnull(x)) else 'NEI' for x in df['evidence']]
    df['sentences'] = sentences
    df['label'] = label
    # No labels are available for the test fold
    df.loc[pd.isnull(df['evidence']), 'label'] = None
    return df


def read_predictions(file, get_label_probs=False):
    """
    Reads labels from a predictions file
    """
    # https://stackoverflow.com/questions/36077266/how-do-i-raise-a-filenotfounderror-properly
    if not os.path.isfile(file):
        raise FileNotFoundError(errno.ENOENT, os.strerror(errno.ENOENT), file)
    else:
        df = pd.read_json(file, lines=True)
    ## Print range of claim IDs
    #print('Range of claim IDs in '+file+' is '+str(df['id'].min())+'..'+str(df['id'].max()))

    # Start with empty lists for labels and label_probs
    label = []
    label_probs = []
    # Loop over evidence statements and pull out non-NEI ones if they exist
    for evidence in df['evidence']:
        # If the evidence is empty, then it's NEI
        if evidence == {}:
            evidence = {'0': {'label': 'NEI'}}
        for index, key in enumerate(evidence):
            if index == 0:
                # Start by keeping the first label for this claim
                this_label = evidence[key]['label']
                # Get the label probabilities if requested
                if get_label_probs:
                    this_label_probs = evidence[key]['label_probs']
            else:
                # Change NEI to a non-NEI label if one is found for this claim
                if this_label == 'NEI':
                    this_label = evidence[key]['label']
                    if get_label_probs:
                        this_label_probs = evidence[key]['label_probs']

        label.extend([this_label])
        if get_label_probs:
            label_probs.extend([this_label_probs])

    df['label'] = label
    if get_label_probs:
        df['label_probs'] = label_probs

    return df


def calc_metric(data, predictions, metric = 'f1'):
    """
    Calculates metric (f1, precision, or recall) using the 'label'
    column in the given data and predictions DataFrames.
    Returns metrics for REFUTE, NEI, SUPPORT, micro and macro average in that order.
    """

    # List labels in the order we want
    labels = ['REFUTE', 'NEI', 'SUPPORT']

    if metric == 'f1':
        score = f1_score
    elif metric == 'precision':
        score = precision_score
    elif metric == 'recall':
        score = recall_score
    else:
        raise ValueError(f'`metric` should be f1, precision or recall. Got {metric}.')

    # Score for each label
    label_scores = score(data.label, predictions.label, labels = labels, average = None)
    # Micro and macro averages
    micro_score = score(data.label, predictions.label, labels = labels, average = 'micro')
    macro_score = score(data.label, predictions.label, labels = labels, average = 'macro')
    # Combine scores
    scores = [*label_scores, micro_score, macro_score]
    # Return values as NumPy array
    return np.array(scores)


def calc_auroc(data, predictions):
    """
    Calculates AUROC using the 'label' column in the data and 'label_probs' in the predictions DataFrame.
    Returns metrics for REFUTE, NEI, SUPPORT, micro and macro average in that order.
    Uses multi_class='ovr' for compatibility with MulticlassAUROC in torchmetrics.
    """

    # Map labels to IDs
    label2id = {"REFUTE": 0, "NEI": 1, "SUPPORT": 2}
    label = data.label.map(label2id)
    # Get label probabilities into the right shape
    label_probs = np.stack(predictions.label_probs)

    # Score for each label
    label_scores = roc_auc_score(label, label_probs, average = None, multi_class='ovr')
    # Micro and macro averages
    micro_score = roc_auc_score(label, label_probs, average = 'micro', multi_class='ovr')
    macro_score = roc_auc_score(label, label_probs, average = 'macro', multi_class='ovr')
    # Combine scores
    scores = [*label_scores, micro_score, macro_score]
    # Return values as NumPy array
    return np.array(scores)


def baseline(datasets, folds, checkpoints, metric, decile = None, return_qcut = False):
    """
    Get specified metric for the given combination of datasets, folds, and checkpoints.
    Use decile = 'D1' to 'D10' to select claims with word counds in that decile.
    """

    # Initialize lists for non-numeric columns
    ds, fs, cs = [], [], []
    # Initialize empty array of the right shape
    columns = ['REFUTE', 'NEI', 'SUPPORT', 'micro', 'macro']
    metric_array = np.zeros(shape=(len(datasets) * len(checkpoints), len(columns)))
    # Loop over checkpoints and datasets
    for icheckpoint in range(len(checkpoints)):
        for idataset in range(len(datasets)):
            # Read the data and predictions
            dataset = datasets[idataset]
            fold = folds[idataset]
            checkpoint = checkpoints[icheckpoint]
            # Append the names to the lists
            ds.append(dataset)
            fs.append(fold)
            cs.append(checkpoint)
            labeled_data = read_data(f'../data/{dataset}', fold)
            predictions = read_predictions(f'../predictions/baseline/{checkpoint}_{dataset}_{fold}.jsonl')

            if decile is not None:
                # Calculate claim length (number of words)
                claim_length = labeled_data['claim'].apply(lambda x: len(str(x).split())).rename('claim_length')
                if return_qcut:
                    # Return 'raw' qcut to get bin ranges and value counts
                    qcut = pd.qcut(claim_length, q=10)
                    return qcut
                else:
                    # Keep the specific decile of the data
                    deciles = ['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'D10']
                    qcut = pd.qcut(claim_length, q=10, labels=deciles)
                    labeled_data = labeled_data[qcut==decile]
                    predictions = predictions[qcut==decile]

            metric_values = calc_metric(labeled_data, predictions, metric)
            # The row index where we'll put the results
            idx = len(datasets) * icheckpoint + idataset
            metric_array[idx] = metric_values
            metric_array

    metric_df = pd.DataFrame(metric_array, columns = columns)
    names_df = pd.DataFrame({'dataset': ds, 'fold': fs, 'checkpoint': cs})
    df = pd.concat([names_df, metric_df], axis = 1)
    # Add a leading column indicating the metric
    df.insert(0, 'metric', metric)
    return df


def plot_cm(data, predictions):
    """
    Plot confusion matrix
    """

    # https://stackoverflow.com/questions/61016110/plot-multiple-confusion-matrices-with-plot-confusion-matrix
    #fig, ax = plt.subplots(1, 2)
    #ax[0].set_title("bestModel-001")
    #ax[1].set_title("citint_20241128")
    #ConfusionMatrixDisplay(confusion_matrix(y_test, y_preds[0])).plot(ax=ax[0])
    #ConfusionMatrixDisplay(confusion_matrix(y_test, y_preds[2])).plot(ax=ax[1])

    ConfusionMatrixDisplay(confusion_matrix(data.label, predictions.label)).plot()

