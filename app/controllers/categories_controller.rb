class CategoriesController < ApplicationController
  # GET /*path/:feature
  def find
    @categories = Array.new
    
    unless params[:path].nil?
      params[:path].split("/").each do |slug|
        category = (category ? category.children : Category).find_by_slug slug
        if category.nil?
          append_flash :error, "Could not find category /#{@categories.map { |cat|
            cat.slug }.join('/')}/#{slug}", true
          redirect_to :root
        else
          @categories << category
        end # if-else
      end # each
      
      @features = @categories.last.features
      @categories.last.features.each do |feature|
        if feature.slug == params[:feature]
          feature_class = StringHelpers.snakify(feature.class.to_s)
          instance_variable_set :"@#{feature_class}", feature
          
          render "#{TextHelper.pluralize(0, feature_class)}/show" and return
        end # if
      end # each
      
      # append_flash :error, "Could not find feature /#{@categories.map { |cat|
      #   cat.slug }.join('/')}/#{params[:feature]}", true
      # redirect_to :root
    end # unless
  end # action find
end # controller CategoriesController
