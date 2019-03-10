require "test_helper"

class RiddlerTest < Minitest::Test
  make_my_diffs_pretty!

  def test_that_it_has_a_version_number
    refute_nil ::Riddler::VERSION
  end

  def test_cases
    Dir["test/cases/*.yml"].each do |file|
      test_case = YAML.safe_load File.read file
      run_test_case test_case
    end
  end

  def run_test_case test_case
      case_name = test_case["name"]
      definition = test_case["definition"]

      test_case["tests"].each do |test_hash|
        full_name = "#{case_name}_#{test_hash["name"]}"

        result = ::Riddler.render definition, test_hash["context"]
        result&.transform_keys! { |k| k.to_s }

        assert_equal_hash test_hash["result"], result,
          "Hashdiff not equal #{case_name}_#{test_hash["name"]}"
      rescue ::Minitest::Assertion => e
        self.failures << e
      end
  end

  def assert_equal_hash expected, actual, message = "Hashes are not equal: "
    diff = ::HashDiff.diff expected, actual

    assert diff.empty?, -> {
      message_lines = [message, expected.to_s, actual.to_s]
      message_lines += diff.map { |arr| arr.join " " }

      message_lines.join "\n"
    }
  end
end
