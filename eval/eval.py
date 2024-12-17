# Functions to evaluate predictions from multivers
# 20241216 jmd first version

# Usage:
#import eval
#data = eval.read_data('data/citint', 'test')
#predictions = eval.read_predictions('predictions/fever_citint_test.jsonl')
#f1 = eval.calc_f1(data, predictions)
#f1.round(2)

import numpy as np
import pandas as pd
from sklearn.metrics import f1_score
from matplotlib import pyplot as plt
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
import errno
import os

def read_data(datadir, fold):
    """
    Reads [citint|scifact] dataset of the given fold (train, dev, test).
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


def read_predictions(file):
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
    # To get the labels, use list comprehension to index into each of the dictionaries in the evidence column.
    label = [list(x.values())[0]['label'] if not (x == {} or pd.isnull(x)) else 'NEI' for x in df['evidence']]
    df['label'] = label
    return df


def calc_f1(data, predictions):
    """
    Calculates F1 using 'label' column in data and predictions DataFrames.
    Returns F1 for SUPPORT, REFUTE, NEI, micro and macro average in that order.
    """

    # List labels in the order we want
    labels = ['SUPPORT', 'REFUTE', 'NEI']

    # F1 score for each label
    f1_labels = f1_score(data.label, predictions.label, labels = labels, average = None)
    # Micro and macro averages
    f1_micro = f1_score(data.label, predictions.label, labels = labels, average = 'micro')
    f1_macro = f1_score(data.label, predictions.label, labels = labels, average = 'macro')
    # Combine F1 scores
    f1 = [*f1_labels, f1_micro, f1_macro]
    # Return values as NumPy array
    return np.array(f1)


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

