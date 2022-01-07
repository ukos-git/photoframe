import cv2
import numpy as np
from sklearn.cluster import KMeans

def visualize_colors(colors):
    """
    Source: https://stackoverflow.com/a/58177484/7809404
    """
    rect = np.zeros((50, 300, 3), dtype=np.uint8)
    start = 0
    for (percent, color) in colors:
        print(color, "{:0.2f}%".format(percent * 100))
        end = start + (percent * 300)
        cv2.rectangle(rect, (int(start), 0), (int(end), 50), \
                      color.astype("uint8").tolist(), -1)
        start = end
    return cv2.cvtColor(rect, cv2.COLOR_RGB2BGR)


def find_dominant_colors(file_name):
    """
    Source: https://stackoverflow.com/a/58177484/7809404
    """
    # Load image and convert to a list of pixels
    image = cv2.imread(file_name)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    reshape = image.reshape((image.shape[0] * image.shape[1], 3))
    # Find most dominant colors
    cluster = KMeans(n_clusters=5).fit(reshape)
    # Get the number of different clusters, create histogram, and normalize
    labels = np.arange(0, len(np.unique(cluster.labels_)) + 1)
    (hist, _) = np.histogram(cluster.labels_, bins=labels)
    normalized_hist = hist.astype('float') / hist.sum()
    # Create frequency rect and iterate through each cluster's color and percentage
    colors = sorted(zip(normalized_hist, cluster.cluster_centers_))
    for (percent, color) in colors:
        print('{:.2f}%'.format(percent * 100), color)
    return colors

colors = find_dominant_colors('../media/1986-am_weg_zur_oberen_quelle.png')
print('most dominant color:', colors[-1])
visualize = visualize_colors(colors)
cv2.imshow('visualize', visualize)
cv2.waitKey()
