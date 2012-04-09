require 'ruble'
[
  ['JavaScript with jQuery Template', 'javascript_with_jquery.js'], 
  ['jQuery Plugin Template', 'jquery_plugin.txt']
].each do |template_definition|
  template template_definition[0] do |tmpl|
    tmpl.filetype = '*.js'
    tmpl.invoke do |context|
      template_file = "#{ENV['TM_BUNDLE_SUPPORT']}/../templates/#{template_definition[1]}"
      raw_contents = IO.read(template_file).gsub(/\$\{PLUGIN_NAME\}/, ENV['TM_NEW_FILE_BASENAME'].sub(/^(jquery\.?)?([^.]*)(\.?plugin)?$/, '\2'))
      raw_contents.gsub(/\$\{([^}]*)\}/) { |match| ENV[match[2..-2]] }
    end
  end
end
