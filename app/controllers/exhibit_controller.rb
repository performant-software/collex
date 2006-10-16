class ExhibitController < ApplicationController
  layout "nines"
  
  def mine
    @exhibit_types = ExhibitType.find(:all)
    
    # TODO: look up all exhibits owned by the current user
  end
  
  def new
    @exhibit = Exhibit.new(:title => "<New>")
    @exhibit.exhibit_type = ExhibitType.find(params[:type])
    render :action => 'edit'
  end
  
  def edit
    @exhibit = Exhibit.find(params[:id])
  end
  
  def update
    @exhibit = Exhibit.new(params[:exhibit])
    @exhibit.save
    redirect_to :action => 'edit', :id => @exhibit
  end
end
