class CategoriesController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  # GET /*path/:feature
  def find
    @categories = Array.new
    
    unless params[:path].nil?
      params[:path].split("/").each do |slug|
        category = (category ? category.children : Category).find_by_slug slug
        if category.nil?
          append_flash :error, "Could not find category /#{@categories.map { |cat|
            cat.slug }.join('/')}/#{slug}", true
          redirect_to :root and return
        else
          @categories << category
        end # if-else
      end # each
      
      @features = @categories.last.features
      @categories.last.features.each do |feature|
        if feature.slug.parameterize == params[:feature]
          feature_class = feature.class.to_s.underscore
          instance_variable_set :"@#{feature_class}", feature
          
          render "#{feature_class.pluralize}/show" and return
        end # if
      end # each
      
      append_flash :error, "Could not find content /#{@categories.map { |cat|
        cat.slug }.join('/')}/#{params[:feature]}", true
      redirect_to :root and return
    end # unless
  end # action find
end # controller CategoriesController
