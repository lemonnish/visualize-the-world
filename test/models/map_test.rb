require 'test_helper'

class MapTest < ActiveSupport::TestCase

  def setup
    @user = users(:lauren)
    @map = @user.maps.new(title: "New Sample Map", privacy_public: true,
                          projection: "geoAirocean")
    @example_map = maps(:example)
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

  test "should allow only one example map" do
    map2 = @example_map.dup

    assert_no_difference 'Map.count' do
      map2.save
    end
  end

  test "example map must be public" do
    assert @example_map.example_map
    assert @example_map.valid?

    @example_map.privacy_public = false
    assert_not @example_map.valid?
  end
end
