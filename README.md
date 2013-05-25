(1) Compute Single-Opponent (SO) / Double-Opponent (DO) descriptors as wells as (grayscale) energy model
===============
SODescriptor.m / DODescriptor.m: Compute SO/DO descriptors
energyRes.m: Compute energy response based on Adelson & Bergen (1985)

We provide two examples to show how color descriptors work:
1. additive color image used in Zhang et al (2012)
2. blue-sky image: a representative color image

The normalization paramaters may need to be adjusted depending on the type of images.
In general, we found k = 1, sigma = 0.225 to work well for natural images.

---------------------------------------------------------------------------

(2) An extension of HMAX model (Serre et al, 2007) to include color information 
===============

demoRelease.m  : grayscale Hmax
demoSoRelease.m: SOHmax (for most cases, two orientations of SO is sufficient because of their weak orientation tuning)
demoDoRelease.m: DOHmax

Dictionary of S2 units:  randomly extracted -- 250 patches of 4 patch sizes (1000 patches in total)

We provide three types of dictionaries:
dict_250_patches_4_sizes  : grayscale 
dictSo_250_patches_4_sizes: SO
dictDo_250_patches_4_sizes: DO


If you use the code, please cite: Zhang J., Barhomi Y., and Serre T. A new biologically inspired color image descriptor.In: ECCV, Florence, Italy, October 2012. 


For comments or questions, please contact Jun Zhang (zhangjun1126@gmail.com) or Thomas Serre (thomas_serre@brown.edu).
