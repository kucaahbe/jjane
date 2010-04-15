class AddMenu<%= menu_name.underscore.camelize %>ToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :nav_<%= menu_name -%>, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :nav_<%= menu_name %>
  end
end
