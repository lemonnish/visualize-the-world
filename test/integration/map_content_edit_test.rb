require 'test_helper'

class MapContentEditTest < ActionDispatch::IntegrationTest

  def setup
    log_in_as users(:lauren)
    @map = maps(:basic_public)
    @other_map = maps(:basic_private)
    @content = map_contents(:france)
  end

  test "successful add/update/delete of map content" do
    # straightforward add
    get edit_map_path(@map)
    assert_select 'form' do
      assert_select '[action=?]', map_contents_path(@map)
      assert_select '[method="post"]'
    end
    assert_difference '@map.map_contents.count', 1 do
      post map_contents_path(@map), params: {
        map_content: { country_code: "DE", comment: "" } }
    end
    new_content = assigns(:content)
    assert_equal "DE", new_content.country_code
    assert_redirected_to edit_map_path(@map)
    follow_redirect!
    assert_template 'maps/edit'

    # straightforward update
    assert_select 'form' do
      assert_select '[action=?]', map_contents_path(@map)
      assert_select '[method="patch"]'
    end
    text = "Here's some text about Germany!"
    text2 = "Here's some text about France!"
    patch map_contents_path(@map), params: {
      map_content: { de_comment: text, fr_comment: text2 } }
    assert_redirected_to edit_map_path(@map)
    follow_redirect!
    assert_template 'maps/edit'
    new_content.reload
    @content.reload
    assert_equal text, new_content.comment
    assert_equal text2, @content.comment

    # ignore country_code changes when updating
    text = "Shouldn't be able to turn France into Germany"
    patch map_contents_path(@map), params: {
      map_content: { fr_country_code: "DE", fr_comment: text } }
    assert_redirected_to edit_map_path(@map)
    follow_redirect!
    assert_template 'maps/edit'
    assert_select 'div#error_explanation', count: 0
    @content.reload
    assert_equal "FR", @content.country_code
    assert_equal text, @content.comment

    # straightforward delete
    assert_select "a[href=?]", map_content_path(@map, new_content)
    assert_difference '@maps.map_contents.count', -1 do
      delete map_content_path(@map, new_content)
    end
    assert_redirected_to edit_map_path(@map)
  end

  test "unsuccessful add of map content" do
    # clicked 'cancel'
    assert_no_difference '@map.map_contents.count' do
      post map_contents_path(@map), params: {
        map_content: { country_code: "DE", comment: "Germany", commit: "Cancel" } }
    end
    assert_redirected_to edit_map_path(@map)
    follow_redirect!

    # no country_code
    assert_no_difference '@map.map_contents.count' do
      post map_contents_path(@map), params: {
        map_content: { country_code: "", comment: "No country_code..." } }
    end
    assert_template 'maps/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors', 2

    # duplicate country_code
    assert_no_difference '@map.map_contents.count' do
      post map_contents_path(@map), params: {
        map_content: { country_code: "FR", comment: "Can't have 2 France entries" } }
    end
    assert_template 'maps/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors', 2
  end

  test "unsuccessful update of map content" do
    # clicked 'cancel'
    text = "France!"
    patch map_contents_path(@map), params: {
      map_content: { fr_comment: text, commit: 'Cancel' } }
    assert_redirected_to edit_map_path(@map)
    @content.reload
    assert_not_equal text, @content.comment

    # country entry doesn't already exist
    text = "Vietnam!"
    patch map_contents_path(@map), params: {
      map_content: { vn_comment: text } }
    assert_template 'maps/edit'
    @content.reload
    assert_not_equal text, @content.comment
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
