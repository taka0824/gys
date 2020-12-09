class EndUsers::IngredientsController < ApplicationController
  before_action :authenticate_end_user!
  before_action :check_data_type, only: [:confirm, :update]
  before_action :convert_nutrients_to_gram_per_100_gram, only: [:create, :update]

  def index
    frequent_ingredients = Ingredient.joins(:smoothie_ingredients).group(:id).order('count(smoothie_ingredients.ingredient_id) desc')
    all_ingredients = Ingredient.all
    @ingredients = []
    frequent_ingredients.each do |f|
      @ingredients << f
    end
    all_ingredients.each do |a|
      @ingredients << a
    end
    @ingredients = @ingredients.uniq
    @ingredients = Kaminari.paginate_array(@ingredients).page(params[:page]).per(15)
  end

  def show
    @ingredient = Ingredient.find(params[:id])
    @juicer_ingredient = JuicerIngredient.new
  end

  def edit
    @ingredient = Ingredient.find(params[:id])
  end

  def update
    @ingredient = Ingredient.find(params[:id])
    if (/\A[1-9]\d{0,3}((\.)([1-9]|\d[1-9]|\d{2}[1-9]))?\z/ =~ params[:ingredient][:gram]) != 0 || params[:ingredient][:name] == ""
      flash[:warning] = "材料名と〜グラムあたりの栄養素量欄(半角数字)は必ず入力してください"
      redirect_to edit_end_users_ingredient_path(@ingredient) and return
    end
    if @ingredient.update(ingredient_params)
      flash[:success] = "材料情報を変更しました"
      redirect_to edit_end_users_ingredient_path(@ingredient)
    end
  end

  def destroy
    Ingredient.find(params[:id]).destroy
    flash[:success] = "材料を削除しました"
    if current_end_user.ingredients.any?
      redirect_to ingredient_list_end_users_end_user_path(current_end_user)
    else
      redirect_to end_users_end_user_path(current_end_user)
    end
  end

  def new
    @ingredient = Ingredient.new
  end

  def confirm
    redirect_to new_end_users_ingredient_path and return if !params[:ingredient]
    @gram = params[:ingredient][:gram]
    if (/\A[1-9]\d{0,3}((\.)([1-9]|\d[1-9]|\d{2}[1-9]))?\z/ =~ params[:ingredient][:gram]) != 0 || params[:ingredient][:name] == ""
      flash.now[:warning] = "材料名と〜グラムあたりの栄養素量欄(半角数字)を必ず入力してください"
      @ingredient = Ingredient.new(ingredient_params)
      render "end_users/ingredients/new"
    end
    @ingredient = Ingredient.new(ingredient_params)
  end

  def create
    @ingredient = current_end_user.ingredients.new(ingredient_params)
    # p @ingredient
    if @ingredient.save
      flash[:success] = "材料を追加しました"
      redirect_to end_users_ingredient_path(@ingredient)
    end
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name,:energy,:protein,:carb,:lipid,:vitamin_a,:vitamin_b1,:vitamin_b2,:vitamin_b6,:vitamin_b12,:vitamin_c,:vitamin_d,:vitamin_e,:vitamin_k)
  end

  def check_data_type
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:energy]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:protein]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:carb]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:lipid]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:vitamin_a]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:vitamin_b1]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:vitamin_b2]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:vitamin_b6]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:vitamin_b12]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:vitamin_c]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:vitamin_d]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:vitamin_e]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
    if (/\A\d{0,4}((\.)([0-9]|\d[1-9]|\d{1,2}[1-9]|))?\z/ =~ params[:ingredient][:vitamin_k]) != 0
      if params[:confirm] == "追加"
        flash.now[:warning] = "数値は半角数字でご入力ください"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        flash[:warning] = "数値は半角数字でご入力ください"
        redirect_to request.referer
      end
    end
  end

  def convert_nutrients_to_gram_per_100_gram
      if params[:createback] == "修正する"
        @ingredient = current_end_user.ingredients.new(ingredient_params)
        @gram = params[:ingredient][:gram]
        return render "end_users/ingredients/new"
      else
        params[:ingredient][:energy] = (params[:ingredient][:energy].to_f) * (100 / (params[:ingredient][:gram].to_f))
        params[:ingredient][:protein] = (params[:ingredient][:protein].to_f) * (100 / (params[:ingredient][:gram].to_f))
        params[:ingredient][:carb] = (params[:ingredient][:carb].to_f) * (100 / (params[:ingredient][:gram].to_f))
        params[:ingredient][:lipid] = (params[:ingredient][:lipid].to_f) * (100 / (params[:ingredient][:gram].to_f))
        params[:ingredient][:vitamin_a] = (params[:ingredient][:vitamin_a].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000000
        params[:ingredient][:vitamin_b1] = (params[:ingredient][:vitamin_b1].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000
        params[:ingredient][:vitamin_b2] = (params[:ingredient][:vitamin_b2].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000
        params[:ingredient][:vitamin_b6] = (params[:ingredient][:vitamin_b6].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000
        params[:ingredient][:vitamin_b12] = (params[:ingredient][:vitamin_b12].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000000
        params[:ingredient][:vitamin_c] = (params[:ingredient][:vitamin_c].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000
        params[:ingredient][:vitamin_d] = (params[:ingredient][:vitamin_d].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000000
        params[:ingredient][:vitamin_e] = (params[:ingredient][:vitamin_e].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000
        params[:ingredient][:vitamin_k] = (params[:ingredient][:vitamin_k].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000000
      end
  end

end