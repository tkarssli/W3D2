require 'active_support/inflector'


class ModelBase
    def self.find_by_id(id)
        table_name = self.to_s.tableize
        data = QuestionsDatabase.instance.execute("SELECT * FROM #{table_name} WHERE id = #{id}"
        data.map {|datum| self.new(datum)}
    end
end