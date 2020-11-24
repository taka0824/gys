class EndUsers::SearchesController < ApplicationController
  before_action :authenticate_end_user!
  def ingredient_search
    @word = params[:word]
    @ingredients = Ingredient.where('name like ?',"%#{@word}%").joins(:smoothie_ingredients).group(:id).order('count(smoothie_ingredients.ingredient_id) desc')
  end

  def recipe_search
    @word = params[:word]
    @introductions = Smoothie.where('introduction like ?', "%#{@word}%")
    # smoothieテーブルのintroductionからスムージーの検索→取り出したものは全てsmoothieテーブルのレコード
    @ingredients = Ingredient.where('name like ?', "%#{@word}%")
    # ingredientテーブルのnameから材料の検索→取り出したものはingredient, このingredientがもつスムージーを最終的に渡す
    @smoothies = []
    @introductions.each do |i|
      @smoothies << i
    end
    @ingredients.each do |i|
      i.smoothies.each do |s|
        @smoothies << s
      end  
    end
    @smoothies = @smoothies.uniq
  end

end
