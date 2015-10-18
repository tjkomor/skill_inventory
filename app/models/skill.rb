class Skill
  attr_reader :title,
              :description,
              :id

  def initialize(data)
    @description = data['description']
    @id = data['id']
    @title = data['title']
  end
end
