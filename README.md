# MATLAB “Format Painter” for Publication-Quality Figures

# Introduction

1. Figure preparation is an important part of academic paper writing. However, producing figures with appropriate dimensions and font sizes can be tedious. This project provides a code-based method for controlling the appearance of MATLAB figures, which can be regarded as a MATLAB “format painter” for publication-quality figures.

# Motivation and Solution

1. Manually adjusting figure dimensions is inconvenient, especially when resizing figure windows with a mouse, since the resulting dimensions are difficult to control precisely. MATLAB provides interfaces for explicitly controlling figure dimensions [^1], and several practical approaches have also been discussed by the MATLAB community [^2].

1. The main MATLAB properties used in this project are:

   - `Position` (`PaperPosition`): controls the figure width and height.
     - `Position` controls the figure size displayed on the screen.
     - `PaperPosition` controls the figure size used for printing and exporting.

   - `Units` (`PaperUnits`): specifies the units used for figure dimensions, such as centimeters (`cm`).
     - `Units` corresponds to `Position`.
     - `PaperUnits` corresponds to `PaperPosition`.

   - `LooseInset` [^3]: controls the spacing between the axes and the figure boundary.

   - `FontSize`: controls the font size of text objects in the figure.
     - The font sizes of `xlabel` and `ylabel` can be explicitly set using
       ```matlab
       set(get(ax, 'xlabel'), 'FontSize', 8);
       set(get(ax, 'ylabel'), 'FontSize', 8);
       ```
     - The legend font size can be set using
       ```matlab
       legend('FontSize', 8);
       ```

# IEEE Format Adaptation

1. According to `IEEEtran.cls` [^4], the document `\textwidth` is `43pc`, while the single-column `\linewidth` is `21pc`. Therefore, the figure dimensions should be determined according to whether the figure occupies a single column or both columns.

   - Since
     ```text
     1pc = 0.421751764217518cm
     ```
     [^5], the maximum widths are approximately
     ```text
     Single column: 21 × 0.42175 cm
     Double column: 43 × 0.42175 cm
     ```

   - Since the physical dimensions of the figure are already specified in MATLAB, the exported figure can be inserted directly in LaTeX using
     ```latex
     \includegraphics{file.eps}
     ```
     without additional scaling.

   - Avoiding unnecessary scaling in LaTeX helps maintain consistent font sizes and line widths across figures.

# Installation

1. Download or clone this repository:

   ```bash
   git clone https://github.com/sikouhjw/matlab-figure-formatter.git
   ```

2. Add the repository directory to the MATLAB search path. This can be done temporarily using

   ```matlab
   addpath('path/to/repository');
   ```

   or permanently using

   ```matlab
   addpath('path/to/repository');
   savepath;
   ```

   Alternatively, the repository directory can be added through MATLAB:

   ```text
   Home → Set Path → Add Folder
   ```

3. After the directory has been added to the MATLAB path, `formatFigure` can be called directly from any MATLAB script:

   ```matlab
   formatFigure;
   ```

4. The optional `SimSun-TNR.ttf` font is used to support mixed Chinese and English text, with SimSun for Chinese characters and Times New Roman for English characters.

   - On Windows, the function checks whether the following font file exists:

     ```text
     C:/Windows/Fonts/SimSun-TNR.ttf
     ```

   - If the font is unavailable, Times New Roman is used instead.

   - The font configuration does not affect the basic figure-sizing functionality.

# Usage

1. Based on the above settings, this project provides the following MATLAB function for IEEE-style figures:

   ```matlab
   formatFigure(widthPercent, heightRatio, columnMode)
   ```

   The function performs the following operations:

   - The reference width is determined by `columnMode`:
     - `"single"`: single-column width;
     - `"double"`: double-column width.
     - The default mode is `"single"`.

   - The figure width and height are respectively set to
     ```text
     x × 0.42175 cm × widthPercent / 100
     ```
     and
     ```text
     width × heightRatio
     ```
     where
     ```text
     x = 21  for single-column figures
     x = 43  for double-column figures
     ```

   - If the corresponding arguments are omitted, the default values are
     ```matlab
     widthPercent = 100;
     heightRatio  = 0.75;
     columnMode   = "single";
     ```

   - The font size of all text objects, including axis labels and legends, is set to `8pt`.
     - `8pt` is commonly used for IEEE single-column figures.

   - The font configuration is:
     - Chinese text: SimSun;
     - English text: Times New Roman.

     If `SimSun-TNR.ttf` is not installed, only Times New Roman is used. If the `fontname` command is unavailable, the font-setting operation is skipped.

2. Example:

   ```matlab
   plot(x, y);
   xlabel('Iteration, \it t');
   ylabel('MSE [dB]');
   legend('Location', 'northeast');

   formatFigure;
   ```

3. Some commonly used figure layouts are:

   - Two subfigures:
     - Side by side:
       ```matlab
       formatFigure(50, 1)
       ```
     - Vertically stacked:
       ```matlab
       formatFigure(100, 0.5)
       ```

   - Three subfigures:
     - Side by side:
       ```matlab
       formatFigure(100/3, 3/2)
       ```
     - Vertically stacked:
       ```matlab
       formatFigure(100, 1/3)
       ```

   - For a double-column figure, specify `"double"` as the third argument, for example:

     ```matlab
     formatFigure(100, 0.5, "double")
     ```

   - The `./Demonstration` folder also contains executable MATLAB examples and corresponding LaTeX layout examples.

# Additional Notes

1. When some text objects use font sizes smaller than `8pt`, for example when adjusting a figure under strict space limitations, directly saving the figure as an EPS file may cause the exported text to be reset to `8pt`.

   In this case, the figure can be exported using

   ```matlab
   print(gcf, '-depsc', 'file.eps');
   ```

   or

   ```matlab
   exportgraphics( ...
       gcf, ...
       'file.pdf', ...
       'ContentType', 'vector', ...
       'BackgroundColor', 'none');
   ```

   to generate vector `.eps` or `.pdf` files.

1. Mathematical symbols in axis labels should ideally use mathematical fonts. However, the MATLAB `\it` command only produces italic text and does not provide a true mathematical font. In addition, MATLAB does not allow the font family to be freely changed when the `latex` interpreter is used.

   The `xlabel_Iteration_formatter` function provides a workaround:

   - First, a normal text label is generated together with an invisible italic placeholder, for example:
     ```matlab
     'Iteration, {\color{white}\it t}'
     ```

   - The position of the `xlabel` can then be obtained from MATLAB.

   - A mathematical symbol rendered using the `latex` interpreter is placed at the corresponding position.

   - By adjusting the position of the mathematical symbol, it can be overlaid on the invisible placeholder, thereby producing a label containing both normal text and a true mathematical symbol.

[^1]: [MATLAB Figure Properties](https://ww2.mathworks.cn/help/matlab/ref/matlab.ui.figure.html)

[^2]: [How to Change Figure Size](https://ww2.mathworks.cn/matlabcentral/answers/173629-how-to-change-figure-size)

[^3]: [MATLAB Axes LooseInset Property](https://undocumentedmatlab.com/articles/axes-looseinset-property)

[^4]: [IEEEtran.cls](https://mirrors.ctan.org/macros/latex/contrib/IEEEtran/IEEEtran.cls)

[^5]: [LaTeX Length Units](https://medemanabu.net/latex/length-units/)