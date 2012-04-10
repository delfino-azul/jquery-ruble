require 'ruble'
require(File::expand_path('./lib/jquery_ruble_utils.rb', File::dirname(__FILE__)))

#
# jQuery Ruble
# 
bundle do |bundle|
  bundle.author       = 'delfino'
  bundle.copyright    = 'Copyrights 2012 delfino All Rights Reserved'
  bundle.display_name = 'jQuery'
  bundle.description  = 'Bundle for development with JQuery'

  bundle.menu 'jQuery' do |main_menu|
    JQueryRubleUtils.add_commands(main_menu, JQueryRubleUtils.get_categories())

    main_menu.separator
    main_menu.command 'Concole Log'
  end
end
