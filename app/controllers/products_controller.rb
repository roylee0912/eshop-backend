class ProductsController < ApplicationController
    def index
        products = Product.all
        render json: {
            products: products
        }
    end

    def show
        product = Product.find(params[:id])
            render json: product
    end

    def add_to_cart

        if logged_in? && current_user
            cartItems=Cart.where(["user_id = ? and product_id = ?", current_user.id, params[:id]])
            #if the product already exists in your cart, then you just add 1 to it.
            # if the product doesn't exist, then you create it.
            if cartItems.length>0
                #if the product already exists in the current user's cart, then just add 1 to current quantity
                cartItems.each {|cartItem| cartItem.update(quantity: cartItem.quantity + 1)}


            else
                #if the customer doesn't have a copy of the product, then create a Cart object with quantity 1
                current_user.products << Product.find(params[:id])

            end
            render json: current_user, status: :ok
        else
            render json: {error: "Must be logged in to add to cart"}, status: 401
        end
    end

    def change_cart_quantity
        cartItems=Cart.where(["user_id = ? and product_id = ?", current_user.id, params[:id]])
        cartItems.each {|cartItem| cartItem.update(quantity: cartItem.quantity + params[:amount_to_change])}
        render json :cartItems, status: :ok
    end

    def add_review
        product=Product.find(params[:id])
        review=Review.create(rev: params[:rev], rating: params[:rating], username: params[:username], product_id: params[:id])
        if review.save 
            #successfully saved review
            #should update the review
            render json: :review, status: :ok
        else
            #error in saving
            render json: {error: "Error in saving review. Please try again later."}, status: 401
        end
    end

    def get_reviews
        product=Product.find(params[:id])
        render json: product.reviews, status: :ok

    end

    def get_average_review
        product=Product.find(params[:id])
        total=0
        totalRev=0
        product.reviews.each {|review| totalRev+=review.rev; total+=1}
        puts totalRev/total.to_i
    end

end

