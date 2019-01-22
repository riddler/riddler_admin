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
      yaml_string = yaml

      if ::RiddlerAdmin.configuration.encrypt_preview_contexts? &&
        encrypted_yaml.present?

        yaml_string = decrypt encrypted_yaml
      end

      YAML.safe_load yaml_string
    end

    def refresh_data input_headers: {}
      use_case_headers = merge_headers input_headers

      use_case = ::Riddler::UseCases::PreviewContext.new \
        params: params_hash,
        headers: use_case_headers

      hash = use_case.process
      update_data hash
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

    def update_data hash
      yaml = hash.to_yaml

      if ::RiddlerAdmin.configuration.encrypt_preview_contexts?
        encrypted_yaml = encrypt yaml
        update_attribute :encrypted_yaml, encrypted_yaml
      else
        update_attribute :yaml, yaml
      end
    end

    private

    def encrypt plaintext
      ::RiddlerAdmin.encrypt plaintext,
        key: ::RiddlerAdmin.configuration.preview_context_transit_key
    end

    def decrypt ciphertext
      ::RiddlerAdmin.decrypt ciphertext,
        key: ::RiddlerAdmin.configuration.preview_context_transit_key
    end
  end
end
