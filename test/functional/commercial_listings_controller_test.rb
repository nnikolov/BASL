require 'test_helper'

class CommercialListingsControllerTest < ActionController::TestCase
  setup do
    @commercial_listing = commercial_listings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:commercial_listings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create commercial_listing" do
    assert_difference('CommercialListing.count') do
      post :create, commercial_listing: @commercial_listing.attributes
    end

    assert_redirected_to commercial_listing_path(assigns(:commercial_listing))
  end

  test "should show commercial_listing" do
    get :show, id: @commercial_listing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @commercial_listing
    assert_response :success
  end

  test "should update commercial_listing" do
    put :update, id: @commercial_listing, commercial_listing: @commercial_listing.attributes
    assert_redirected_to commercial_listing_path(assigns(:commercial_listing))
  end

  test "should destroy commercial_listing" do
    assert_difference('CommercialListing.count', -1) do
      delete :destroy, id: @commercial_listing
    end

    assert_redirected_to commercial_listings_path
  end
end
