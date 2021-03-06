require 'ruble'
require 'yaml'

# 
# = JQueryRubleUtils
# 
# Author:: delfino
# 
# == OverView
# Utilities of jQuery Ruble
#
class JQueryRubleUtils
  #
  # Array of jQuery definition
  #
  @@definitions =  YAML.load_file(File::expand_path('./definitions.yml', File::dirname(__FILE__)))

  #
  # Hash of jQuery API category
  #
  @@categories =  YAML.load_file(File::expand_path('./categories.yml', File::dirname(__FILE__)))

  #
  # Hash of groups in jQuery definition
  #
  @@groups = {}
  (@@definitions.select {|dfntn| dfntn.has_key?('group') && ! dfntn['group'].nil?}).each do |difinition_has_group|
    difinition_has_group['group'].each_key do |group_name|
      @@groups[group_name] = {} unless @@groups.has_key?(group_name)
      (@@definitions.select {|dfntn| dfntn.has_key?('group') && dfntn['group'].has_key?(group_name)}).each do |difinition_of_group|
        difinition_of_group['group'][group_name].each do |sub_group_name|
          @@groups[group_name][sub_group_name] = [] unless @@groups[group_name].has_key?(sub_group_name)
          @@groups[group_name][sub_group_name].push(difinition_of_group) if @@groups[group_name][sub_group_name].index(difinition_of_group)==nil
        end
      end
    end
  end

  #
  # Return categoies of jQuery API as Hash
  #
  # 
  # === Return
  # 
  # categoies of jQuery API as Hash
  #
  def self.get_categories()
    return @@categories
  end

  def self.get_definitions(key=nil, condition=nil)
    return @@definitions unless key
    return @@definitions.select {|definition| definition.has_key?(key)} unless condition
    return @@definitions.select {|definition| definition.has_key?(key) && (definition[key].instance_of?(Array) ? (definition[key].select {|val| condition=~val.to_s}).length > 0 : condition=~definition[key].to_s)}
  end

  #
  # Define command of specified jQuery definition
  #
  # === Arguments
  #
  # +definition+::
  # jQuery definition to define command
  # +command+::
  # command
  #
  def self.define_command(definition, command)
    command.key_binding     = definition['key_binding'].to_s
    command.key_binding.mac = definition['binding_mac'].to_s if definition['binding_mac']
    command.expansion       = definition['expansion'].to_s
    command.description     = self.get_description(definition)

    command.input  = :none
    command.output = :insert_as_snippet

    command.invoke do |context|
      context.output = command.expansion
    end
  end

  #
  # Define command of specified jQuery definition
  #
  # === Arguments
  #
  # +definition+::
  # jQuery definition to define command
  # +snippet+::
  # snippet
  #
  def self.define_snippet(definition, snippet)
    snippet.trigger     = definition['trigger'].to_s
    snippet.expansion   = definition['expansion'].to_s
    snippet.scope       = definition['scope'].to_s if definition['scope']
    snippet.description = self.get_description(definition)
  end

  #
  # Add command to specified menu
  #
  # === Arguments
  #
  # +menu+::
  # Menu to add command
  # +categories+::
  # Categories
  def self.add_commands(menu, categories, parent_category_name=nil)
    if categories.instance_of?(Hash)
      categories.each do |key, value|
        if value
          menu.menu key do |sub_menu|
            self.add_commands(sub_menu, value, parent_category_name ? "#{parent_category_name} > #{key}" : key)
            self.add_commands_by_category(sub_menu, parent_category_name ? "#{parent_category_name} > #{key}" : key)
          end
        else
          self.add_commands(menu, parent_category_name ? "#{parent_category_name} > #{key}" : key)
        end
      end
    elsif categories.instance_of?(Array)
      categories.each do |value|
        self.add_commands(menu, value, parent_category_name)
      end
    elsif categories.instance_of?(String)
      menu.menu categories do |sub_menu|
        self.add_commands_by_category(sub_menu, parent_category_name ? "#{parent_category_name} > #{categories}" : categories)
      end
    end
  end

  #
  # Add command of specified category to specified menu
  #
  # === Arguments
  #
  # +menu+::
  # Menu to add command
  # +category_name+::
  # Category name as String
  def self.add_commands_by_category(menu, category_name)
    definitions = @@definitions.select {|definition| definition.has_key?('categories') && definition['categories'].index(category_name.to_s)}
    definitions = definitions.sort{|a, b| a['title'] <=> b['title']}
    added_groups = []
    definitions.each do |definition|
      if definition['group'] && ! definition['group'].nil?
        self.add_command_by_menu(menu, definition['group'], added_groups)
      else
        menu.command self.get_command_name(definition)
      end
    end
  end

  #
  # Add command of specified group
  #
  # === Arguments
  #
  # +menu+::
  # Menu to add command
  # +group+::
  # Group to add as Hash
  # +added_groups+::
  # Already added group name as Array
  # 
  # === Return
  # 
  # Array of added groups
  #
  def self.add_command_by_menu(menu, group, added_groups)
    group.each_key do |group_name|
      if added_groups.index(group_name) == nil
        added_groups.push(group_name)
        if @@groups.has_key?(group_name)
          menu.menu group_name.to_s do |sub_menu|
            @@groups[group_name].each_key do |sub_group_name|
              sub_menu.menu sub_group_name.to_s do |sub_menu1|
                @@groups[group_name][sub_group_name].each do |dfntn|
                  sub_menu1.command self.get_command_name(dfntn)
                end
              end
            end
          end
        end
      end
    end
    return added_groups
  end

  #
  # Return command name of specified difinition
  #
  # === Arguments
  #
  # +definition+::
  # jQuery difinition as Hash
  # 
  # === Return
  # 
  # Command name as String
  #
  def self.get_command_name(definition)
    command_name = (definition.has_key?('title') ? definition['title'].to_s : 'no title')
    command_name += " (>=#{definition['version']})" if definition.has_key?('version')
    return command_name
  end

  #
  # Return description of specified difinition
  #
  # === Arguments
  #
  # +definition+::
  # jQuery difinition as Hash
  # 
  # === Return
  # 
  # Description of specified definition as String
  #
  def self.get_description(definition)
    description = (definition.has_key?('description') ? definition['description'].to_s : '')
    description += " (version added: #{definition['version']})" if definition.has_key?('version')
    return description
  end
end
