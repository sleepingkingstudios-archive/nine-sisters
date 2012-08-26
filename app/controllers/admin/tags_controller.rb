class Admin::TagsController < Admin::AdminController
  before_filter :build_tag, :only => %w(create new)
  before_filter :find_tag, :only => %w(edit show update)
  before_filter :find_tag_collection, :only => %w(index)
  
  def create
    if @tag.save
      append_flash :notice, "Tag was successfully created", true
      redirect_to admin_tags_path
    else
      find_tag_collection
      render :index
    end # if-else
  end # method create
  
  def edit
    if request.xhr?
      render :layout => nil
    else
      redirect_to admin_tags_path
    end # if-else
  end # method edit
  
  def index; end
  
  def new
    if request.xhr?
      render :layout => nil
    else
      redirect_to admin_tags_path
    end # if-else
  end # method new
  
  def show; end
  
  def update
    if @tag.update_attributes(params[:tag])
      append_flash :notice, "Tag was successfully updated", true
      redirect_to admin_tags_path
    else
      render :index
    end # if-else
  end # method update
  
  ##################
  # Helper Methods #
  
  def build_tag
    logger.debug "Params = #{params[:tag]}"
    @tag = Tag.new(params[:tag])
    logger.debug "Building tag, tag = #{@tag}"
  end # method build_tag
  
  def find_tag
    @tag = Tag.includes(:taggings).find(params[:id])
  end # method find_tag
  
  def find_tag_collection
    @tags = Tag.includes(:taggings).order(:title)
  end # method find_tag_collection
  
  private :build_tag, :find_tag, :find_tag_collection
end # controller Admin::TagsController
