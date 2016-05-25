require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
    test "should not save character without name" do
         character = Character.new
         assert_not character.save, "saved character without name"
    end
end
