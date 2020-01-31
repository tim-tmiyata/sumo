# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

search_url = 'https://suumo.jp/jj/chintai/ichiran/FR301FC001/?ar=030&bs=040&pc=30&smk=&po1=12&po2=99&shkr1=03&shkr2=03&shkr3=03&shkr4=03&rn=0005&ek=000500480&ra=013&cb=0.0&ct=9999999&md=02&et=9999999&mb=0&mt=9999999&cn=9999999&fw2='
base_url = 'https://suumo.jp/'

charset = nil

html = open(search_url) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

cont = 0
doc.xpath('//ul[@class="l-cassetteitem"]').each do |node|
  p '住宅名:' + node.xpath('//div[@class="cassetteitem_content-title"]')[cont].inner_text
  p '住所:' + node.xpath('//li[@class="cassetteitem_detail-col1"]')[cont].inner_text
  p '家賃:' + node.xpath('//span[@class="cassetteitem_other-emphasis ui-text--bold"]')[cont].inner_text
  p '詳細ページ:' + File.join(base_url, node.xpath('//td[@class="ui-text--midium ui-text--bold"]//a')[cont][:href])
  cont += 1
end
