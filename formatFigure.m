function formatFigure(widthPercent, heightRatio)

  if nargin < 1 || isempty(widthPercent)
    widthPercent = 80;
  end
  if nargin < 2 || isempty(heightRatio)
    heightRatio = 0.75;
  end

  fig = gcf;
  ax  = gca;

  box(ax, 'on');

  % One-column width in centimeters
  colWidth = 21 * 0.42175;

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
    fontname(gcf, "Times New Roman");
  end

end