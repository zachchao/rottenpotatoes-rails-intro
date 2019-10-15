class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if !session.has_key?(:ratings)
      session[:ratings] = Movie.uniq.pluck(:rating)
      flash[:notice] = session.keys.to_s
    end

    @all_ratings = Movie.uniq.pluck(:rating)
    @change = false

    if params.has_key?(:ratings)
      @clicked_ratings = params[:ratings].keys
      if @clicked_ratings != session[:ratings]
        @change = true
      end
      session[:ratings] = @clicked_ratings
    else
      @clicked_ratings = session[:ratings]
    end

    if params.has_key?(:sort_by)
      @sort_by = params[:sort_by]
      if @sort_by != session[:sort_by]
        @change = true
      end
      session[:sort_by] = @sort_by
    else
      @sort_by = session[:sort_by]
    end

    if @change
      redirect_to movies_path(params)
    end

    if @sort_by == 'title'
      @movies = Movie.with_ratings(@clicked_ratings).order(title: :asc)
    elsif @sort_by == 'release_date'
      @movies = Movie.with_ratings(@clicked_ratings).order(release_date: :asc)
    else
      @movies = Movie.with_ratings(@clicked_ratings)
    end
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

end
