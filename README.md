
(1) compute Single-Opponent(SO)/Double-Opponent(DO) descriptors and  (grayscale) energy model as well
===============
SODescriptor.m / DODescriptor.m: to compute SO/DO descriptors

energyRes.m: to compute energy response inspired from :
Edward H. Adelson and James R. Bergen. Spatiotemporal energy models for the perception of motion. JOSA, 1985



We provided two examples to show how color descriptors work:
1. an additive color image used in Zhang et al.2012
2. blue-sky image:a representative color image

You may need adjust the normalization params in terms of different images.
In general, we found k=1, sigma=0.225 would be better for natural images which is constrained by neural data.



---------------------------------------------------------------------------
(2) a biologically inspired grayscale/SO/DO-Hmax model for object recognition
===============

HMAX model was successfully used in real data, see details in:
Serre, T., Wolf, L., Bileschi, S.M., Riesenhuber, M., Poggio, T. Robust object
recognition with cortex-like mechanisms.TPAMI, 2007.

demoRelease.m  : grayscale Hmax
demoSoRelease.m: SOHmax (For most cases, two orientations of SO is sufficient due to the weekly oriented property)
demoDoRelease.m: DOHmax

c1 prototypes:  randomly extracted from 250 patches of 4 patch sizes (1000 patches in total)

We provided three types of C1 patches for examples:
dict_250_patches_4_sizes  : grayscale 
dictSo_250_patches_4_sizes: SO
dictDo_250_patches_4_sizes: DO


dataset: soccer team dataset (color-predominant)
The dataset consists of 280 images falling into 7 classes, and was originally introduced in:
van de Weijer, J., Schmid, C. Coloring local feature extraction. In: ECCV, 2006.




If you use the code, please cite:
Zhang J., Barhomi Y., and Serre T. A new biologically inspired color image descriptor.In: ECCV, Florence, Italy, October 2012. 


For comments or questions, please contact Jun Zhang (zhangjun1126@gmail.com)

