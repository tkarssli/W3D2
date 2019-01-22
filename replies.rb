# Dir["~/Desktop/W3D2/*.rb"].each {|file| require_relative file }
require_relative 'question_follows'
require_relative 'question_likes'
require_relative 'questions'
require_relative 'users'
require_relative 'replies'
require_relative 'questions_database'

class Replies
    attr_accessor :id, :question_id, :user_id, :parent_reply_id, :reply_body

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM replies')
        data.map {|datum| Replies.new(datum)}
    end

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT * 
        FROM replies
        WHERE id = ?
        SQL
        Replies.new(data[0])
    end

    def self.find_by_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT * 
        FROM replies
        WHERE question_id = ?
        SQL
        data.map {|datum| Replies.new(datum)}
    end

    def self.find_by_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT * 
        FROM replies
        WHERE user_id = ?
        SQL
        data.map {|datum| Replies.new(datum)}
    end 

    def self.body_text_search(search)
        # WASNT WORKING WITH HEREDOC
        data = QuestionsDatabase.instance.execute(" SELECT * 
        FROM replies
        WHERE reply_body LIKE '%#{search}%'")
        data.map {|datum| Replies.new(datum)}
    end

    def initialize(options={})
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
        @parent_reply_id = options['parent_reply_id']
        @reply_body = options['reply_body']
    end

    def author
        Users.find_by_id(self.user_id)
    end

    def question
        Questions.find_by_id(self.question_id)
    end

    def parent_reply
        raise 'No parent' if self.parent_reply_id.nil?
        Replies.find_by_id(self.parent_reply_id)
    end

    def child_replies
        replies = QuestionsDatabase.instance.execute(<<-SQL, self.id)
        SELECT *
        FROM replies
        WHERE parent_reply_id = ?
        SQL

        replies.map {|reply| Replies.new(reply)}
    end
end