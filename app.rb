require('sinatra')
require('sinatra/activerecord')
require('sinatra/reloader')
also_reload('lib/*.rb')
require('./lib/recipe')
require('./lib/ingredient')
require('./lib/category')
require('pg')
require('pry')

get('/') do
  erb(:index)
end

get('/recipes') do
  @recipes = Recipe.all()
  erb(:recipe_list)
end

post('/add_recipe') do
  @recipes = Recipe.all()
  name = params.fetch("name")
  Recipe.create({:name => name})
  erb(:recipe_list)
end

get('/recipe/:id') do
  @recipe = Recipe.find(params.fetch("id"))
  erb(:recipe_detail)
end

post('/add_ingredient') do
  name = params.fetch("name")
  recipe_id = params.fetch("recipe_id")
  Ingredient.create({:name => name, :recipe_ids => recipe_id})
  @recipe = Recipe.find(recipe_id)
  erb(:recipe_detail)
end

patch('/recipe/:id') do
  instructions = params.fetch("instructions")
  @update_recipe = Recipe.find(params.fetch("id").to_i)
  @update_recipe.update({:instructions => instructions})
  @recipe = Recipe.find(params.fetch("id").to_i)
  erb(:recipe_detail)
end

get('/categories') do
  @categories = Category.all()
  erb(:category_list)
end

post('/add_category') do
  name = params.fetch("name")
  Category.create({:name => name})
  @categories = Category.all()
  erb(:category_list)
end

post('/recipe/add_category') do
  name = params.fetch("name")
  recipe_id = params.fetch("recipe_id")
  Category.create({:name => name, :recipe_ids => recipe_id})
  @recipe = Recipe.find(recipe_id)
  erb(:recipe_detail)
end

delete('/recipe/:id') do
  id = params.fetch("id")
  @recipe = Recipe.find(id)
  @recipe.destroy()
  @recipes = Recipe.all()
  erb(:recipe_list)
end
