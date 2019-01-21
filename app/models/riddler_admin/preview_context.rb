module RiddlerAdmin
  class PreviewContext < ApplicationRecord
    MODEL_KEY = "pctx".freeze
    ID_LENGTH = 5 # 916_132_832 per second

    validates :title, presence: true, uniqueness: true

    def self.convert_headers input_headers
      original_headers = input_headers.to_h.
        select{|k,v| k.starts_with? "HTTP_"}.
        map{|k,v| [k.downcase.gsub(/^http_/, ""), v] }

      Hash[original_headers]
    end

    def data
      YAML.safe_load yaml
    end

    def refresh_data input_headers: {}
      use_case_headers = merge_headers input_headers

      use_case = ::Riddler::UseCases::PreviewContext.new \
        params: params_hash,
        headers: use_case_headers

      hash = use_case.process
      update_attribute :yaml, hash.to_yaml
    end

    def params_hash
      params_array = (params || "").split("\n").map do |line|
        line.split(":").map &:strip
      end
      Hash[params_array]
    end

    def headers_hash
      headers_array = (headers || "").split("\n").map do |line|
        key, val = *line.split(":").map(&:strip)
        [key.downcase.gsub(/[^0-9a-z]/i, "_"), val]
      end
      Hash[headers_array]
    end

    def merge_headers input_headers
      request_headers = self.class.convert_headers input_headers
      request_headers.merge headers_hash
    end
  end
end
