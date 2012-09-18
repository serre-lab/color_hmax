
(1) compute Single-Opponent(SO)/Double-Opponent(DO) descriptors and energy mode in grayscale as well
===============
SODescriptor/DODescriptor: to compute SO/DO descriptors

energyRes: to compute energy response inspired from :
Edward H. Adelson and James R. Bergen, "Spatiotemporal energy models for the perception of motion," J. Opt. Soc. Am. A 2, 284-299 (1985) 



We provided two examples:
1. additive color image used in Zhang et al.2012

2. blue-sky image:
a representative color image to show how color descriptors work

You may need to change the normalization params according to different images.
In general, we found k=1, sigma=0.225 would be better for natural images which is constrained  by neural data.


---------------------------------------------------------------------------


(2) a biologically inspired grayscale/SO/DO Hmax model for object recognition
===============

Hmax model was successfully used in real data, see details in:
Serre, T., Wolf, L., Bileschi, S.M., Riesenhuber, M., Poggio, T.: Robust object
recognition with cortex-like mechanisms. IEEE Transactions on Pattern Analysis
and Machine Intelligence 29 (2007) 411-426

demoRelease  : grayscale Hmax
demoSoRelease: SOHmax (For most cases, two orientations of SO is sufficient due to the weekly oriented property)
demoDoRelease: DOHmax


dataset: soccer team dataset (color-predominant)
The dataset consists of 280 images falling into 7 classes, and was originally introduced in:
van de Weijer, J., Schmid, C.: Coloring local feature extraction. In: European
Conference on Computer Vision. (2006) 334-348



c1 prototypes:  randomly extracted from 250 patches of 4 patch sizes (1000 patches in total)

We provided three types of C1 patches:
dict_250_patches_4_sizes  : grayscale 
dictSo_250_patches_4_sizes: SO
dictDo_250_patches_4_sizes: DO



Publication:
A new biologically inspired color image descriptor.
Jun Zhang, Youssef Barhomi, and Thomas Serre 
In Proceedings of the IEEE Conference on European Conference on Computer Vision (ECCV), Florence, Italy, October 2012. 



For comments or questions, please contact Jun Zhang (zhangjun1126@gmail.com)

