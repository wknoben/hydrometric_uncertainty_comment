# hydrometric_uncertainty_comment
Code used to generate plots in "Comment on 'The Treatment of Uncertainty in Hydrometric Observations: A Probabilistic Description of Streamflow Records' 
by de Oliveira and Vrugt", by Knoben and Clark

## Code provenance
- `export_fig-master`: Downloaded from GitHub (Woodford and Altman, 2014) and redistributed under a BSD 3-Clause "New" or "Revised" License.
- `error_estimation.m`: Obtained from the Supporting Information from de Oliveira and Vrugt (2022; https://agupubs.onlinelibrary.wiley.com/action/downloadSupplement?doi=10.1029%2F2022WR032263&file=2022WR032263-sup-0001-Supporting+Information+SI-S01.pdf).

## Data provenance
- Bow River data (`05BB001_QR_Dec-22-2021_10_08_18PM.csv`): obtained from Environment and Climate Change Canada Real-time Hydrometric Data web site (https://wateroffice.ec.gc.ca/mainmenu/real_time_data_index_e.html) on Dec-22, 2021.
- Leaf River data (`02472000-usgs-hourly.csv`): Extracted from the hourly observations made available by Gauch et al. (2020)

## Workflow
Script `main_bow.m` generates the graphics used in the comment. The code generates one figure that was manually separated into two figures.

Script `main_leaf.m` generates the same graphic using data from the Leaf River (used as the main example if de Oliveira and Vrugt, 2022).

## Computational environment
Computations were performed with MATLAB R2019a.

## References
Gauch, M., Kratzert, F., Klotz, D., Nearing, G., Lin, J., & Hochreiter, 
S. (2020). Data for “rainfall-runoff prediction at multiple timescales 
with a single long short-term memory network”. Zenodo. Retrieved from 
https://doi.org/10.5281/zenodo.4072701 doi: 10.5281/zenodo.4072701

de Oliveira, D. Y., & Vrugt, J. A. (2022, November). The Treatment of Uncertainty in Hydrometric Observations: 
A Probabilistic Description of Streamflow Records. Water Resources Research, 58 (11). Retrieved 2022-11-30, from
https://onlinelibrary.wiley.com/doi/10.1029/2022WR032263 doi:10.1029/2022WR032263

Woodford, O. J., and Altman Y. (2014). export_fig: A toolbox for exporting figures from MATLAB to standard image and document formats nicely.
https://github.com/altmany/export_fig/
