require 'json'

class GenSearchTerms
  def initialize(term_json, term_fields, filter_terms)
    @term_json = JSON.parse(File.read(term_json))
    @term_fields = term_fields
    @filter_terms = filter_terms
    @output = Array.new
  end

  def gen_terms
    @filter_terms.each do |filter_term|
      @term_json.each do |item|
        @term_fields.each do |field|
          @output.push({"Search Term" => '"'+item[field]+'" '+filter_term})
        end
      end
    end

    return JSON.pretty_generate(@output)
  end
end

g = GenSearchTerms.new("../data/top_secret_america_companies.json", ["company_name", "short_name"], ["SIGINT", "HUMINT", "security", "analyst", "intelligence"])
puts g.gen_terms
