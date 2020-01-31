# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

SEARCH_URL = 'https://suumo.jp/jj/chintai/ichiran/FR301FC001/?ar=030&bs=040&pc=30&smk=&po1=12&po2=99&shkr1=03&shkr2=03&shkr3=03&shkr4=03&rn=0005&ek=000500480&ra=013&cb=0.0&ct=9999999&md=02&et=9999999&mb=0&mt=9999999&cn=9999999&fw2='
BASE_URL = 'https://suumo.jp/'

Property = Struct.new('Building', :title, :address, :rent, :url)

def fetch_search_result
  open(SEARCH_URL) do |f|
    Nokogiri::HTML.parse(f.read, nil, f.charset)
  end
end

def parse_search_result(page)
  Enumerator.new do |y|
    page.xpath('//ul[@class="l-cassetteitem"]').each.with_index do |node, i|
      y << Property.new(node.xpath('//div[@class="cassetteitem_content-title"]')[i].inner_text,
                                 node.xpath('//li[@class="cassetteitem_detail-col1"]')[i].inner_text,
                                 node.xpath('//span[@class="cassetteitem_other-emphasis ui-text--bold"]')[i].inner_text,
                                 File.join(BASE_URL, node.xpath('//td[@class="ui-text--midium ui-text--bold"]//a')[i][:href]))
    end
  end
end

def main
  page = fetch_search_result
  parse_search_result(page).each do |property|
    p "住宅名: #{property.title}"
    p "住所: #{property.address}"
    p "家賃: #{property.rent}"
    p "詳細ページ: #{property.url}"
  end
end

main
