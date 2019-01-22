# Dir["~/Desktop/W3D2/*.rb"].each {|file| require_relative file }
require_relative 'question_follows'
require_relative 'question_likes'
require_relative 'questions'
require_relative 'users'
require_relative 'replies'
require_relative 'questions_database' 
require_relative 'questions_database' 

class QuestionFollows < ModelBase
    attr_accessor :id, :question_id, :user_id

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM question_follows')
        data.map {|datum| QuestionFollows.new(datum)}
    end

    def self.find_by_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT * 
        FROM question_follows 
        WHERE question_id = ?
        SQL
        data.map {|datum| QuestionFollows.new(datum)}
    end

    def self.find_by_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT * 
        FROM question_follows 
        WHERE user_id = ?
        SQL
        data.map {|datum| QuestionFollows.new(datum)}
    end

    def self.followers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT * 
        FROM question_follows
        JOIN users ON question_follows.user_id = users.id
        WHERE question_id = ?
        SQL
        data.map {|datum| Users.new(datum)}
    end

    def self.followed_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT * 
        FROM users
        JOIN questions ON questions.author_id = users.id
        WHERE users.id = ?
        SQL
        data.map {|datum| Questions.new(datum)}
    end

    def self.most_followed_questions(n)
        data = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT * 
        FROM questions
        LEFT JOIN question_follows ON question_follows.question_id = questions.id
        GROUP BY questions.id 
        ORDER BY COUNT(*) DESC
        LIMIT ?
        SQL
        data.map {|datum| Questions.new(datum)}
    end

    def initialize(options={})
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end
end