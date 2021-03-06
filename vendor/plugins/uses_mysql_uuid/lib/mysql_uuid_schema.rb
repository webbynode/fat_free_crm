# Fat Free CRM
# Copyright (C) 2008-2009 by Michael Dvorkin
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http:#www.gnu.org/licenses/>.
#------------------------------------------------------------------------------

ActiveRecord::ConnectionAdapters::SchemaStatements.module_eval do

  def add_uuid_trigger(table, column = :uuid, options = { :index => true })
    if adapter_name.downcase == "mysql"
      if select_value("select version()").to_i >= 5
        execute("CREATE TRIGGER #{table}_#{column} BEFORE INSERT ON #{table} FOR EACH ROW SET NEW.#{column} = UUID()")
        add_index(table, column) if options[:index]
      end
    end
  end

end