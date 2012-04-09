require 'ruble'
require(File::expand_path('./lib/jquery_ruble_utils.rb', File::dirname(__FILE__)))

#
# jQuery Ruble
# 
bundle do |bundle|
  bundle.author = 'delfino'
  bundle.copyright = 'Copyrights 2010-2012 delfino All Rights Reserved'
  bundle.display_name = 'jQuery'
  bundle.description = 'Bundle for development with JQuery'

  bundle.menu 'jQuery' do |main_menu|
    main_menu.scope = ['source.js']

    JQueryRubleUtils.get_categories().each do |menu_key, menu_value|
      main_menu.menu menu_key do |sub_menu|
        if menu_value.instance_of?(Array)
          menu_value.each do |sub_menu_value|
            sub_menu.menu sub_menu_value do |sub_menu1|
              JQueryRubleUtils.add_commands(sub_menu1, menu_key, sub_menu_value)
            end
          end
          JQueryRubleUtils.add_commands(sub_menu, menu_key)
        else
          JQueryRubleUtils.add_commands(sub_menu, menu_key)
        end
      end
    end

    main_menu.separator
    main_menu.command 'Concole Log'
  end
end
