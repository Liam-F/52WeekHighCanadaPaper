#' ---
#' layout: post
#' title: 52 Week High Canada Paper
#' ---
#'
#' Following is a replication based on the [The 52-Week High and Momentum Investing](http://www.bauer.uh.edu/tgeorge/papers/gh4-paper.pdf)
#' paper applied to Canadian Markets.
#'
#' The
#' 
#' First an Artificial Example demonstrates the impact of taxes by exploring the difference between
#' long-term and short-term capital gain taxes.
#' 
#' Suppose we have two identical assets, two clones of SPY for this example. 
#' Consider an annually re-balanced strategy that does 100% turnover by moving from one SPY clone to another.
#'
#' The OneYear strategy does the re-balance at the end of the year, hence it is subject to the short-term capital gain tax.
#' The OneYearOneDay strategy does re-balance at one year plus one day, hence it is subject to the long-term capital gain tax.
#'


#+ echo=T
#*****************************************************************
# Main
#*****************************************************************
library(SIT)
library(quantmod)
library(data.table)
# if using data.table
last = function(x,...) xts::last(x,...)
#file.mtime = function(f) file.info(f)$mtime

source('52WeekHighPaper.Utils.r',T)



data.filename = 'tsx.btdata.Rdata'

if(!file.exists(data.filename)) {
	# get current universe
	info = data.52week.high.universe()		 


	# urls = hist.quotes.url(paste0(info$ticker,":CA"), '1992-11-01', '2016-05-15', 'quotemedia')
	# cat(urls, sep='\n', file='links.txt')
	# wget.exe -e robots=off -U "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:36.0) Gecko/20100101 Firefox/36.0" --no-check-certificate --referer=http://www.quotemedia.com;auto -i links.txt
	# 
	# folder = paste(getwd(), 'temp', '', sep='/')
	# download.web.data(urls, info$ticker, folder, list(
	#			download.agent = 'aria',
	#			refer = 'http://www.quotemedia.com;auto',
	#			clean.folder.before.download = T)
	#		)
	# get prices
	data = env()
	for(ticker in info$ticker) {
		#filename = paste0('temp/getHistoryDownload.csv@webmasterId=501&symbol=', ticker,'%3ACA&startMonth=10&startDay=01&startYear=1992&endMonth=04&endDay=15&endYear=2016&isRanged=true')	
		filename = paste0('temp/', ticker)	
		data[[ticker]] = data.quotemedia.price(filename = filename)
	}

	#CIG
	#2015-05-27,45.00,50.00,45.00,47.50,700,47.444,316566.55%,47.4588,32750.00,4

	# CIG history is bad; get it from Yahoo
	filename = 'temp/CIG.TO'
	if(!file.exists(filename)) 
		write.file(get.url(hist.quotes.url('CIG.TO', '1992-11-01', '2016-05-15', 'yahoo'),referer='http://ichart.finance.yahoo.com;auto'), file=filename)
	out = read.xts(filename)
		out$Adjusted = out$Adj_Close
	data$CIG = out


	for(ticker in ls(data)) 
		data[[ticker]] = make.stock.xts(data[[ticker]])
	 
	save(info, data, file = data.filename)
}
load(file = data.filename) 






clean.data.filename = 'tsx.btdata.clean.Rdata'

