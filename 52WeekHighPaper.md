---
layout: post
title: 52 Week High Canada Paper
---
To install [Systematic Investor Toolbox (SIT)](https://github.com/systematicinvestor/SIT) please visit [About](/about) page.




Following is a replication based on the [The 52-Week High and Momentum Investing](http://www.bauer.uh.edu/tgeorge/papers/gh4-paper.pdf)
paper applied to Canadian Markets.





The Equal Weighted(ew) and Market Cap Weighted(mcw) benchmarks:


![plot of chunk plot-3](/public/images/52WeekHighPaper/plot-3-1.png) 

|           |ew                |mcw               |
|:----------|:-----------------|:-----------------|
|Period     |Jan1998 - May2016 |Jan1998 - May2016 |
|Cagr       |17.84             |10.21             |
|Sharpe     |1.25              |0.69              |
|DVR        |1.13              |0.66              |
|Volatility |13.86             |15.77             |
|MaxDD      |-44.31            |-43.56            |
|AvgDD      |-1.63             |-2.2              |
|VaR        |-1.3              |-1.53             |
|CVaR       |-2.14             |-2.41             |
|Exposure   |99.53             |99.53             |
    


Performance Across various sectors:


![plot of chunk plot-4](/public/images/52WeekHighPaper/plot-4-1.png) 

|           |Energy            |Industrials       |Basic Materials   |Financial Services |Utilities         |Consumer Defensive |Real Estate       |Consumer Cyclical |Communication Services |Technology        |Healthcare        |
|:----------|:-----------------|:-----------------|:-----------------|:------------------|:-----------------|:------------------|:-----------------|:-----------------|:----------------------|:-----------------|:-----------------|
|Period     |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016  |Jan1998 - May2016 |Jan1998 - May2016  |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016      |Jan1998 - May2016 |Jan1998 - May2016 |
|Cagr       |12.03             |12.78             |7.09              |11.8               |8.4               |4.84               |14.12             |8.05              |6.9                    |10.46             |8.07              |
|Sharpe     |0.75              |0.87              |0.44              |0.63               |0.53              |0.32               |0.79              |0.47              |0.4                    |0.58              |0.54              |
|DVR        |0.69              |0.71              |0.36              |0.6                |0.49              |0.26               |0.75              |0.39              |0.23                   |0.5               |0.42              |
|Volatility |17.2              |15.2              |20.12             |21.39              |18.67             |23.05              |18.87             |21.65             |22.98                  |21.14             |16.9              |
|MaxDD      |-41.08            |-41.29            |-50.87            |-44.72             |-37.91            |-57.22             |-49.31            |-60.35            |-62.83                 |-53.83            |-49.85            |
|AvgDD      |-2.58             |-1.98             |-2.96             |-3.19              |-2.72             |-4.69              |-2.23             |-3.54             |-4.86                  |-3.31             |-2.77             |
|VaR        |-1.61             |-1.45             |-1.95             |-2.01              |-1.71             |-2.21              |-1.82             |-2                |-2.23                  |-1.97             |-1.65             |
|CVaR       |-2.58             |-2.21             |-2.94             |-3.15              |-2.75             |-3.32              |-2.79             |-3.28             |-3.28                  |-3.14             |-2.42             |
|Exposure   |99.53             |99.53             |99.53             |99.53              |99.53             |99.53              |99.53             |99.53             |99.53                  |99.53             |99.53             |
    


Performance of Selected Models:


![plot of chunk plot-5](/public/images/52WeekHighPaper/plot-5-1.png) 

|           |ew                |mcw               |JT.6.1.top        |JT.6.6.top        |JT.6.1.bot        |JT.6.6.bot        |JT.6.1.mid        |JT.6.6.mid        |JT.6.1.spread     |JT.6.6.spread     |high52w.1.top     |high52w.6.top     |high52w.1.bot     |high52w.6.bot     |high52w.1.mid     |high52w.6.mid     |high52w.1.spread  |high52w.6.spread  |MG.6.1.top        |MG.6.6.top        |MG.6.1.bot        |MG.6.6.bot        |MG.6.1.mid        |MG.6.6.mid        |MG.6.1.spread     |MG.6.6.spread     |
|:----------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|
|Period     |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |Jan1998 - May2016 |
|Cagr       |17.84             |10.21             |23.35             |22.44             |15.6              |17.21             |13.42             |14.16             |4.28              |2.91              |15.91             |15.59             |18.66             |19.66             |16.19             |15.15             |-5.88             |-6.42             |13.86             |14                |12.05             |12.58             |12.1              |12.68             |1.23              |1.08              |
|Sharpe     |1.25              |0.69              |1.44              |1.4               |0.83              |1                 |1.04              |1.15              |0.32              |0.28              |1.35              |1.29              |0.9               |1                 |1.19              |1.15              |-0.23             |-0.34             |1.2               |1.24              |0.98              |1.12              |1.05              |1.1               |0.2               |0.22              |
|DVR        |1.13              |0.66              |1.23              |1.24              |0.75              |0.89              |0.94              |1.05              |0.14              |0.05              |1.16              |1.16              |0.79              |0.88              |1.09              |1.04              |-0.19             |-0.28             |1.04              |1.08              |0.85              |0.98              |0.95              |0.98              |0.01              |0.05              |
|Volatility |13.86             |15.77             |15.38             |15.3              |19.83             |17.43             |12.96             |12.12             |18.03             |13.4              |11.39             |11.71             |21.56             |19.86             |13.34             |12.93             |18.54             |15.69             |11.33             |11.08             |12.44             |11.15             |11.44             |11.43             |7.86              |5.55              |
|MaxDD      |-44.31            |-43.56            |-40.81            |-45.69            |-56.51            |-50.24            |-43.56            |-41.54            |-51.94            |-54.32            |-36.73            |-40.91            |-55.3             |-50.07            |-47.74            |-47.19            |-80.95            |-77.7             |-38.97            |-38.98            |-38.64            |-33.07            |-37.39            |-38.43            |-33.25            |-28.59            |
|AvgDD      |-1.63             |-2.2              |-2.14             |-1.85             |-2.64             |-2.55             |-1.4              |-1.33             |-5.87             |-2.92             |-1.47             |-1.32             |-3.08             |-2.95             |-1.38             |-1.43             |-28.52            |-26.51            |-1.33             |-1.21             |-1.53             |-1.38             |-1.28             |-1.23             |-1.91             |-1.55             |
|VaR        |-1.3              |-1.53             |-1.47             |-1.46             |-1.86             |-1.65             |-1.22             |-1.14             |-1.73             |-1.33             |-1.1              |-1.07             |-2.1              |-1.95             |-1.23             |-1.22             |-1.9              |-1.63             |-1.1              |-1.07             |-1.16             |-1.09             |-1.09             |-1.09             |-0.75             |-0.57             |
|CVaR       |-2.14             |-2.41             |-2.33             |-2.33             |-3.01             |-2.56             |-2.02             |-1.88             |-2.8              |-2.09             |-1.78             |-1.84             |-3.18             |-2.91             |-2.04             |-2.03             |-2.9              |-2.5              |-1.76             |-1.78             |-1.93             |-1.73             |-1.79             |-1.8              |-1.13             |-0.82             |
|Exposure   |99.53             |99.53             |96.74             |96.74             |96.74             |96.74             |96.74             |96.74             |96.74             |96.74             |94.44             |94.44             |94.44             |94.44             |94.44             |94.44             |94.44             |94.44             |96.74             |96.74             |96.74             |96.74             |96.74             |96.74             |96.74             |96.74             |
    


Summary CAGR Performance table:



|    ew|   mcw|
|-----:|-----:|
| 17.84| 10.21|
    




|             |   Top| Middle| Bottom| Spread|
|:------------|-----:|------:|------:|------:|
|JT.6.1       | 23.35|  13.42|  15.60|   4.28|
|JT.6.6       | 22.44|  14.16|  17.21|   2.91|
|High52w.6.1. | 15.91|  16.19|  18.66|  -5.88|
|high52w.6.6. | 15.59|  15.15|  19.66|  -6.42|
|MG.6.1       | 13.86|  12.10|  12.05|   1.23|
|MG.6.6       | 14.00|  12.68|  12.58|   1.08|
    


References:
----

* [The 52-Week High and Momentum Investing by T. J. GEORGE, C. HWANG (2004)](http://www.bauer.uh.edu/tgeorge/papers/gh4-paper.pdf)
  THE JOURNAL OF FINANCE VOL. LIX, NO. 5 OCTOBER (2004).

* [Is the 52-Week High Momentum Strategy Profitable Outside the U.S.?  Marshall, B.R. & Hodges, R.M. (2005)](http://econfin.massey.ac.nz/school/bmarshall.php)
  Applied Financial Economics, Vol 15(18), pp. 1259-1268.

* [An Investigation into the Strength of the 52-week high Momentum Strategy in the United States (2008)](http://mro.massey.ac.nz/xmlui/bitstream/handle/10179/891/02whole.pdf?sequence=1&isAllowed=y)

* [New empirical evidence on the investment success of momentum strategies based on relative stock prices Susana Yu (2011)](https://static1.squarespace.com/static/50ccf457e4b035e3532ca7c5/t/520af7a1e4b00fb5187a2d1c/1376450465247/SuccessOfMomentumStrategies.pdf)

* [52-week High Momentum Strategy: Evidence from Iranian Stock Markets (2013)](http://www.scienpress.com/Upload/JFIA/Vol%202_3_10.pdf)
  Journal of Finance and Investment Analysis, vol. 2, no. 3, 2013,


