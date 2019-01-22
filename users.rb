# Dir["~/Desktop/W3D2/*.rb"].each {|file| require_relative file }
require_relative 'question_follows'
require_relative 'question_likes'
require_relative 'questions'
require_relative 'users'
require_relative 'replies'
require_relative 'questions_database'

class Users
    attr_accessor :id, :fname, :lname

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM users')
        data.map {|datum| Users.new(datum)}
    end

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT * 
        FROM users 
        WHERE id = ?
        SQL
        Users.new(data[0])
    end

    def self.find_by_name(fname, lname)
        data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        SELECT * 
        FROM users 
        WHERE fname = ? 
        AND lname = ?
        SQL
        data.map {|datum| Users.new(datum)}
    end

    def initialize(options={})
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def authored_questions
        Questions.find_by_author_id(self.id)
    end 

    def authored_replies
        Replies.find_by_user_id(self.id)
    end
    
    def followed_questions
        QuestionFollows.followed_questions_for_user_id(self.id)
    end
end