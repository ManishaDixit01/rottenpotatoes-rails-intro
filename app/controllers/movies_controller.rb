class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.get_unique_ratings
    
    if params.key?(:ratings)
      session[:ratings] = params[:ratings].keys
    end
    if session.key?(:ratings)
      @checked_movies = session[:ratings]
      @movies = @movies.where(rating: @checked_movies)
    else
      @checked_movies = @all_ratings
    end
    if params.key?(:sort_by)
      session[:sort_by] = params[:sort_by]
    end
    
    if session[:sort_by] == 'title'
      @movies = @movies.order(:title)
      @sorted_by = 'title'
    elsif session[:sort_by] == 'release_date'
      @movies = @movies.order(:release_date)
      @sorted_by = 'release_date'
    end
    flash.keep
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
