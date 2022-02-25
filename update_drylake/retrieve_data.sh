# To find the curl which will format the right http POST:
#   1) Enable debugger in Firefox (F12)
#   2) Go to: https://wcc.sc.egov.usda.gov/nwcc/site?sitenum=457 and select a download (all sensors, hourly, current water year or historic)
#   3) After the download starts, check in the debugger under the tab "Network", the POST command. Right click --> copy --> Copy as Curl

# Historic water years
for yr in 2020 2021
do
	current=$(echo ${yr} | mawk '')

	curl 'https://wcc.sc.egov.usda.gov/nwcc/view' -X POST -H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: https://wcc.sc.egov.usda.gov' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://wcc.sc.egov.usda.gov/nwcc/site?sitenum=457' --data-raw 'intervalType=+View+Historic+&report=ALL&timeseries=Hourly&format=copy&sitenum=457&interval=WATERYEAR&year='${yr}'&month=WY&userEmail=' > ${yr}.csv
done

# Current water year
let yr=${yr}+1
curl 'https://wcc.sc.egov.usda.gov/nwcc/view' -X POST -H 'Origin: https://wcc.sc.egov.usda.gov' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://wcc.sc.egov.usda.gov/nwcc/site?sitenum=457' --data-raw 'intervalType=+View+Current+&report=ALL&timeseries=Hourly&format=copy&sitenum=457&interval=WATERYEAR&year='${yr}'&month=WY&userEmail=' > ${yr}.csv
