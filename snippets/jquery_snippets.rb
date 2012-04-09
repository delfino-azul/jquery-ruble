require 'ruble'
require(File::expand_path('../lib/jquery_ruble_utils.rb', File::dirname(__FILE__)))

with_defaults :scope => 'source.js' do
  JQueryRubleUtils.get_definitions('trigger').each do |definition|
    snippet JQueryRubleUtils.get_command_name(definition).to_s do |snip|
      JQueryRubleUtils.define_snippet(definition, snip)
    end
  end
end
 