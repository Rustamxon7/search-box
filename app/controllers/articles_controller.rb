class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index
    respond_to_index(params[:query])

    @arguments = Argument.most_searched
  end

  def suggestions
    respond_to_suggestions(params[:query])
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    unless current_user
      redirect_to new_user_session_path, notice: "You must be logged in to create an article."
      return
    end

    @article = Article.new(article_params)
    @article.user = current_user

    respond_to do |format|
      if @article.save
        format.html { redirect_to articles_url, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, :user_id)
    end

    def respond_to_index(query)
      if query.present?
        @articles = Article.search(query)
  
        respond_to do |format|
          format.turbo_stream {
            render turbo_stream: turbo_stream.update(
              "articles",
              partial: "articles/articles",
              locals: { articles: @articles }
            )
          }
          format.html { render :index }
        end
      else
         @articles = Article.all
      end
    end

    def respond_to_suggestions(query)
      if query.present?
        @arguments = Argument.search_and_score(query).most_searched

        respond_to do |format|
          format.turbo_stream {
            render turbo_stream: turbo_stream.update(
              "arguments",
              partial: "articles/arguments",
              locals: { arguments: @arguments }
            )
          }
          format.html { render :arguments }
        end
      else
        @arguments = Argument.most_searched
      end
    end
end
