# Landmark graphs matching

This repository contains a demo implementation of the ground-to-aerial viewpoint localization strategy proposed in the related paper [1] along with a set of annotated image pairs from CVUSA dataset [2]. 

Given a pair of associated ground and aerial images, annotated with a list of landmarks and labels (buildings, roads, vegetation and so on), a graph is created by connecting co-visible landmarks. The viewpoint of the ground image is automatically localized in the aerial image by comparing the ground-graph to multiple candidate subgraphs of the aerial view, in a Bayesian probabilistic framework. 


## Instructions

Requires Matlab R2019b or higher.

To run the code, open the main script "landmark_graph_matching.m". 

In the "Set-up" section, it is possible to:

	- Select an image name from the dataset (row 20);
	- Modify the size of the class dictionary and specify which classes to consider (row 24);
	- Select the number of top-K localization results to visualize (row 27);
	- Enable/disable the 360-degree adjacency rule for ground images (see Section II-A of the main paper). 


The code produces four images:

	1. Aerial image with indication of the ground-truth viewpoint;
	2. Aerial image with the overlayed landmark graph;
	3. Ground image with the overlayed landmark graph;
	4. Aerial image with candidate locations (in orange) and top-K localization results (in green). 
	

## References

[1] S. Verde, T. Resek, S. Milani, A. Rocha, "Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching", accepted by IEEE Signal Processing Letters, 2020.

[2] S. Workman, R. Souvenir, and N. Jacobs, "Wide-area image geolocalization with aerial reference imagery," in Proceedings of the IEEE International Conference on Computer Vision, 2015, pp. 3961–3969.
