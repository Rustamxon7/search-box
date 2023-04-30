class Argument < ApplicationRecord

  validates :title, presence: true
  validates :title, uniqueness: true
  validates :title, length: { minimum: 3 }

  scope :search, -> (query = '') { where('lower(title) LIKE ?', "%#{query.downcase}%") }
  
  scope :top, -> { order(score: :desc) }
  scope :most_searched, -> { order(search_count: :desc) }
  scope :least_searched, -> { order(search_count: :asc) }

  after_save :broadcast_update

  LIMIT = 10

  def self.search_and_score(query)
    arguments = Argument.search(query)
    
    if arguments.present?
      arguments.each do |argument|
        if argument.title.downcase === query.downcase
          argument.increment!(:search_count)
          argument.save
        end
      end
    else
      if validate_query(query)
        puts "🔍 #{query}"
        save_new_argument(query)
      else 
        save_existing_argument(query)
      end
    end

    return arguments.most_searched

    puts "🔍 #{query}"
  end

  private

  def self.validate_query(query)
    if query.ends_with?('?') and (query.starts_with?('Why ', 'What ', 'How ', 'When ', 'Who ', 'Where ') || query.match?(/^[A-Z]/)) and query.count('?') == 1
      return true
    elsif query.ends_with?('!') and query.match?(/^[A-Z]/)
      return true
    elsif query.ends_with?('...') and query.match?(/^[A-Z]/)
      return true
    else
      return false
    end
  end

  def self.save_new_argument(query)
    Argument.new(title: query, search_count: 1).save
    puts "💾 #{query} saved."
  end

  def self.save_existing_argument(query)
    articles = Article.search(query)

    if articles.present?
      articles.each do |article|
        if article.title === query
          Argument.new(title: query, search_count: 1).save
          puts "💾 #{query}: exists article but not searched before."
        end
      end
    end
  end

  def update_score
    if self.search_count > 0
      self.score = self.search_count * 0.5
    else
      self.score = 1
    end
  end

  def broadcast_update
    arguments_html = ApplicationController.render(
      partial: "arguments/arguments",
      locals: { arguments: Argument.all.most_searched }
    )

    ActionCable.server.broadcast(
      "arguments_channel",
      {
        arguments_html: arguments_html,
      }
    )
  end
end
