class SmoothieIngredient < ApplicationRecord
  belongs_to :smoothie
  belongs_to :ingredient


  def self.total_nutrient_to_gram(vitamin)
      array = []
      self.all.each do |smoothie_ingredient|
        array << smoothie_ingredient.ingredient[vitamin].to_f * smoothie_ingredient.amount
      end
      (array.sum / 100).floor(3)
  end

  def self.total_nutrient_to_mili(vitamin)
    array = []
    self.all.each do |smoothie_ingredient|
      array << smoothie_ingredient.ingredient[vitamin].to_f * 1000 * smoothie_ingredient.amount
    end
    (array.sum / 100).floor(3)
  end

  def self.total_nutrient_to_micro(vitamin)
    array = []
    self.all.each do |smoothie_ingredient|
      array << smoothie_ingredient.ingredient[vitamin].to_f * 1000000 * smoothie_ingredient.amount
    end
    (array.sum / 100).floor(3)
  end
end