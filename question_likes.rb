# Dir["~/Desktop/W3D2/*.rb"].each {|file| require_relative file }
require_relative 'question_follows'
require_relative 'question_likes'
require_relative 'questions'
require_relative 'users'
require_relative 'replies'
require_relative 'questions_database'

class QuestionLikes
    attr_accessor :id, :question_id, :user_id

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM question_likes')
        data.map {|datum| QuestionLikes.new(datum)}
    end

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT * 
        FROM question_likes 
        WHERE id = ?
        SQL
        QuestionLikes.new(data[0])
    end

    def self.find_by_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT * 
        FROM question_likes 
        WHERE question_id = ?
        SQL
        data.map {|datum| QuestionLikes.new(datum)}
    end

    def self.find_by_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT * 
        FROM question_likes 
        WHERE user_id = ?
        SQL
        data.map {|datum| QuestionLikes.new(datum)}
    end

    def initialize(options={})
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end
end
