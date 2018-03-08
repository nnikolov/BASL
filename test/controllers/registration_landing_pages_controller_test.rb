require 'test_helper'

class RegistrationLandingPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registration_landing_page = registration_landing_pages(:one)
  end

  test "should get index" do
    get registration_landing_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_registration_landing_page_url
    assert_response :success
  end

  test "should create registration_landing_page" do
    assert_difference('RegistrationLandingPage.count') do
      post registration_landing_pages_url, params: { registration_landing_page: { active: @registration_landing_page.active, description: @registration_landing_page.description, name: @registration_landing_page.name } }
    end

    assert_redirected_to registration_landing_page_url(RegistrationLandingPage.last)
  end

  test "should show registration_landing_page" do
    get registration_landing_page_url(@registration_landing_page)
    assert_response :success
  end

  test "should get edit" do
    get edit_registration_landing_page_url(@registration_landing_page)
    assert_response :success
  end

  test "should update registration_landing_page" do
    patch registration_landing_page_url(@registration_landing_page), params: { registration_landing_page: { active: @registration_landing_page.active, description: @registration_landing_page.description, name: @registration_landing_page.name } }
    assert_redirected_to registration_landing_page_url(@registration_landing_page)
  end

  test "should destroy registration_landing_page" do
    assert_difference('RegistrationLandingPage.count', -1) do
      delete registration_landing_page_url(@registration_landing_page)
    end

    assert_redirected_to registration_landing_pages_url
  end
end
