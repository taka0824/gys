class Admins::IngredientsController < ApplicationController
  before_action :authenticate_admin!
  # before_action :exclude_string, only: [:confirm]
  # confirm画面に行く前にstring型があればnew画面に移遷するメソッドだが、入力内容が全て消えてしまうため使用しない予定
  # comfirm画面で確認してもらうようにする
  before_action :convert_nutrients_to_gram_per_100_gram, only: [:create, :update]


  def index
    @ingredients = Ingredient.all.order(created_at: "DESC").page(params[:page]).per(15)
  end

  def todays_ingredients
    range = Date.today.beginning_of_day..Date.today.end_of_day
    @ingredients = Ingredient.where(created_at: range).page(params[:page]).per(15)
  end

  def show
    @ingredient = Ingredient.find(params[:id])
  end

  def new
    @ingredient = Ingredient.new
  end

  def confirm
    redirect_to new_admins_ingredient_path and return if !params[:ingredient]
    # urlで飛んできた時にフォームを入力していないとフォーム入力画面に飛ばす
    @ingredient = Ingredient.new(ingredient_params)
    @gram = params[:ingredient][:gram]
    if params[:ingredient][:gram].to_f == 0.0 || params[:ingredient][:name] == ""
      flash[:warning] = "材料名と〜グラムあたりの栄養素量欄(半角数字)は必ず入力してください"
      redirect_to new_admins_ingredient_path
    end
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      flash[:success]  = "材料を作成しました"
      redirect_to admins_ingredient_path(@ingredient)
    end
  end

  def destroy
    ingredient = Ingredient.find(params[:id])
    ingredient.destroy
    if ingredient.created_by != nil
      end_user = ingredient.end_user
      end_user.rule_violation_number += 1
      end_user.save
      if end_user.rule_violation_number == 5
        end_user.smoothies.destroy_all
        end_user.comments.destroy_all
        end_user.favorites.destroy_all
        end_user.juicer_ingredients.destroy_all
        end_user.active_notifications.destroy_all
        end_user.update(is_deleted: true, name: "#{end_user.name}" + "(規約違反により退会)")
      end
    end
    flash[:success] = "材料を削除しました"
    redirect_to admins_ingredients_path
  end

  def update
    @ingredient = Ingredient.find(params[:id])
    if params[:ingredient][:gram].to_f == 0.0 || params[:ingredient][:name] == ""
      flash[:warning] = "材料名と〜グラムあたりの栄養素量欄(半角数字)は必ず入力してください"
      redirect_to admins_ingredient_path(@ingredient) and return
    end
    if @ingredient.update(ingredient_params)
      flash[:success] = "材料情報を変更しました"
      redirect_to request.referer
    end
  end

  private
  def ingredient_params
    params.require(:ingredient).permit(:name,:energy,:protein,:carb,:lipid,:vitamin_a,:vitamin_b1,:vitamin_b2,:vitamin_b6,:vitamin_b12,:vitamin_c,:vitamin_d,:vitamin_e,:vitamin_k)
  end

  def convert_nutrients_to_gram_per_100_gram
    # if文はupdateの時にstringを弾くために必要な記述。createの際はconfirmアクション内で既に変数にparamsで入れているためstring型は全て0.0に置き換えられているのでcreateアクションでifで弾かれることはない
    if params[:ingredient][:energy] == "0" || params[:ingredient][:energy] == "0.0" || params[:ingredient][:energy] == "" || params[:ingredient][:energy].to_f != 0.0
      params[:ingredient][:energy] = (params[:ingredient][:energy].to_f) * (100 / (params[:ingredient][:gram].to_f))
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:protein] == "0" || params[:ingredient][:protein] == "0.0" || params[:ingredient][:protein] == "" || params[:ingredient][:protein].to_f != 0.0
      params[:ingredient][:protein] = (params[:ingredient][:protein].to_f) * (100 / (params[:ingredient][:gram].to_f))
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:carb] == "0" || params[:ingredient][:carb] == "0.0" || params[:ingredient][:carb] == "" || params[:ingredient][:carb].to_f != 0.0
      params[:ingredient][:carb] = (params[:ingredient][:carb].to_f) * (100 / (params[:ingredient][:gram].to_f))
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:lipid] == "0" || params[:ingredient][:lipid] == "0.0" || params[:ingredient][:lipid] == "" || params[:ingredient][:lipid].to_f != 0.0
      params[:ingredient][:lipid] = (params[:ingredient][:lipid].to_f) * (100 / (params[:ingredient][:gram].to_f))
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:vitamin_b1] == "0" || params[:ingredient][:vitamin_b1] == "0.0" || params[:ingredient][:vitamin_b1] == "" || params[:ingredient][:vitamin_b1].to_f != 0.0
      params[:ingredient][:vitamin_b1] = (params[:ingredient][:vitamin_b1].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:vitamin_b2] == "0" || params[:ingredient][:vitamin_b2] == "0.0" || params[:ingredient][:vitamin_b2] == "" || params[:ingredient][:vitamin_b2].to_f != 0.0
      params[:ingredient][:vitamin_b2] = (params[:ingredient][:vitamin_b2].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:vitamin_b6] == "0" || params[:ingredient][:vitamin_b6] == "0.0" || params[:ingredient][:vitamin_b6] == "" || params[:ingredient][:vitamin_b6].to_f != 0.0
      params[:ingredient][:vitamin_b6] = (params[:ingredient][:vitamin_b6].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:vitamin_c] == "0" || params[:ingredient][:vitamin_c] == "0.0" || params[:ingredient][:vitamin_c] == "" || params[:ingredient][:vitamin_c].to_f != 0.0
      params[:ingredient][:vitamin_c] = (params[:ingredient][:vitamin_c].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:vitamin_e] == "0" || params[:ingredient][:vitamin_e] == "0.0" || params[:ingredient][:vitamin_e] == "" || params[:ingredient][:vitamin_e].to_f != 0.0
      params[:ingredient][:vitamin_e] = (params[:ingredient][:vitamin_e].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:vitamin_a] == "0" || params[:ingredient][:vitamin_a] == "0.0" || params[:ingredient][:vitamin_a] == "" || params[:ingredient][:vitamin_a].to_f != 0.0
      params[:ingredient][:vitamin_a] = (params[:ingredient][:vitamin_a].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000000
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:vitamin_b12] == "0" || params[:ingredient][:vitamin_b12] == "0.0" || params[:ingredient][:vitamin_b12] == "" || params[:ingredient][:vitamin_b12].to_f != 0.0
      params[:ingredient][:vitamin_b12] = (params[:ingredient][:vitamin_b12].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000000
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:vitamin_d] == "0" || params[:ingredient][:vitamin_d] == "0.0" || params[:ingredient][:vitamin_d] == "" || params[:ingredient][:vitamin_d].to_f != 0.0
      params[:ingredient][:vitamin_d] = (params[:ingredient][:vitamin_d].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000000
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
    if params[:ingredient][:vitamin_k] == "0" || params[:ingredient][:vitamin_k] == "0.0" || params[:ingredient][:vitamin_k] == "" || params[:ingredient][:vitamin_k].to_f != 0.0
      params[:ingredient][:vitamin_k] = (params[:ingredient][:vitamin_k].to_f) * (100 / (params[:ingredient][:gram].to_f)) / 1000000
    else
      flash[:warning] = "数値は半角数字でご入力ください"
      redirect_to request.referer and return
    end
  end
  
  # def exclude_string
  #   if params[:ingredient][:energy] != "0" && params[:ingredient][:energy] != "0.0" && params[:ingredient][:energy] != "" && params[:ingredient][:energy].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:protein] != "0" && params[:ingredient][:protein] != "0.0" && params[:ingredient][:protein] != "" && params[:ingredient][:protein].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:carb] != "0" && params[:ingredient][:carb] != "0.0" && params[:ingredient][:carb] != "" && params[:ingredient][:carb].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:lipid] != "0" && params[:ingredient][:lipid] != "0.0" && params[:ingredient][:lipid] != "" && params[:ingredient][:lipid].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:vitamin_b1] != "0" && params[:ingredient][:vitamin_b1] != "0.0" && params[:ingredient][:vitamin_b1] != "" && params[:ingredient][:vitamin_b1].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:vitamin_b2] != "0" && params[:ingredient][:vitamin_b2] != "0.0" && params[:ingredient][:vitamin_b2] != "" && params[:ingredient][:vitamin_b2].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:vitamin_b6] != "0" && params[:ingredient][:vitamin_b6] != "0.0" && params[:ingredient][:vitamin_b6] != "" && params[:ingredient][:vitamin_b6].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:vitamin_c] != "0" && params[:ingredient][:vitamin_c] != "0.0" && params[:ingredient][:vitamin_c] != "" && params[:ingredient][:vitamin_c].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:vitamin_e] != "0" && params[:ingredient][:vitamin_e] != "0.0" && params[:ingredient][:vitamin_e] != "" && params[:ingredient][:vitamin_e].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:vitamin_a] != "0" && params[:ingredient][:vitamin_a] != "0.0" && params[:ingredient][:vitamin_a] != "" && params[:ingredient][:vitamin_a].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:vitamin_b12] != "0" && params[:ingredient][:vitamin_b12] != "0.0" && params[:ingredient][:vitamin_b12] != "" && params[:ingredient][:vitamin_b12].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:vitamin_d] != "0" && params[:ingredient][:vitamin_d] != "0.0" && params[:ingredient][:vitamin_d] != "" && params[:ingredient][:vitamin_d].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  #   if params[:ingredient][:vitamin_k] != "0" && params[:ingredient][:vitamin_k] != "0.0" && params[:ingredient][:vitamin_k] != "" && params[:ingredient][:vitamin_k].to_f == 0.0
  #     flash[:warning] = "数値は半角数字でご入力ください"
  #     redirect_to request.referer and return
  #   end
  # end
end
