# MATLAB 版“格式刷”

# 引言
1. 在论文撰写时，图片的绘制是一个重要的环节，而绘制“尺寸合适”“字号合适”的图片往往是较为繁琐的，因此本文提供一套适用于 Matlab 图片的“代码控制”方法，也可称为“格式刷”。

# 困难与解决思路

1. 在绘制图片时，调制图片尺寸是较为困难的，尤其是适用鼠标控制窗口大小，具有不确定性，而Matlab 提供了一定的接口可以控制窗口大小[^1]，同时前人也进行了一定的摸索可以借鉴[^2]。

1. Matlab 相关接口如下：
    - `Position(PaperPosition)` 接口：控制图片的宽高；
      - `Position` 控制屏幕显示时的尺寸；
      - `PaperPosition` 控制打印、导出时的尺寸。
    - `Units(PaperUnits)` 接口：控制尺寸的单位，可以设置为常见的单位，如厘米（cm）；
      - 同上。
    - `LooseInset` 接口[^3]：控制图片本体与图片窗口边缘的距离；
    - `FontSize` 接口：控制图片中所有文本的字号。
      - `xlabel(ylabel)` 的文本字号需要通过 `set(get(ax,'xlabel'),FontSize',8);` 设置。
      - 图例的字号通过 `legend('FontSize',8);` 设置。

# IEEE 格式适配

1. `IEEEtran.cls`[^4] 的 `\textwidth` 长度为 `43pc`，单栏的 `\linewidth` 为 `21pc`，因此图片应根据单双栏宽度去设置尺寸。
    - `1pc=0.421751764217518cm`[^5]。因此单栏图片宽度不超过 `21*0.42175cm`，双栏图片宽度不超过 `43*0.42175cm`。
    - 由于图片尺寸已设置，因此在 LaTeX 中直接插入图片 `\includegraphics{file.eps}` 即可；
      - 避免在 LaTeX 中缩放导致字体不一致或线宽失真。

# 代码执行

1. 通过上述接口，给出一个适用于 IEEE 投稿的“格式刷”命令：
    ```matlab
    formatFigure(widthPercent, heightRatio)
    ```
    该命令产生如下行为
    - 将图片的宽度和高度分别设置为：`21*0.42175cm*widthPercent/100` 和 `宽度*heightRatio`；
      - 如果不填参数，默认值分别为 `80(80%)` 和 `0.75`；
    - 所有文本（含图例、横纵标签）设置为 `8pt`；
      - `8pt` 为 IEEE 推荐单栏图常用字号。

1. 示例用法：
    ```matlab
    plot(x,y);
    xlabel('Iteration, \it t');hold on;
    ylabel('MSE [dB]');
    legend('Location', 'northeast');
    formatFigure;
    ```

1. 实现不同样式的输入参数集合：
    - 双子图：
      - 肩并肩：`formatFigure(50,1)`；
      - 上并下：`formatFigure(100,0.5)`。
    - 三子图：
      - 肩并肩：`formatFigure(100/3,3/2)`；
      - 上并下：`formatFigure(100,1/3)`。

# 其它
1. 当某些文本字号小于 `8pt` 时（在有限篇幅内调整），直接另存为 `eps` 文件会导致导出的文本为 `8pt` 而不是想要的字号，此时可以通过
    ```matlab
    print(gcf, '-depsc', 'file.eps');
    ```
    来输出 eps 文件。


[1]: https://ww2.mathworks.cn/help/matlab/ref/matlab.ui.figure.html
[2]: https://ww2.mathworks.cn/matlabcentral/answers/173629-how-to-change-figure-size
[3]: https://undocumentedmatlab.com/articles/axes-looseinset-property
[4]: https://mirrors.ctan.org/macros/latex/contrib/IEEEtran/IEEEtran.cls
[5]: https://medemanabu.net/latex/length-units/