# Portilla & Simoncelli Texture Synthesis Batch Processing (Modified)

This repository contains a modified version of the original Portilla & Simoncelli texture analysis and synthesis code, adapted for batch processing multiple input images and synthesizing multiple variants of each. This version includes bug fixes and modern MATLAB compatibility improvements.

---

## 🔧 Summary of Code Modifications

### `textureSynthesis.m`

| Change | Reason | Implementation |
|--------|--------|----------------|
| Commented out `figure`, `imshow`, `subplot`, `drawnow` | Prevents unwanted plot windows | Lines commented or wrapped with conditionals |
| Replaced `gcf - 1` logic | Fixes error on modern MATLAB versions | Replaced with safer logic or removed |
| Added `overrideNsc` argument | Enables control over pyramid depth in synthesis | `if exist('overrideNsc', ...)` block added |
| Corrected `im0` handling | Prevents interpretation of scalar as image | Passed `size(img)` explicitly to `textureSynthesis` |

### `textureAnalysis.m`

| Change | Reason | Implementation |
|--------|--------|----------------|
| Commented out all plotting | Prevents figure popups | All `figure`, `imshow`, `subplot` lines commented |

---

## ⚙️ Batch Synthesis Script (`DG_batch_synthesis.m`)

### Configuration

- `inputDir`: Folder containing input grayscale images
- `outputDir`: Folder to save generated PNGs
- `numVariants`: Number of texture variants to generate per input image
- `Nsc`: Number of pyramid scales (adjusted dynamically)
- `Nor`: Number of orientations
- `Na`: Size of local spatial neighborhood (e.g., 7)
- `Niter`: Iterations of synthesis

### Processing Loop

For each image:
1. Convert to grayscale, ensure pixel values are in [0, 1]
2. Dynamically adjust `Nsc` to avoid pyramid depth errors
3. Analyze image texture using `textureAnalysis`
4. Loop `numVariants` times:
   - Generate a synthetic variant using `textureSynthesis`
   - Save as PNG in `outputDir`

### Figure Suppression

- MATLAB figure rendering disabled with:
  ```matlab
  set(0, 'DefaultFigureVisible', 'off');
  ```
- Plotting code disabled inside analysis/synthesis functions

---

## 🧪 Common Errors & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `Cannot build pyramid higher than 2 levels` | `Nsc` too large | Dynamically reduce using `safeNsc` |
| `Operator '-' not supported for type 'matlab.ui.Figure'` | Use of `gcf - 1` | Removed or restructured |
| `imask size 1 does not match image dimensions` | `Niter` passed as image input | Used `size(img)` explicitly |
| `Image out of range` | Pixel values < 0 or > 1 | Clipped using `min(max(img, 0), 1)` |
| Figures pop up after run | Buffered `figure(...)` | Disabled via `DefaultFigureVisible` |

---

## ✅ Final Notes

This version is ideal for headless, large-scale texture synthesis experiments. All modifications are backward-compatible with the original Portilla & Simoncelli code structure.

Please cite the original paper if you use this work in academic research:

> **A Parametric Texture Model based on Joint Statistics of Complex Wavelet Coefficients**, J. Portilla & E. P. Simoncelli. *IJCV*, 2000.
