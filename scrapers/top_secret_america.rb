require 'json'
require 'open-uri'
require 'nokogiri'
require 'pry'

class TopSecretAmerica
  def initialize
    @url = "http://projects.washingtonpost.com/top-secret-america/companies/num-locations/"
    @output = Array.new
  end

  # Parse table for page
  def parse_table(page_link)
    html = Nokogiri::HTML(open(page_link))
    html.css("tr").each do |row|
      if !row.css("td").empty?
        companyhash = Hash.new
        companyhash[:company_name] = row.css("td")[0].text
        companyhash[:info_link] = row.css("td")[0].css("a").first['href']
        companyhash[:location] = row.css("td")[1].text
        companyhash[:year_founded] = row.css("td")[2].text
        companyhash[:num_employees] = row.css("td")[3].text
        companyhash[:revenue] = row.css("td")[4].text
        companyhash[:num_locations] = row.css("td")[5].text
        companyhash[:num_gov_clients] = row.css("td")[6].text
        companyhash[:short_name] = companyhash[:company_name].split(",").first
        @output.push(companyhash)
      end
    end
  end

  # Get all pages
  def get_all_pages
    (1..39).each do |page|
      parse_table(@url+page.to_s)
    end
  end

  # Print output
  def get_output
    JSON.pretty_generate(@output)
  end
end
t= TopSecretAmerica.new
t.get_all_pages
puts t.get_output
