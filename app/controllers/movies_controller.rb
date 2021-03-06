class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

 def index
     @movies = Movie.all
     @all_ratings = Movie.all_ratings
     @checked_ratings = Movie.all_ratings
    
     if params[:ratings] != nil #if a rating was clicked
     	@ratings_selected = params[:ratings].keys #set checked boxes(keys) to variable    
     	session[:rating_selections] = @ratings_selected #store the checked ratings in a session
     	@checked_ratings = session[:rating_selections] #set this session as a variable
     	
     end
     
     #@checked_ratings = session[:rating_selections] #set this session as a variable 
     
     if params[:title_sort] == 'title' #if the title header was clicked
     	session[:title_sort] = params[:title_sort] #store that in a session
     	session[:release_date_sort] = nil #release date cannot also be clicked, set session to nil
     	
     	
     elsif params[:release_date_sort] == 'release_date' #if the release date header is clicked
     	session[:release_date_sort] = params[:release_date_sort] #store that in a session
     	session[:title_sort] = nil #title cannot also be clicked, set session to nil
     
     end  
     
     if (session[:title_sort] != nil) #title was clicked and stored in session, show these movies in order with the specific ratings
     	@checked_ratings = session[:rating_selections] #set this session as a variable 
     	@movies = Movie.where(:rating=>@checked_ratings).order(session[:title_sort])	
     
     end
     if (session[:release_date_sort] != nil)
     	@checked_ratings = session[:rating_selections] #set this session as a variable
     	@movies = Movie.where(:rating=>@checked_ratings).order(session[:release_date_sort])
     	
     end
 end
  	
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    if @movie.save
    	flash[:notice] = "#{@movie.title} was successfully created."
    	redirect_to movies_path
    else
    	render 'new'
    end
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