if(!file.exists(clean.data.filename)) {

	for(i in 1:2) {
		cat(i, 'itteration of data cleaning', '\n')
		data.clean(data, min.ratio=1.6, min.obs=0*252) 
	}

	# examine effect of cleaning
	#temp = env()
	#temp$A = make.stock.xts(data$RY)
	#data.clean(temp, min.ratio=1.6, min.obs=0*252) 
	#layout(1:2)
	#plota(Ad(temp$A),type='l')
	#plota(Cl(temp$A),type='l')

	data.copy = env(data)

	# compute implied dividends and splits from adjusted quotes
	bt.unadjusted.add.div.split(data.copy, infer.div.split.from.adjusted=T)	

	# set implied number of shares given current number of shares and splits
	bt.unadjusted.set.nshare(data.copy)

		
		
	for(i in data$symbolnames) data[[i]] = adjustOHLC(data[[i]], use.Adjusted=T)
		
	# we could have used data$X$Adjusted * info['X','nshare']
	# but it is not accurate since Adjusted includes both dividends and splits
	for(ticker in data$symbolnames)
		data[[ticker]]$MCap = data.copy[[ticker]]$Share * data.copy[[ticker]]$Close

			
			
	bt.prep(data, align='keep.all', fill.gaps = T)

	# start in 1998 since we have 100 companies in universe
	# which(count(t(data$prices)) > 100)[1]	
	data = bt.prep.trim(data, '1998::')

	save(info, data, file = clean.data.filename)
}

load(file = clean.data.filename)



#*****************************************************************
# Setup
#*****************************************************************
data$universe = ifna(data$prices > 0, F)


prices = data$prices * data$universe
	n = ncol(prices)
	nperiods = nrow(prices)

# form signal at the month end using closing prices; execute next day at the open
calc.offset = 0
do.lag = 2

open = bt.apply(data, function(x) ifna.prev(x[,'Open']))
	# some open prices are 0 - strange; replace with close
	open = iif(open == 0, prices, open)
		
	
mcap = bt.apply(data, function(x) ifna.prev(x[,'MCap']))
	mcap = ifna(mcap, 0)

period.ends = date.ends(prices,'months') + calc.offset
	period.ends = period.ends[(period.ends > 0) & (period.ends <= nperiods)]
	nperiod.ends = len(period.ends)


#*****************************************************************
# Benchmark(s)
#*****************************************************************
obj = lst(period.ends, weights = list())


if( F ) {
# trade at close
data$weight[] = NA
	data$execution.price[] = NA
	data$weight[period.ends,] =  ntop(prices[period.ends,], n)	
models$ew.c = bt.run.share.ex(data, clean.signal=F, silent=F,trade.summary=T)

data$weight[] = NA
	data$execution.price[] = NA
	data$weight[period.ends,] =  (mcap / rowSums(mcap))[period.ends,]
models$mcw.c = bt.run.share.ex(data, clean.signal=F, silent=F)
}


obj$weights$ew = ntop(prices[period.ends,], n)

obj$weights$mcw = (mcap / rowSums(mcap))[period.ends,]


# Evaluate given strategies; should be run in parallel to save time
create.models = function(obj, data, open, models = list()) {
	for(n in  names(obj$weights)) {
		data$weight[] = NA
			data$execution.price = open
			data$weight[period.ends,] = obj$weights[[n]]
		models[[n]] = bt.run.share.ex(data, clean.signal=F, silent=T, do.lag=do.lag, trade.summary=F)
	}
	models
}

#models = create.models(obj, data, open)





# do back-test for each sector; there are not enough members in each industry. i.e. sort(tapply(rep(1,nrow(info)),info$sector,sum))
models.sector = list()
sectors = unique(info$sector)
nsectors = len(sectors)

for(sector in sectors) {
	index = info$sector==sector
	data$weight[] = NA
		data$execution.price = open
		data$weight[period.ends, index] =  (mcap[,index] / rowSums(mcap[,index]))[period.ends,]
	models.sector[[sector]] = bt.run.share.ex(data, clean.signal=F, silent=T, do.lag=do.lag)
}

sector.prices = prices[,1:len(sectors)]
	colnames(sector.prices) = sectors
for(sector in sectors)
	sector.prices[,sector] = models.sector[[sector]]$equity

#plota.matplot(sector.prices)


	
	
