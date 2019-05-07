# SpontActivityOfDevMitralCells
Codes used in the paper by Fujimoto, Leiwe et al. Currently only on biorxiv here - http://biorxiv.org/cgi/content/short/625616v1

Rough guide for how in-vivo images were processed
1) Use mnl_PreProcessing 
2) Use AFID (downloadable here - https://github.com/mleiwe/AFID)
3) Analyse individual images with mnl_SpontaneousAnalysis2
4) For Group Analysis
  a) Collate all image workspaces from each age group (mnl_CollateAllSpontData)
  b) Use the group analysis code (mnl_SpontGroupDataAnalysis)
  c) Measure the HL events across all images and groups (mnl_HandL_Events2Norm)
 
In-vitro images were processed in the following manner... (SF to complete)



If there are any queeries please contact...
For In-Vivo: m-leiwe"at"med.kyushu-u.ac.jp
For In-Vitro: sfujimoto"at"med.kyushu-u.ac.jp
