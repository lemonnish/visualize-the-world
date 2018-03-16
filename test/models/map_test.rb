require 'test_helper'

class MapTest < ActiveSupport::TestCase

  def setup
    @user = users(:lauren)
    @map = @user.maps.new(title: "New Sample Map", privacy_public: true,
                          projection: "geoAirocean")
  end

  test "should be a valid map" do
    assert @map.valid?
  end

  test "title should be present" do
    @map.title = "   "
    assert_not @map.valid?
  end

  test "projection should be present" do
    @map.projection = nil
    assert_not @map.valid?
  end

  test "projection should be in list of allowed projections" do
    @map.projection = "something that's not a projection"
    assert_not @map.valid?
  end
end
