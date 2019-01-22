# Dir["~/Desktop/W3D2/*.rb"].each {|file| require_relative file }
require_relative 'question_follows'
require_relative 'question_likes'
require_relative 'questions'
require_relative 'users'
require_relative 'replies'
require_relative 'questions_database'

class Questions
    attr_accessor :id, :title, :body, :author_id 

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM questions')
        data.map {|datum| Questions.new(datum)}
    end

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE id = #{id}")
        Questions.new(data[0])
    end

    def self.find_by_author_id(author_id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE author_id = #{author_id}")
        Questions.new(data[0])
    end

    def initialize(options={})
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def author
        Users.find_by_id(self.author_id)
    end

    def replies
        Replies.find_by_question_id(self.id)
    end

    def followers
        QuestionFollows.followers_for_question_id(self.id)
    end
end