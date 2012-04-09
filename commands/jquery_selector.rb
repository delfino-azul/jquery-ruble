require 'ruble'
require(File::expand_path('../lib/jquery_ruble_utils.rb', File::dirname(__FILE__)))

with_defaults :scope => 'source.js string.quoted.single.js, source.js string.quoted.double.js' do
  JQueryRubleUtils.get_definitions('key_binding').each do |definition|
    command JQueryRubleUtils.get_command_name(definition).to_s do |cmd|
      JQueryRubleUtils.define_command(definition, cmd)
    end
  end
end
