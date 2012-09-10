
(1) compute Single-Opponent(SO)/Double-Opponent(DO) descriptors and energy mode in grayscale as well
===============
SODescriptor/DODescriptor: to compute SO/DO descriptors

energyRes: to compute energy response inspired from :
Edward H. Adelson and James R. Bergen, "Spatiotemporal energy models for the perception of motion," J. Opt. Soc. Am. A 2, 284-299 (1985) 



We provided two examples:
1. additive color used in Zhang et al.2012

2. blue-sky image:
a representative color image to show how color descriptors work






(2) a biologically inspired grayscale/SO/DO Hmax model for object recognition
===============

Hmax model was successfully used in real data, see details in:
Serre, T., Wolf, L., Bileschi, S.M., Riesenhuber, M., Poggio, T.: Robust object
recognition with cortex-like mechanisms. IEEE Transactions on Pattern Analysis
and Machine Intelligence 29 (2007) 411-426

demoRelease: grayscale Hmax
demoSoRelease: SOHmax
demoDoRelease: DOHmax


dataset: soccer team dataset (color-predominant)
There are 7 classes and 40 images for each class.
It was originally used in:
van de Weijer, J., Schmid, C.: Coloring local feature extraction. In: European
Conference on Computer Vision. (2006) 334-348



c1 prototypes:  randomly extracted from 250 patches of 4 patch sizes (1000 patches in total)
-----------------------------------------------
We provide three set of C1 prototypes:
1. dict_250_patches_4_sizes.mat
grayscale mode

2. dictSo_250_patches_4_sizes.mat
Single-Opponent mode

3. dictDo_250_patches_4_sizes.mat
Double-Opponent mode





