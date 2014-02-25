class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

 def index
     @movies = Movie.all
     @all_ratings = Movie.all_ratings
    
     if params[:ratings] != nil #if a rating was clicked
     	@ratings_selected = params[:ratings].keys #set checked boxes(keys) to variable
     	#use Active Record to retrieve object
     	@movies = Movie.where(:rating =>@ratings_selected) # filter based on rating selections    
     	session[:rating_selections] = @ratings_selected #store the checked ratings in a session
     	
     end
     
     @checked_ratings = session[:rating_selections] #set this session as a variable 
     
     if session[:rating_selections] != nil #if there is something in the session, show those movies
     	@movies = Movie.where(:rating=>@checked_ratings)
     end
     
     
     if params[:title_sort] == 'title' #if the title header was clicked
     	session[:title_sort] = params[:title_sort] #store that in a session
     	session[:release_date_sort].clear #release date cannot also be clicked, clear session
     	#retrieve movies with the checked rating and sort by title
     	@movies = Movie.where(:rating=>@checked_ratings).order(session[:title_sort]) 
     	
     elsif params[:release_date_sort] == 'release_date' #if the release date header is clicked
     	session[:release_date_sort] = params[:release_date_sort] #store that in a session
     	session[:title_sort].clear #title cannot also be clicked, clear session
     	#retrieve movies with the checked rating and order by release date
     	@movies = Movie.where(:rating=>@checked_ratings).order(session[:release_date_sort])
     end  
     
     #if (session[:title_sort] != nil) && (params[:release_date_sort] == nil)  
     #	@movies = Movie.where(:rating=>@checked_ratings).order(session[:title_sort]	
     
     #elsif (session[:release_date_sort] != nil) && (params[:title_sort] == nil)
     #	@movies = Movie.where(:rating=>@checked_ratings).order(session[:release_date_sort])
     	
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