#*****************************************************************
# Helper functions
#*****************************************************************
# compute quantiles
position.score.quantile = function(position.score, n.quantiles, min.n = n.quantiles / 2) {
	position.score = coredata(position.score)
		nposition.score = nrow(position.score)	
	quantiles = position.score * NA			
	
	for( i in 1:nposition.score ) {
		score = position.score[i,]
		ncount = count(score)
		if( ncount > min.n )
			quantiles[i,] = ceiling(n.quantiles * rank(score, na.last = 'keep','first') / ncount)
		else 
			quantiles[i,] = NA	
	}
	quantiles
}

# hold position for given number of periods
hold.position = function(signal, nhold=1) {
	if( nhold == 1 ) return(signal)
	
	signal.n = signal
	for(i in 1:(nhold-1))
		signal.n = signal.n + mlag(signal, i)
	signal.n = signal.n / nhold
	signal.n
}

#*****************************************************************
# Strategy
#*****************************************************************
#
# JT(N,K): N months formation period and K months holding period
# will simulate K overlapping strategies with 1/K allocation
#		

# N months formation period: compute 6 month price change
position.score = bt.apply.matrix.ex(prices, function(x) x/mlag(x,6), period.ends=period.ends) 

# bottom 30%
#rowSums(quantiles <= 3, na.rm=T)
# top 30%
#rowSums(quantiles > 7, na.rm=T)

# split into 10 quantiles
quantiles = position.score.quantile(position.score[period.ends,], 10)

# top 30%
signal.top = ntop(quantiles > 7, n)	

obj$weights$JT.6.1.top = signal.top

obj$weights$JT.6.6.top = hold.position(signal.top, 6)


# rowSums(models$top30.6$share[period.ends,]>0)
# rowSums(models$top30$share[period.ends,]>0)


# bottom 30%
signal.bot = ntop(quantiles <= 3, n)	

obj$weights$JT.6.1.bot = signal.bot

obj$weights$JT.6.6.bot = hold.position(signal.bot, 6)


# middle 40%
signal.mid = ntop(quantiles > 3 & quantiles <= 7, n)	

obj$weights$JT.6.1.mid = signal.mid

obj$weights$JT.6.6.mid = hold.position(signal.mid, 6)


# spread
obj$weights$JT.6.1.spread = signal.top - signal.bot

obj$weights$JT.6.6.spread = hold.position(signal.top, 6) - hold.position(signal.bot, 6)




#*****************************************************************
# Strategy
#*****************************************************************
#
# 52 week high
#		

# 52 week high
high52w = bt.apply.matrix(prices, runMax, 252)
	position.score = prices / high52w

# split into 10 quantiles
quantiles = position.score.quantile(position.score[period.ends,], 10)

# top 30%
signal.top = ntop(quantiles > 7, n)	

obj$weights$high52w.1.top = signal.top

obj$weights$high52w.6.top = hold.position(signal.top, 6)

# bottom 30%
signal.bot = ntop(quantiles <= 3, n)	

obj$weights$high52w.1.bot = signal.bot

obj$weights$high52w.6.bot = hold.position(signal.bot, 6)

# middle 40%
signal.mid = ntop(quantiles > 3 & quantiles <= 7, n)	

obj$weights$high52w.1.mid = signal.mid

obj$weights$high52w.6.mid = hold.position(signal.mid, 6)


# spread
obj$weights$high52w.1.spread = signal.top - signal.bot

obj$weights$high52w.6.spread = hold.position(signal.top, 6) - hold.position(signal.bot, 6)


#*****************************************************************
# Strategy
#*****************************************************************
#
# MG industrial momentum ( N,K): N months formation period and K months holding period
# will simulate K overlapping strategies with 1/K allocation
#		

# N months formation period: compute 6 month price change
position.score = bt.apply.matrix.ex(sector.prices, function(x) x/mlag(x,6), period.ends=period.ends) 


# split into 11 quantiles, since there are 11 sectors
sector.quantiles = position.score.quantile(position.score[period.ends,], nsectors)

