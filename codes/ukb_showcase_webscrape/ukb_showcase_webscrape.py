import requests
from bs4 import BeautifulSoup
from pprint import pprint

#TODO: remove hard-coded parts and make them into variables

id = str(220)

url = 'https://biobank.ctsu.ox.ac.uk/showcase/label.cgi?id=' + id
data = requests.get(url)

html = BeautifulSoup(data.text, 'html.parser')

outfile = open("ukb_category_" + id + "_fields.csv", "w")

for tbl in html.find_all("table", recursive=True):
    if (tbl.parent.find('h2').text != "251 Data-Fields"):
        continue
    headers = [th.text.strip() for th in tbl.find_all('th')]
    print(",".join(headers), file=outfile)
    for row in tbl.find_all('tr')[1:]:  
        cells = [td.text.strip() for td in row.find_all('td')]
        print(",".join(cells), file=outfile)
