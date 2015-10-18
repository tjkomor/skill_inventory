require 'yaml/store'
require_relative 'skill'

class SkillInventory
  def self.database
    if ENV["RACK_ENV"] == "test"
      @database ||= Sequel.sqlite("db/task_manager_test.sqlite3")
    else
      @database ||= Sequel.sqlite("db/task_manager_development.sqlite3")
    end
  end

  def self.dataset
    database.from(:skills)
  end

  def self.create(description)
    dataset.insert(description)
  end

  def self.update(id, data)
    skill = dataset.where(:id => id)
    skill.update(data)
  end

  def self.delete(id)
    dataset.where(:id => id).delete
  end

  def self.all
    skills = dataset.to_a
    skills.map { |skill| Skill.new(skill)}
  end

  def self.find(id)
    skill = dataset.where(:id => id).to_a.first
    Skill.new(skill)
  end

  def self.find_by(data)
    dataset.where(data)
  end
end
