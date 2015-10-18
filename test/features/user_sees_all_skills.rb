require_relative '../test_helper'

class UserSeesAllSKillsTest < FeatureTest

  def create_skills(num)
    num.times do |i|
      SkillInventory.create({ :title       => "#{i+1} title",
                           :description => "#{i+1} description"})
    end
  end

  def test_new_task_creation
    visit("/")
    click_link("New Skill")

    fill_in("skill-title", with: "new skill")
    fill_in("skill-description", with: "new description")
    assert_equal "/skills/new", current_path
    click_button("Create Skill")
    assert_equal "/skills", current_path

    within(".container") do
      assert page.has_content?("new skill")
    end
  end

  def test_user_can_edit_a_task
    create_tasks(1)
    task = SkillInventory.all.last

    visit "/skills"
    click_link("edit")
    fill_in("skill-title", with: "new skill edited")
    fill_in("skill-description", with: "new description edited")
    click_button("Update Skill")

    assert_equal "/skills/#{skill.id}", current_path
    within(".container") do
      assert page.has_content?("new skill edited")
    end
  end

  def test_user_can_delete_a_task
    create_tasks(1)

    visit "/skills"
    click_button("delete")

    refute page.has_content?("new skill")
  end

  def test_a_user_can_see_a_single_task
    create_tasks(1)
    task = SkillInventory.all.last

    visit "/skills"

    click_link("1 title")
    assert_equal "/skills/#{skill.id}", current_path
    assert page.has_content?("1 description")
  end

  def test_filter_task_index_by_param
    create_tasks(2)
    SkillInventory.create({ :title       => "ruby",
                         :description => "rails"})
    SkillInventory.create({ :title       => "something",
                         :description => "something else"})

    visit "/skills?title=ruby"

    selected_skills = SkillInventory.all.select { |skill| skill.title == "ruby"}
    selected_skills.each do |skill|
      within(".selected_skills-#{skill.id}") do
        assert page.has_content?("ruby")
      end
    end

    refute page.has_content?("1 title")
    refute page.has_content?("2 title")
  end
end
