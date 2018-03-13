require 'test_helper'

class MapContentEditTest < ActionDispatch::IntegrationTest

  def setup
    log_in_as users(:lauren)
    @map = maps(:basic_public)
    @other_map = maps(:basic_private)
    @content = map_contents(:france)
    @other_content = map_contents(:us)
  end

  test "successful add/update/delete of map content" do
    get edit_map_path(@map)
    assert_select 'form[action=?]', "/maps/#{ @map.id }/map_contents"
    assert_difference '@maps.map_contents.count', 1 do
      post map_contents_path(@map), params: {
        map_content: { country_code: "DE", comment: "" } }
    end
    @new_content = assign(:map_contents)
    assert_template 'maps/edit'

    assert_select 'form[action=?]',
      "/maps/#{ @map.id }/map_contents/#{ @new_content.id }"
    text = "Here's some text about Germany!"
    patch map_content_path(@map, @new_content), params: {
      map_content: { comment: text } }
    assert_template 'maps/edit'
    @new_content.reload
    assert_equal text, @new_content.comment

    assert_select "a[href=?]", map_content_path(@map, @new_content)
    assert_difference '@maps.map_contents.count', -1 do
      delete map_content_path(@map, @new_content)
    end
  end

  test "unsuccessful add of map content" do
    # duplicate country_code
    assert_no_difference '@map.map_contents.count' do
      post map_contents_path(@map), params: {
        map_content: { country_code: "FR", comment: "" } }
    end
    assert_template 'maps/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors', 2

    # no country_code
    assert_no_difference '@maps.map_contents.count' do
      post map_contents_path(@map), params: {
        map_content: { country_code: "", comment: "No country_code..." } }
    end
    assert_template 'maps/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors', 2
  end

  test "unsuccessful update of map content" do
    # wrong :map_id
    patch map_content_path(@other_map, @content), params: {
      map_content: { comment: "France!" } }
    assert_redirected_to maps_path
    assert_select 'div#error_explanation'
    @content.reload
    assert_not_equal "France!", @content.comment

    # ignore country_code changes
    text = "Shouldn't be able to turn France into Germany"
    patch map_content_path(@map, @content), params: {
      map_content: { country_code: "DE", comment: text } }
    assert_template
    assert_select 'div#error_explanation', count: 0
    @content.reload
    assert_equal "FR", @content.country_code
    assert_equal text, @content.comment
  end

  test "unsuccessful delete of map content" do
    # wrong :map_id
    assert_no_difference ['@map.map_contents.count',
                          '@other_map.map_contents.count'] do
      delete map_content_path(@other_map, @content)
    end
    assert_redirected_to maps_path
  end
end
