function formatFigure(widthPercent, heightRatio, columnMode)

  if nargin < 1 || isempty(widthPercent)
    widthPercent = 100;
  end
  if nargin < 2 || isempty(heightRatio)
    heightRatio = 0.75;
  end
  if nargin < 3 || isempty(columnMode)
    columnMode = "single";
  end

  fig = gcf;
  ax  = gca;

  box(ax, 'on');

  % Column width in centimeters
  if strcmpi(columnMode, "double")
    colWidth = 43 * 0.42175;
  else
    colWidth = 21 * 0.42175;
  end

  % Figure size
  figWidth  = colWidth * widthPercent / 100;
  figHeight = figWidth * heightRatio;

  set(fig, ...
    'Units',          'centimeters', ...
    'Position',       [0 0 figWidth figHeight] ...
  );

  set(fig, ...
    'PaperUnits',     'centimeters', ...
    'PaperPosition',  [0 0 figWidth figHeight] ...
  );

  set(ax, ...
    'LooseInset', [0,0,0,0], ...
    'FontSize',   8 ...
  );

  set(get(ax, 'xlabel'), 'FontSize', 8);
  set(get(ax, 'ylabel'), 'FontSize', 8);

  % If a legend exists, unify its font size
  lgd = findobj(fig, 'Type', 'Legend');
  if ~isempty(lgd)
    set(lgd, 'FontSize', 8);
  end

  if exist('fontname')

    if exist('C:/Windows/Fonts/SimSun-TNR.ttf', 'file')
      fontname(gcf, "SimSun-TNR");
    else
      fontname(gcf, "Times New Roman");
    end

  end

end