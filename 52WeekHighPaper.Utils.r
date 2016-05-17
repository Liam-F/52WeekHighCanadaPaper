#
# ToDo:
# ----
#
# * majority of code below will be integrated into SIT.data package
#

#*****************************************************************
# Get data from http://web.tmxmoney.com
#*****************************************************************
#
# info = data.tmxmoney.company('YRI')
#
# filename = 'temp/company.php@qm_symbol=YRI'
# info.saved = data.tmxmoney.company(filename=filename)
#
# http://web.tmxmoney.com/company.php?qm_symbol=NVU.UN
#
data.tmxmoney.company = function(symbol, filename = NULL) {
	if( !is.null(filename) && file.exists(filename) )
		txt = read.file(filename)
	else {
		url = paste0('http://web.tmxmoney.com/company.php?qm_symbol=',symbol)
		txt = get.url(url)	
	}

	temp = extract.table.from.webpage(txt,'Contact Information',has.header=F)
		temp = trim(gsub(':$','',trim(temp)))
	info = temp[,-1]
		rownames(info) = temp[,1]
	info
}

#
# info = data.tmxmoney.price('YRI')
#
# filename = 'temp/quote.php@qm_symbol=AAV'
# info.saved = data.tmxmoney.price(filename=filename)
# t(t(info.saved ))
#
# http://web.tmxmoney.com/quote.php?qm_symbol=NVU.UN
#
data.tmxmoney.price = function(symbol, filename = NULL) {
	if( !is.null(filename) && file.exists(filename) )
		txt = read.file(filename)
	else {
		url = paste0('http://web.tmxmoney.com/quote.php?qm_symbol=',symbol)
		txt = get.url(url)	
	}

	extract.col = function(temp) {
		temp = trim(gsub(':$','',trim(temp)))
		out = temp[,2]
			names(out) = temp[,1]
		out
	}

	info = c()
	temp = extract.table.from.webpage(txt,'Market Cap',has.header=F)
		info = c(info, extract.col(temp))
	temp = extract.table.from.webpage(txt,'Shares Out',has.header=F)
		info = c(info, extract.col(temp))
	temp = extract.table.from.webpage(txt,'VWAP:',has.header=F)
		info = c(info, extract.col(temp))
	temp = extract.table.from.webpage(txt,'Beta:',has.header=F)
		info = c(info, extract.col(temp))
		
	info
}

#*****************************************************************
# Get current universe
#*****************************************************************
data.52week.high.universe = function
(
  force.download = FALSE,
  data.filename = 'tsx.universe.Rdata',
  data.keep.days = 30
)
{
	# if NOT forced to download and file exists and file is less than 30 days old
	if( !force.download && 
		file.exists(data.filename) &&
		as.numeric(Sys.Date() - as.Date(file.mtime(data.filename))) <= data.keep.days
	) {
		load(file=data.filename)
		return(info)
	}	
	
	# S&P/TSX COMPS INDEX (TSEA:TOR)
	universe = data.ft.index.members('TSEA:TOR', data.filename = 'SP_TSX.Rdata')
	info = data.frame(name = universe[,'Name'])
		info$ticker = sapply(universe[,'Symbol'],function(s) spl(s,':')[1])
		info$unit.trust = grepl('\\.UN',info$ticker)

	# we also need to get sector and industry info
	# price
	# http://web.tmxmoney.com/quote.php?qm_symbol=AAV
	#
	# sector industry
	# http://web.tmxmoney.com/company.php?qm_symbol=NVU.UN
	#
	# urls = paste0('http://web.tmxmoney.com/company.php?qm_symbol=',info$ticker)	
	# cat(urls, sep='\n', file='links.txt')
	# wget.exe -e robots=off -U "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:36.0) Gecko/20100101 Firefox/36.0" --no-check-certificate --referer=http://web.tmxmoney.com;auto -i links.txt
	
	temp = matrix('', nr=nrow(info), nc=2)
		rownames(temp) = info$ticker
		colnames(temp) = spl('sector,industry')
	for(ticker in info$ticker) {
		info.saved = data.tmxmoney.company(filename = paste0('temp/company.php@qm_symbol=', ticker))
		temp[ticker,] = c(info.saved['Sector',1], info.saved['Industry',1])
	}
	#temp[nchar(temp[,1])==0,]

	info = cbind(info, temp)


	temp = matrix(NA, nr=nrow(info), nc=8)
		rownames(temp) = info$ticker
		colnames(temp) = spl('nshare,yield,mkcap,pb,pe,eps,price,beta')
		tags = spl('Shares Out.,Yield,Market Cap,P/B Ratio,P/E Ratio,EPS,Prev. Close,Beta')
	for(ticker in info$ticker) {
		info.saved = data.tmxmoney.price(filename = paste0('temp/quote.php@qm_symbol=', ticker))	
		temp[ticker,] = as.numeric(gsub(',','',info.saved[tags]))
	}

	temp = temp[,'nshare',drop=F]
	info = cbind(info, temp)


	# save
	save(info, file=data.filename)
	rownames(info) = info$ticker
	write.table(info, sep=',', quote = F, col.names = NA, file = 'tsx.universe.csv')
	
	info
}
 
#*****************************************************************
# Set implied number of shares given current number of shares and splits
#*****************************************************************
bt.unadjusted.set.nshare = function(data) {
	for(ticker in data$symbolnames) 
		if(any(data[[ticker]]$Split!=0)) {
			#print(ticker)
			x = coredata(data[[ticker]]$Split)
				x[x==0] = 1
			x = rev(cumprod(rev(x)))
				x = ifna(mlag(x, -1),1)
			data[[ticker]]$Share = info[ticker,]$nshare * x		
		} else {
			#print(ticker)
			data[[ticker]]$Share = info[ticker,]$nshare
		}	
}		
# ticker = 'X.TO'
# which(data[[ticker]]$Split!=0)
# data[[ticker]][30:50]
# last(data[[ticker]])


#*****************************************************************
# Get data from http://web.tmxmoney.com
#*****************************************************************
#
# info = data.tmxmoney.company('YRI')
#
# filename = 'temp/company.php@qm_symbol=YRI'
# info.saved = data.tmxmoney.company(filename=filename)
#
# http://web.tmxmoney.com/company.php?qm_symbol=NVU.UN
#
data.quotemedia.price = function(symbol, filename = NULL) {
	if( !is.null(filename) && file.exists(filename) )		
		txt = read.file(filename)
	else {
		url = hist.quotes.url(symbol, '1992-11-01', '2016-05-15', 'quotemedia')
		txt = get.url(url,referer='http://www.quotemedia.com;auto')	
	}
	#out = read.xts(txt)
	library(readr)
	out = read.xts(read_csv(txt,,na=c('','NA','N/A')))
	
	out$Adjusted = out$adjclose
	out
}

