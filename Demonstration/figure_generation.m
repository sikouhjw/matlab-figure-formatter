%% Communication Performance Figure Demo
clear; clc; close all;
rng(2026);

% SNR settings
SNR = 0:20;

% Simulated BER performance
BER_Optimal = 0.16 * exp(-0.55 * SNR);
BER_AMP     = 0.19 * exp(-0.51 * SNR);
BER_OAMP    = 0.21 * exp(-0.47 * SNR);

% Add small simulation fluctuations
BER = [
    BER_Optimal;
    BER_AMP;
    BER_OAMP;
];

BER = BER .* exp(0.08 * randn(size(BER)));

% Algorithm names
names = {
    'Optimal'
    'AMP'
    'OAMP'
};

% Line styles and markers
lineStyles = {'-', '--', '-.'};
markers = {'o', 's', '^', 'd', 'v', '>', '<', 'p'};

% Plot using MATLAB default styles

for ii = 1 : 10

figure;
for k = 1:size(BER, 1)
    semilogy(SNR, BER(k, :), ...
        'LineStyle', lineStyles{k}, ...
        'Marker', markers{k}, ...
        'DisplayName', names{k});
    hold on;
end

xlabel('SNR [dB]');
ylabel('BER');

legend('show');
grid on;
box on;

xlim([0, 20]);
ylim([1e-6, 0.4]);

if ii == 1
  formatFigure(100, 1); % 单栏，单图，宽高比 4:4
  filename = 'figure/example_single_4x4.pdf';
elseif ii == 2
  formatFigure(100, 0.75); % 单栏，单图，宽高比 4:3
  filename = 'figure/example_single_4x3.pdf';
elseif ii == 3
  formatFigure(50, 1); % 单栏，左右双图，宽高比 4:2
  filename = 'figure/example_horizontal2_4x2.pdf';
elseif ii == 4
  formatFigure(50, 1.5); % 单栏，左右双图，宽高比 4:3
  filename = 'figure/example_horizontal2_4x3.pdf';
elseif ii == 5
  formatFigure(100/3, 9/4); % 单栏，左右三图，宽高比 4:3
  filename = 'figure/example_horizontal3_4x3.pdf';
elseif ii == 6
  formatFigure(100, 0.5); % 单栏，上下双图，宽高比 4:4
  filename = 'figure/example_vertical2_4x4.pdf';
elseif ii == 7
  formatFigure(100, 1/3); % 单栏，上下三图，宽高比 4:4
  filename = 'figure/example_vertical3_4x4.pdf';
elseif ii == 8
  formatFigure(100/2, 3/4, "double"); % 双栏，左右双图，宽高比 8:3
  filename = 'figure/example_horizontal2_8x3_double.pdf';
elseif ii == 9
  formatFigure(100/3, 9/8, "double"); % 双栏，左右三图，宽高比 8:3
  filename = 'figure/example_horizontal3_8x3_double.pdf';
elseif ii == 10
  formatFigure(100, 0.75); % 单栏，单图，宽高比 4:3
  filename = 'figure/example_single_4x3_xlabel.pdf';
  xlabel('Iteration, ');
  xlabel_Iteration_formatter;% 覆盖LaTeX公式
end

drawnow;
exportgraphics(gcf, filename, ...
    'ContentType', 'vector', ...
    'BackgroundColor', 'none');

end