# map sector quantiles back to holdings
quantiles[] = 0
for(sector in sectors)
	quantiles = quantiles + sector.quantiles[,sector] * rep.row(info$sector==sector, nperiod.ends)

# each period allocate to sectors 1,2,3 and 9,10,11 and middle 4,5,6,7,8

# top 30%
signal.top = ntop(quantiles > 8, n)	

obj$weights$MG.6.1.top = signal.top

obj$weights$MG.6.6.top = hold.position(signal.top, 6)


# bottom 30%
signal.bot = ntop(quantiles <= 3, n)	

obj$weights$MG.6.1.bot = signal.bot

obj$weights$MG.6.6.bot = hold.position(signal.bot, 6)

# middle 40%
signal.mid = ntop(quantiles > 3 & quantiles <= 8, n)	

obj$weights$MG.6.1.mid = signal.mid

obj$weights$MG.6.6.mid = hold.position(signal.mid, 6)


# spread
obj$weights$MG.6.1.spread = signal.top - signal.bot

obj$weights$MG.6.6.spread = hold.position(signal.top, 6) - hold.position(signal.bot, 6)


#*****************************************************************
# Report
#*****************************************************************
models = create.models(obj, data, open)
	
stats = plotbt.strategy.sidebyside(models, make.plot=F, return.table=T)
	
cagr = sapply(stats['Cagr',],as.numeric)	
	

print(cagr[spl('ew,mcw')])

temp = rbind(
	JT.6.1=cagr[spl('JT.6.1.top,JT.6.1.mid,JT.6.1.bot,JT.6.1.spread')],
	JT.6.6=cagr[spl('JT.6.6.top,JT.6.6.mid,JT.6.6.bot,JT.6.6.spread')],
	High52w.6.1.=cagr[spl('high52w.1.top,high52w.1.mid,high52w.1.bot,high52w.1.spread')],
	high52w.6.6.=cagr[spl('high52w.6.top,high52w.6.mid,high52w.6.bot,high52w.6.spread')],
	MG.6.1=cagr[spl('MG.6.1.top,MG.6.1.mid,MG.6.1.bot,MG.6.1.spread')],
	MG.6.6=cagr[spl('MG.6.6.top,MG.6.6.mid,MG.6.6.bot,MG.6.6.spread')]
)
colnames(temp) = spl('Top,Middle,Bottom,Spread')

print(temp)

	







#'
#' References:
#' ----
#'
#' * [The 52-Week High and Momentum Investing by T. J. GEORGE, C. HWANG (2004)](http://www.bauer.uh.edu/tgeorge/papers/gh4-paper.pdf)
#'   THE JOURNAL OF FINANCE VOL. LIX, NO. 5 OCTOBER (2004).
#'
#' * [Is the 52-Week High Momentum Strategy Profitable Outside the U.S.?  Marshall, B.R. & Hodges, R.M. (2005)](http://econfin.massey.ac.nz/school/bmarshall.php)
#'   Applied Financial Economics, Vol 15(18), pp. 1259-1268.
#' 
#' * [An Investigation into the Strength of the 52-week high Momentum Strategy in the United States (2008)](http://mro.massey.ac.nz/xmlui/bitstream/handle/10179/891/02whole.pdf?sequence=1&isAllowed=y)
#'
#' * [New empirical evidence on the investment success of momentum strategies based on relative stock prices Susana Yu (2011)](https://static1.squarespace.com/static/50ccf457e4b035e3532ca7c5/t/520af7a1e4b00fb5187a2d1c/1376450465247/SuccessOfMomentumStrategies.pdf)
#'
#' * [52-week High Momentum Strategy: Evidence from Iranian Stock Markets (2013)](http://www.scienpress.com/Upload/JFIA/Vol%202_3_10.pdf)
#'   Journal of Finance and Investment Analysis, vol. 2, no. 3, 2013,
#'



