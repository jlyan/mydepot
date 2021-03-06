require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
		    @update = {

      :title       => 'Lorem Ipsum',

      :description => 'Wibbles are fun!',

      :image_url   => 'lorem.jpg',

      :price       => 19.95

    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, :product => @update
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, :id => @product.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product.to_param
    assert_response :success
  end

  test "should update product" do
    put :update, :id => @product.to_param, :product => @update
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, :id => @product.to_param
    end

    assert_redirected_to products_path
  end

	  test "product attributes must not be empty" do

    product = Product.new

    assert product.invalid?

    assert product.errors[:title].any?

    assert product.errors[:description].any?

    assert product.errors[:price].any?

    assert product.errors[:image_url].any?

  end

 

  test "product price must be positive" do

    product = Product.new(:title       => "My Book Title",

                          :description => "yyy",

                          :image_url   => "zzz.jpg")

    product.price = -1

    assert product.invalid?

    assert_equal "must be greater than or equal to 0.01", 

      product.errors[:price].join('; ')

 

    product.price = 0

    assert product.invalid?

    assert_equal "must be greater than or equal to 0.01", 

      product.errors[:price].join('; ')

 

    product.price = 1

    assert product.valid?

  end

 

  def new_product(image_url)

    Product.new(:title       => "My Book Title",

                :description => "yyy",

                :price       => 1,

                :image_url   => image_url)

  end

 

  test "image url" do

    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg

             http://a.b.c/x/y/z/fred.gif }

    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    

    ok.each do |name|

      assert new_product(name).valid?, "#{name} shouldn't be invalid"

    end

 

    bad.each do |name|

      assert new_product(name).invalid?, "#{name} shouldn't be valid"

    end

  end

 

  test "product is not valid without a unique title" do

    product = Product.new(:title       => products(:ruby).title,

                          :description => "yyy", 

                          :price       => 1, 

                          :image_url   => "fred.gif")

 

    assert !product.save

    assert_equal "has already been taken", product.errors[:title].join('; ')

  end

 

  test "product is not valid without a unique title - i18n" do

    product = Product.new(:title       => products(:ruby).title,

                          :description => "yyy", 

                          :price       => 1, 

                          :image_url   => "fred.gif")

 

    assert !product.save

    assert_equal I18n.translate('activerecord.errors.messages.taken'),

                 product.errors[:title].join('; ')

  end
  
  test "cann't delete product in cart" do
  	assert_difference('Product.count',0) do
  	delete :destroy, :id => products(:ruby).to_param
  	end
  end

end
