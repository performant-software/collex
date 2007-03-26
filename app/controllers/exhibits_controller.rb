class ExhibitsController < ApplicationController
  layout "nines"
  prepend_before_filter :authorize, :only => [:create, :new, :edit, :update, :destroy]
  before_filter :authorize_owner, :only => [:edit, :update, :destroy]
  
  in_place_edit_for_resource :exhibit, :title
  in_place_edit_for_resource :exhibit, :annotation
  
  # GET /exhibits
  # GET /exhibits.xml
  def index
    @exhibits = Exhibit.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @exhibits.to_xml }
    end
  end

  # GET /exhibits/1
  # GET /exhibits/1.xml
  def show
    @exhibit = Exhibit.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @exhibit.to_xml }
    end
  rescue ActiveRecord::RecordNotFound
    flash[:warning] = "That Exhibit could not be found."
    redirect_to :action => "index"
  end

  # GET /exhibits/new
  def new
    @exhibit = Exhibit.new
    #TODO remove all this hard-coded data
    @exhibit.user = User.find_by_username(my_username)
    @exhibit.license_id = 1
    @exhibit.exhibit_type_id = 2
    @licenses = License.find(:all)
    @exhibit_types = ExhibitType.find(:all)
  end

  # GET /exhibits/1;edit
  def edit
    # @exhibit retrieved in authorize_owner
  end

  # POST /exhibits
  # POST /exhibits.xml
  def create
    @exhibit = Exhibit.new(params[:exhibit])

    respond_to do |format|
      if @exhibit.save
        flash[:notice] = 'Exhibit was successfully created.'
        format.html { redirect_to edit_exhibit_url(@exhibit) }
        format.xml  { head :created, :location => exhibit_url(@exhibit) }
      else
        format.html do
          @licenses = License.find(:all)
          @exhibit_types = ExhibitType.find(:all)
          render :action => "new"
        end
        format.xml  { render :xml => @exhibit.errors.to_xml }
      end
    end
  end
  
  # PUT /exhibits/1
  # PUT /exhibits/1.xml
  def update
    # @exhibit retrieved in authorize_owner
    unless params[:new_resource].blank?
      uri = params[:new_resource].match('thumbnail_').post_match
      unless @exhibit.uris.include?(uri)
        section_id = params[:section_id].to_i
        es = section_id > 0 ? @exhibit.exhibited_sections.find(section_id) : ExhibitedSection.new(:exhibit_section_type_id => 1)
        @exhibit.exhibited_sections << es if section_id == 0
        @exhibit.exhibited_sections.last.move_to_top if section_id == 0
        @exhibit.save
        er = ExhibitedResource.new(:uri => uri)
        es.exhibited_resources << er
        es.exhibited_resources.last.move_to_top
        @exhibit.save
      else
        flash[:error] = "You already have that object in your collection."
      end
    end
    respond_to do |format|
      if @exhibit.update_attributes(params[:exhibit])
        flash[:notice] = 'Exhibit was successfully updated.'
        format.html do
          unless er.blank?
            redirect_to edit_exhibit_url(:id => @exhibit, :anchor => dom_id(er))
          else
            redirect_to edit_exhibit_url(@exhibit)
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @exhibit.errors.to_xml }
      end
    end
  end

  # DELETE /exhibits/1
  # DELETE /exhibits/1.xml
  def destroy
    # @exhibit retrieved in authorize_owner
    @exhibit.destroy

    respond_to do |format|
      format.html { redirect_to exhibits_url }
      format.xml  { head :ok }
    end
  end
  
  private
    def authorize_owner
      @exhibit = Exhibit.find(params[:id])
      unless @exhibit.owner?(user)
        flash[:warning] = "You do not have permission to edit that Exhibit!"
        redirect_to(exhibits_path) and return false
      end
    rescue ActiveRecord::RecordNotFound
      flash[:warning] = "That Exhibit could not be found."
      redirect_to :action => "index"
    end
  
end
