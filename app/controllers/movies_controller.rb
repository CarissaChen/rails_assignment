class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
    #@movies = Movie.all
    @all_ratings = Movie.all_ratings
    @sorted = session[:sorted]
    @ratings = session[:ratings]
    @relist = 0
    
    if(params[:ratings] != nil)
    	@checked_ratings = params[:ratings]
    	@movies = Movie.find(:all, :conditions => {:rating => @checked_ratings.keys})
    	@relist = 1
    	
    else
    	@checked_ratings = @all_ratings
    	@movies = Movie.all
    end
    
    if(params[:sort] == 'title')
    	session[:sort] = params[:sort]
    	@movies = @movies.sort_by {|m| m.title}
    	#@relist = 1
    	
    	
    	
    elsif(params[:sort] == 'release')
    	session[:sort] = params[:sort]
    	@movies = @movies.sort_by {|m| m.release_date}
    	#@relist = 1
    	
    	
    
    #elsif(session.has_key?(:sort))
    #elsif(params[:sort] == nil)
    	#params[:sort] = session[:sort]
    	#@relist = 1
    end
    
    #if(@relist == 1)
    #	redirect_to :sort=>params[:sort], :ratings=>params[:ratings]
    #end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
