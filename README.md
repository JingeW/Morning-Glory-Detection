# Morning-Gloary-Detection
Matlab project

Edit by Jinge Wang
Date: 6/15/2020

****************************************
Instruction:(Need to install matlab first)
The "main.fig" is the user interface file.
Run "main.m" to activate the app interface.

1. Click "Open New Image" to load the image you want to detect. Browse and choose the image in the pop-up window.
2. Choose the segmentation method for shadow removal, and click "Segment" to apply it.
	2.1 K-means
		The parameter of K-means is the number of the cluster. The default k equals 3.
		Small k's can avoid most of the noise in the shadow. Large k's provide more details.
	2.2 Mean shift
		The parameter of Mean shift is the bandwidth of the kernel. The default bw equals to 0.2.
		A faster method for segmentation. The detection result is very similar to the K-means when k = 3.
3. Click "Mask" to generate the binary mask for shadow removal.
4. Click "Output" to get the detection result.
5.(optional) Save the image.
6. Click "Count" to count the number of detected clusters.
****************************************


* After each step you might need to wait for a few seconds to see the image change, which indicates the current step finished. 
  The waiting time depends on the input file size and computing speed.

* This app referenced the mean shift method from K. Funkunaga and L.D. Hosteler, 
  "The Estimation of the Gradient of a Density Function, with Applications in Pattern Recognition"
