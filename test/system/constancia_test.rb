require "application_system_test_case"

class ConstanciaTest < ApplicationSystemTestCase
  setup do
    @constancium = constancia(:one)
  end

  test "visiting the index" do
    visit constancia_url
    assert_selector "h1", text: "Constancia"
  end

  test "should create constancium" do
    visit constancia_url
    click_on "New constancium"

    click_on "Create Constancium"

    assert_text "Constancium was successfully created"
    click_on "Back"
  end

  test "should update Constancium" do
    visit constancium_url(@constancium)
    click_on "Edit this constancium", match: :first

    click_on "Update Constancium"

    assert_text "Constancium was successfully updated"
    click_on "Back"
  end

  test "should destroy Constancium" do
    visit constancium_url(@constancium)
    click_on "Destroy this constancium", match: :first

    assert_text "Constancium was successfully destroyed"
  end
end
