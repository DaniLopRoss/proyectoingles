require "application_system_test_case"

class ReferenciaTest < ApplicationSystemTestCase
  setup do
    @referencium = referencia(:one)
  end

  test "visiting the index" do
    visit referencia_url
    assert_selector "h1", text: "Referencia"
  end

  test "should create referencium" do
    visit referencia_url
    click_on "New referencium"

    click_on "Create Referencium"

    assert_text "Referencium was successfully created"
    click_on "Back"
  end

  test "should update Referencium" do
    visit referencium_url(@referencium)
    click_on "Edit this referencium", match: :first

    click_on "Update Referencium"

    assert_text "Referencium was successfully updated"
    click_on "Back"
  end

  test "should destroy Referencium" do
    visit referencium_url(@referencium)
    click_on "Destroy this referencium", match: :first

    assert_text "Referencium was successfully destroyed"
  end
end
